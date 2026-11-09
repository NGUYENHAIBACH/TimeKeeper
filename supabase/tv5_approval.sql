-- Run in Supabase SQL Editor after schema.sql.
-- TV5 approval workflow: atomic decision effects + request notifications.

create or replace function public.tv5_decide_request(
  p_table text, p_id uuid, p_actor uuid, p_approve boolean, p_reason text default ''
)
returns void language plpgsql security invoker set search_path = public as $$
declare
  actor public.profiles;
  request_row record;
  attendance_row public.attendance_records;
  final_check_in timestamptz;
  final_check_out timestamptz;
begin
  if p_table not in ('ot_requests', 'leave_requests', 'attendance_corrections') then
    raise exception 'Invalid request type';
  end if;
  select * into actor from public.profiles where id = p_actor;
  if actor.id is null or actor.role not in ('manager', 'admin') then
    raise exception 'Unauthorized manager';
  end if;
  -- Firebase third-party auth: authenticated JWT must belong to this profile.
  -- The project still uses anon during development, with role/team checks below.
  if auth.role() = 'authenticated'
     and actor.firebase_uid is distinct from auth.jwt() ->> 'sub' then
    raise exception 'Authenticated user does not match actor';
  end if;
  if not p_approve and length(trim(p_reason)) = 0 then
    raise exception 'Rejection reason required';
  end if;

  execute format('select * from public.%I where id = $1 for update', p_table)
    into request_row using p_id;
  if request_row.id is null then raise exception 'Request not found'; end if;
  if request_row.status <> 'pending' then raise exception 'Request already processed'; end if;
  if request_row.employee_id = actor.id or not exists (
    select 1 from public.profiles p
    where p.id = request_row.employee_id
      and (p.manager_id = actor.id or actor.role = 'admin')
  ) then
    raise exception 'Request outside team';
  end if;

  -- Leave approval updates the yearly balance exactly once in this transaction.
  if p_approve and p_table = 'leave_requests' then
    insert into public.leave_balances (
      employee_id, leave_type_id, year, total_days, used_days
    )
    select request_row.employee_id, request_row.leave_type_id,
      extract(year from request_row.start_date)::int,
      lt.default_days, request_row.total_days
    from public.leave_types lt where lt.id = request_row.leave_type_id
    on conflict (employee_id, leave_type_id, year)
    do update set used_days = public.leave_balances.used_days + excluded.used_days;
  end if;

  -- Correction approval applies requested times to the employee's daily record.
  if p_approve and p_table = 'attendance_corrections' then
    select * into attendance_row
    from public.attendance_records ar
    where ar.employee_id = request_row.employee_id
      and ((request_row.attendance_id is not null and ar.id = request_row.attendance_id)
        or ar.work_date = request_row.work_date)
    order by (ar.id = request_row.attendance_id) desc
    limit 1 for update;

    final_check_in := coalesce(request_row.requested_check_in, attendance_row.check_in_at);
    final_check_out := coalesce(request_row.requested_check_out, attendance_row.check_out_at);
    if final_check_in is not null and final_check_out is not null
       and final_check_out < final_check_in then
      raise exception 'Check-out must be after check-in';
    end if;

    insert into public.attendance_records as ar (
      employee_id, work_date, check_in_at, check_out_at, work_hours, status, note
    ) values (
      request_row.employee_id, request_row.work_date, final_check_in, final_check_out,
      case when final_check_in is not null and final_check_out is not null
        then round((extract(epoch from (final_check_out - final_check_in)) / 3600)::numeric, 2)
        else 0 end,
      'present', 'Cập nhật từ đơn bù công ' || p_id::text
    )
    on conflict (employee_id, work_date) do update set
      check_in_at = coalesce(excluded.check_in_at, ar.check_in_at),
      check_out_at = coalesce(excluded.check_out_at, ar.check_out_at),
      work_hours = case
        when coalesce(excluded.check_in_at, ar.check_in_at) is not null
         and coalesce(excluded.check_out_at, ar.check_out_at) is not null
        then round((extract(epoch from (
          coalesce(excluded.check_out_at, ar.check_out_at)
          - coalesce(excluded.check_in_at, ar.check_in_at)
        )) / 3600)::numeric, 2)
        else ar.work_hours end,
      status = case when ar.status = 'absent' then 'present' else ar.status end,
      note = excluded.note
    returning * into attendance_row;

    update public.attendance_corrections set attendance_id = attendance_row.id where id = p_id;
  end if;

  execute format(
    'update public.%I set status = $1, approved_by = $2, approved_at = now(), reject_reason = $3 where id = $4',
    p_table
  ) using case when p_approve then 'approved' else 'rejected' end, p_actor,
    case when p_approve then null else trim(p_reason) end, p_id;

  insert into public.notifications (recipient_id, title, body, type, ref_table, ref_id)
  values (
    request_row.employee_id,
    case when p_approve then 'Đơn đã được duyệt' else 'Đơn bị từ chối' end,
    case when p_approve then 'Quản lý đã duyệt đơn của bạn.'
      else 'Quản lý đã từ chối đơn: ' || trim(p_reason) end,
    case p_table when 'ot_requests' then 'ot'
      when 'leave_requests' then 'leave' else 'correction' end,
    p_table, p_id
  );
end; $$;

revoke all on function public.tv5_decide_request(text, uuid, uuid, boolean, text) from public;
grant execute on function public.tv5_decide_request(text, uuid, uuid, boolean, text)
  to anon, authenticated;

-- Notify the direct manager whenever an employee submits a pending request.
create or replace function public.tv5_notify_manager_on_request()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  recipient uuid;
  employee_name text;
  request_label text;
  notification_type text;
begin
  if new.status <> 'pending' then return new; end if;
  select p.manager_id, coalesce(nullif(trim(p.full_name), ''), p.email)
    into recipient, employee_name from public.profiles p where p.id = new.employee_id;
  if recipient is null then return new; end if;

  request_label := case tg_table_name when 'ot_requests' then 'đơn tăng ca'
    when 'leave_requests' then 'đơn nghỉ phép' else 'đơn bù công' end;
  notification_type := case tg_table_name when 'ot_requests' then 'ot'
    when 'leave_requests' then 'leave' else 'correction' end;
  insert into public.notifications (recipient_id, title, body, type, ref_table, ref_id)
  values (recipient, 'Có ' || request_label || ' mới',
    employee_name || ' vừa gửi ' || request_label || ' cần duyệt.',
    notification_type, tg_table_name, new.id);
  return new;
end; $$;

drop trigger if exists tv5_notify_manager_ot on public.ot_requests;
create trigger tv5_notify_manager_ot after insert on public.ot_requests
for each row execute function public.tv5_notify_manager_on_request();
drop trigger if exists tv5_notify_manager_leave on public.leave_requests;
create trigger tv5_notify_manager_leave after insert on public.leave_requests
for each row execute function public.tv5_notify_manager_on_request();
drop trigger if exists tv5_notify_manager_correction on public.attendance_corrections;
create trigger tv5_notify_manager_correction after insert on public.attendance_corrections
for each row execute function public.tv5_notify_manager_on_request();
