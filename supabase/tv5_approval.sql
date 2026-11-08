-- Run in Supabase SQL Editor after schema.sql.
-- Requires Supabase Firebase third-party auth: JWT sub must match firebase_uid.
create or replace function public.tv5_decide_request(p_table text, p_id uuid, p_actor uuid, p_approve boolean, p_reason text default '')
returns void language plpgsql security invoker set search_path = public as $$
declare actor profiles; request_row record;
begin
 if p_table not in ('ot_requests','leave_requests','attendance_corrections') then raise exception 'Invalid request type'; end if;
 select * into actor from profiles where id=p_actor;
 if actor.id is null or actor.role not in ('manager','admin') or actor.firebase_uid is distinct from auth.jwt()->>'sub' then raise exception 'Unauthorized manager'; end if;
 if not p_approve and length(trim(p_reason))=0 then raise exception 'Rejection reason required'; end if;
 execute format('select * from %I where id=$1 for update',p_table) into request_row using p_id;
 if request_row.id is null then raise exception 'Request not found'; end if;
 if request_row.status <> 'pending' then raise exception 'Request already processed'; end if;
 if request_row.employee_id=actor.id or not exists(select 1 from profiles where id=request_row.employee_id and (manager_id=actor.id or actor.role='admin')) then raise exception 'Request outside team'; end if;
 execute format('update %I set status=$1, approved_by=$2, approved_at=now(), reject_reason=$3 where id=$4',p_table)
 using case when p_approve then 'approved' else 'rejected' end,p_actor,case when p_approve then null else trim(p_reason) end,p_id;
 insert into notifications(recipient_id,title,body,type,ref_table,ref_id)
 values(request_row.employee_id,case when p_approve then 'Đơn đã được duyệt' else 'Đơn bị từ chối' end,case when p_approve then 'Quản lý đã duyệt đơn của bạn.' else p_reason end,case p_table when 'ot_requests' then 'ot' when 'leave_requests' then 'leave' else 'correction' end,p_table,p_id);
end; $$;
revoke all on function public.tv5_decide_request(text,uuid,uuid,boolean,text) from public, anon;
grant execute on function public.tv5_decide_request(text,uuid,uuid,boolean,text) to authenticated;
