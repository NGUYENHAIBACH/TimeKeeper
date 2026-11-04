-- =====================================================================
-- TimeKeeper (PRM393) - FULL SCHEMA cho ca nhom (13 bang)
-- Chay file nay trong Supabase Dashboard > SQL Editor. Co the chay lai
-- nhieu lan (dung IF NOT EXISTS / DROP IF EXISTS).
--
-- QUY UOC CHUNG (ca nhom bam theo):
--   - Khoa chinh: id uuid default gen_random_uuid()
--   - Cot nhan vien: employee_id uuid references profiles(id)
--     (app lay profiles.id 1 lan sau khi dang nhap, KHONG dung firebase_uid
--      lam khoa ngoai)
--   - Trang thai don: 'pending' | 'approved' | 'rejected' | 'cancelled'
--   - Nguoi duyet: approved_by uuid references profiles(id), approved_at
--   - Thoi gian: timestamptz; ngay: date; gio trong ngay: time
--   - RLS bat, policy "dev_all_<bang>" cho anon (Cach A - ghi vao bao cao)
--
-- PHAN CONG:
--   TV1: departments, shifts, profiles
--   TV2: office_locations, attendance_records, attendance_corrections
--   TV3: ot_requests
--   TV4: leave_types, leave_balances, leave_requests, holidays
--   TV5: notifications, fcm_tokens
-- Moi nguoi duoc sua cot trong bang cua minh; doi ten bang / kieu khoa thi
-- bao ca nhom.
-- =====================================================================

-- ---------- Ham dung chung: tu cap nhat updated_at ----------
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =====================================================================
-- TV1: departments, shifts, profiles
-- =====================================================================

-- Phong ban
create table if not exists departments (
  id   uuid primary key default gen_random_uuid(),
  name text not null unique
);

-- Ca lam viec
create table if not exists shifts (
  id            uuid primary key default gen_random_uuid(),
  name          text not null unique,
  start_time    time not null,
  end_time      time not null,
  grace_minutes int  not null default 5   -- so phut di tre duoc chap nhan
);

-- Ho so nhan vien, lien ket voi Firebase Auth qua firebase_uid
create table if not exists profiles (
  id            uuid primary key default gen_random_uuid(),
  firebase_uid  text not null unique,
  email         text not null,
  full_name     text,
  phone         text,
  avatar_url    text,                        -- link anh trong bucket "avatars"
  role          text not null default 'employee'
                check (role in ('employee', 'manager', 'admin')),
  department_id uuid references departments(id) on delete set null,
  manager_id    uuid references profiles(id)    on delete set null,
  shift_id      uuid references shifts(id)      on delete set null,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists profiles_manager_id_idx    on profiles(manager_id);
create index if not exists profiles_department_id_idx on profiles(department_id);
drop trigger if exists profiles_set_updated_at on profiles;
create trigger profiles_set_updated_at before update on profiles
  for each row execute function set_updated_at();

-- =====================================================================
-- TV2: office_locations, attendance_records, attendance_corrections
-- =====================================================================

-- Van phong (toa do de kiem tra geofence)
create table if not exists office_locations (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  address       text,
  latitude      double precision not null,
  longitude     double precision not null,
  radius_meters int not null default 100,
  is_active     boolean not null default true
);

-- Ban ghi cham cong: 1 dong / nhan vien / ngay
create table if not exists attendance_records (
  id                  uuid primary key default gen_random_uuid(),
  employee_id         uuid not null references profiles(id) on delete cascade,
  work_date           date not null,
  check_in_at         timestamptz,
  check_out_at        timestamptz,
  check_in_lat        double precision,
  check_in_lng        double precision,
  check_out_lat       double precision,
  check_out_lng       double precision,
  office_id           uuid references office_locations(id) on delete set null,
  late_minutes        int not null default 0,
  early_leave_minutes int not null default 0,
  work_hours          numeric(5,2) not null default 0,   -- so gio lam tinh duoc
  status              text not null default 'present'
                      check (status in ('present','late','absent','leave','holiday')),
  is_mocked_location  boolean not null default false,    -- phat hien fake GPS
  note                text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  unique (employee_id, work_date)
);
create index if not exists attendance_records_employee_date_idx
  on attendance_records(employee_id, work_date);
drop trigger if exists attendance_records_set_updated_at on attendance_records;
create trigger attendance_records_set_updated_at before update on attendance_records
  for each row execute function set_updated_at();

-- Don bu cong (quen check-in/out)
create table if not exists attendance_corrections (
  id                  uuid primary key default gen_random_uuid(),
  employee_id         uuid not null references profiles(id) on delete cascade,
  work_date           date not null,
  attendance_id       uuid references attendance_records(id) on delete set null,
  requested_check_in  timestamptz,
  requested_check_out timestamptz,
  reason              text not null,
  status              text not null default 'pending'
                      check (status in ('pending','approved','rejected','cancelled')),
  approved_by         uuid references profiles(id) on delete set null,
  approved_at         timestamptz,
  reject_reason       text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create index if not exists attendance_corrections_employee_idx on attendance_corrections(employee_id);
create index if not exists attendance_corrections_status_idx   on attendance_corrections(status);
drop trigger if exists attendance_corrections_set_updated_at on attendance_corrections;
create trigger attendance_corrections_set_updated_at before update on attendance_corrections
  for each row execute function set_updated_at();

-- =====================================================================
-- TV3: ot_requests
-- =====================================================================

-- Don tang ca. He so: 1.5 ngay thuong, 2.0 cuoi tuan, 3.0 ngay le
create table if not exists ot_requests (
  id            uuid primary key default gen_random_uuid(),
  employee_id   uuid not null references profiles(id) on delete cascade,
  ot_date       date not null,
  start_time    time not null,
  end_time      time not null,
  hours         numeric(5,2) not null check (hours > 0),
  ot_type       text not null default 'weekday'
                check (ot_type in ('weekday','weekend','holiday')),
  multiplier    numeric(3,2) not null default 1.5,     -- 1.5 / 2.0 / 3.0
  paid_hours    numeric(6,2) generated always as (hours * multiplier) stored,
  reason        text not null,
  status        text not null default 'pending'
                check (status in ('pending','approved','rejected','cancelled')),
  approved_by   uuid references profiles(id) on delete set null,
  approved_at   timestamptz,
  reject_reason text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists ot_requests_employee_date_idx on ot_requests(employee_id, ot_date);
create index if not exists ot_requests_status_idx        on ot_requests(status);
drop trigger if exists ot_requests_set_updated_at on ot_requests;
create trigger ot_requests_set_updated_at before update on ot_requests
  for each row execute function set_updated_at();

-- =====================================================================
-- TV4: leave_types, leave_balances, leave_requests, holidays
-- =====================================================================

-- Loai nghi phep
create table if not exists leave_types (
  id                uuid primary key default gen_random_uuid(),
  code              text not null unique,     -- 'annual', 'sick', 'unpaid', ...
  name              text not null,
  default_days      numeric(4,1) not null default 0,  -- so ngay cap moi nam
  is_paid           boolean not null default true,
  requires_document boolean not null default false
);

-- So du phep: 1 dong / nhan vien / loai phep / nam
create table if not exists leave_balances (
  id             uuid primary key default gen_random_uuid(),
  employee_id    uuid not null references profiles(id) on delete cascade,
  leave_type_id  uuid not null references leave_types(id) on delete cascade,
  year           int not null,
  total_days     numeric(4,1) not null default 0,
  used_days      numeric(4,1) not null default 0,
  remaining_days numeric(4,1) generated always as (total_days - used_days) stored,
  updated_at     timestamptz not null default now(),
  unique (employee_id, leave_type_id, year)
);
drop trigger if exists leave_balances_set_updated_at on leave_balances;
create trigger leave_balances_set_updated_at before update on leave_balances
  for each row execute function set_updated_at();

-- Ngay le (bo qua khi tinh so ngay nghi, OT he so 3.0)
create table if not exists holidays (
  id           uuid primary key default gen_random_uuid(),
  holiday_date date not null unique,
  name         text not null
);

-- Don xin nghi
create table if not exists leave_requests (
  id             uuid primary key default gen_random_uuid(),
  employee_id    uuid not null references profiles(id) on delete cascade,
  leave_type_id  uuid not null references leave_types(id),
  start_date     date not null,
  end_date       date not null check (end_date >= start_date),
  half_day       text not null default 'none'
                 check (half_day in ('none','morning','afternoon')), -- nghi nua ngay
  total_days     numeric(4,1) not null,    -- da tru cuoi tuan + ngay le
  reason         text not null,
  attachment_url text,                     -- file trong bucket "leave_documents"
  status         text not null default 'pending'
                 check (status in ('pending','approved','rejected','cancelled')),
  approved_by    uuid references profiles(id) on delete set null,
  approved_at    timestamptz,
  reject_reason  text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
create index if not exists leave_requests_employee_idx on leave_requests(employee_id);
create index if not exists leave_requests_status_idx   on leave_requests(status);
create index if not exists leave_requests_dates_idx    on leave_requests(start_date, end_date);
drop trigger if exists leave_requests_set_updated_at on leave_requests;
create trigger leave_requests_set_updated_at before update on leave_requests
  for each row execute function set_updated_at();

-- =====================================================================
-- TV5: notifications, fcm_tokens
-- =====================================================================

-- Thong bao trong app (Notification Center); dung Supabase Realtime
create table if not exists notifications (
  id           uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references profiles(id) on delete cascade,
  title        text not null,
  body         text not null,
  type         text not null default 'general'
               check (type in ('general','ot','leave','correction','attendance','reminder')),
  ref_table    text,        -- 'ot_requests' | 'leave_requests' | 'attendance_corrections'
  ref_id       uuid,        -- id cua don lien quan
  is_read      boolean not null default false,
  created_at   timestamptz not null default now()
);
create index if not exists notifications_recipient_idx
  on notifications(recipient_id, is_read, created_at desc);

-- Token FCM cua tung thiet bi
create table if not exists fcm_tokens (
  id          uuid primary key default gen_random_uuid(),
  employee_id uuid not null references profiles(id) on delete cascade,
  token       text not null unique,
  platform    text not null default 'android' check (platform in ('android','ios','web')),
  updated_at  timestamptz not null default now()
);
create index if not exists fcm_tokens_employee_idx on fcm_tokens(employee_id);

-- Bat Realtime cho notifications (TV5)
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and tablename = 'notifications'
  ) then
    alter publication supabase_realtime add table notifications;
  end if;
end $$;

-- =====================================================================
-- RLS (Cach A): bat RLS, policy cho phep anon + authenticated khi dev
-- =====================================================================
do $$
declare
  t text;
begin
  foreach t in array array[
    'departments','shifts','profiles',
    'office_locations','attendance_records','attendance_corrections',
    'ot_requests',
    'leave_types','leave_balances','leave_requests','holidays',
    'notifications','fcm_tokens'
  ] loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists dev_all_%I on %I', t, t);
    execute format(
      'create policy dev_all_%I on %I for all to anon, authenticated using (true) with check (true)',
      t, t);
  end loop;
end $$;

-- =====================================================================
-- Storage: bucket avatars (TV1) va leave_documents (TV4)
-- =====================================================================
insert into storage.buckets (id, name, public) values
  ('avatars', 'avatars', true),
  ('leave_documents', 'leave_documents', true)
on conflict (id) do nothing;

drop policy if exists dev_all_avatars on storage.objects;
create policy dev_all_avatars on storage.objects
  for all to anon, authenticated
  using (bucket_id = 'avatars') with check (bucket_id = 'avatars');

drop policy if exists dev_all_leave_documents on storage.objects;
create policy dev_all_leave_documents on storage.objects
  for all to anon, authenticated
  using (bucket_id = 'leave_documents') with check (bucket_id = 'leave_documents');
