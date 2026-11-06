-- =====================================================================
-- TimeKeeper - DU LIEU DEMO (chay SAU schema.sql va seed.sql)
-- Dung de cac man hinh co so lieu khi demo / review.
--
-- Dieu kien: da co 2 tai khoan dang nhap app it nhat 1 lan
--   nhanvien.a@timekeeper.vn  (nhan vien)
--   quanly.b@timekeeper.vn    (quan ly)
-- Thieu tai khoan nao thi phan du lieu cua tai khoan do tu dong bi bo qua.
--
-- Chay lai nhieu lan khong bi trung: cham cong upsert theo
-- (employee_id, work_date); cac don va thong bao dung id co dinh.
-- Gio ghi theo gio Viet Nam (Asia/Ho_Chi_Minh).
-- =====================================================================

-- ---------- 1. To chuc: phong ban, ca lam, quan ly truc tiep ----------
update profiles set
  department_id = (select id from departments where name = 'Phong Ky thuat'),
  shift_id      = (select id from shifts where name = 'Ca hanh chinh'),
  role          = 'manager',
  phone         = coalesce(phone, '0987654321')
where email = 'quanly.b@timekeeper.vn';

update profiles set
  department_id = (select id from departments where name = 'Phong Ky thuat'),
  shift_id      = (select id from shifts where name = 'Ca hanh chinh'),
  manager_id    = (select id from profiles where email = 'quanly.b@timekeeper.vn')
where email = 'nhanvien.a@timekeeper.vn';

-- ---------- 2. Cham cong: 26/10 -> 06/11/2026 (2 tuan lam viec) ----------
-- work_hours = (gio ra - gio vao), cung cach tinh voi man Cham cong cua TV2.
insert into attendance_records
  (employee_id, work_date, check_in_at, check_out_at, office_id,
   check_in_lat, check_in_lng, late_minutes, early_leave_minutes, work_hours, status, note)
select p.id, v.d::date,
       (v.d::date + v.tin::time) at time zone 'Asia/Ho_Chi_Minh',
       case when v.tout is null then null
            else (v.d::date + v.tout::time) at time zone 'Asia/Ho_Chi_Minh' end,
       o.id, 10.8411, 106.8098, v.late, v.early, v.hours, v.status, v.note
from (values
  -- Nhan vien A: tuan 26-30/10
  ('nhanvien.a@timekeeper.vn', '2026-10-26', '07:56', '17:02', 0,  0, 9.10, 'present', null),
  ('nhanvien.a@timekeeper.vn', '2026-10-27', '08:00', '17:00', 0,  0, 9.00, 'present', null),
  ('nhanvien.a@timekeeper.vn', '2026-10-28', '08:03', '20:05', 0,  0, 12.03, 'present', 'Co tang ca toi'),
  ('nhanvien.a@timekeeper.vn', '2026-10-29', '08:18', '17:00', 18, 0, 8.70, 'late',    'Ket xe'),
  ('nhanvien.a@timekeeper.vn', '2026-10-30', '07:58', '16:30', 0, 30, 8.53, 'present', 'Ve som co phep'),
  -- Nhan vien A: tuan 02-06/11
  ('nhanvien.a@timekeeper.vn', '2026-11-02', '08:00', '17:00', 0,  0, 9.00, 'present', null),
  ('nhanvien.a@timekeeper.vn', '2026-11-03', '08:20', '20:00', 20, 0, 11.67, 'late',   'Co tang ca toi'),
  ('nhanvien.a@timekeeper.vn', '2026-11-04', '07:55', '17:30', 0,  0, 9.58, 'present', null),
  ('nhanvien.a@timekeeper.vn', '2026-11-05', '08:02', null,    0,  0, 0.00, 'present', 'Quen check-out'),
  ('nhanvien.a@timekeeper.vn', '2026-11-06', '08:00', '17:10', 0,  0, 9.17, 'present', null),
  -- Quan ly B: tuan 26-30/10
  ('quanly.b@timekeeper.vn',   '2026-10-26', '07:45', '17:15', 0,  0, 9.50, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-10-27', '07:50', '17:05', 0,  0, 9.25, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-10-28', '07:55', '18:00', 0,  0, 10.08, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-10-30', '08:00', '17:00', 0,  0, 9.00, 'present', null),
  -- Quan ly B: tuan 02-06/11
  ('quanly.b@timekeeper.vn',   '2026-11-02', '07:50', '17:20', 0,  0, 9.50, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-11-03', '07:58', '17:00', 0,  0, 9.03, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-11-04', '08:12', '17:30', 12, 0, 9.30, 'late',    'Hop som o chi nhanh'),
  ('quanly.b@timekeeper.vn',   '2026-11-05', '07:55', '17:10', 0,  0, 9.25, 'present', null),
  ('quanly.b@timekeeper.vn',   '2026-11-06', '08:00', '17:00', 0,  0, 9.00, 'present', null)
) as v(email, d, tin, tout, late, early, hours, status, note)
join profiles p on p.email = v.email
cross join (select id from office_locations where is_active order by name limit 1) o
on conflict (employee_id, work_date) do update set
  check_in_at = excluded.check_in_at,
  check_out_at = excluded.check_out_at,
  office_id = excluded.office_id,
  late_minutes = excluded.late_minutes,
  early_leave_minutes = excluded.early_leave_minutes,
  work_hours = excluded.work_hours,
  status = excluded.status,
  note = excluded.note;

-- ---------- 3. Don tang ca (TV3) ----------
insert into ot_requests
  (id, employee_id, ot_date, start_time, end_time, hours, ot_type, multiplier,
   reason, status, approved_by, approved_at, reject_reason)
select v.id::uuid, p.id, v.d::date, v.s::time, v.e::time, v.h, v.t, v.m, v.reason, v.status,
       case when v.status in ('approved', 'rejected') then m.id end,
       case when v.status in ('approved', 'rejected') then (v.d::date + interval '1 day 9 hours') end,
       v.rej
from (values
  ('d0000000-0000-4000-8000-000000000001', 'nhanvien.a@timekeeper.vn', '2026-10-28', '18:00', '20:00', 2.0, 'weekday', 1.5,
   'Hoan thanh bao cao thang 10', 'approved', null),
  ('d0000000-0000-4000-8000-000000000002', 'nhanvien.a@timekeeper.vn', '2026-10-31', '08:00', '12:00', 4.0, 'weekend', 2.0,
   'Trien khai he thong cho khach', 'rejected', 'Khong co ke hoach lam viec thu Bay'),
  ('d0000000-0000-4000-8000-000000000003', 'nhanvien.a@timekeeper.vn', '2026-11-03', '18:00', '20:00', 2.0, 'weekday', 1.5,
   'Sua loi gap truoc khi phat hanh', 'approved', null),
  ('d0000000-0000-4000-8000-000000000004', 'nhanvien.a@timekeeper.vn', '2026-11-07', '09:00', '12:00', 3.0, 'weekend', 2.0,
   'Kiem thu ban phat hanh', 'pending', null),
  ('d0000000-0000-4000-8000-000000000005', 'quanly.b@timekeeper.vn',   '2026-11-08', '08:00', '11:00', 3.0, 'weekend', 2.0,
   'Ho tro trien khai cuoi tuan', 'pending', null)
) as v(id, email, d, s, e, h, t, m, reason, status, rej)
join profiles p on p.email = v.email
cross join (select id from profiles where email = 'quanly.b@timekeeper.vn') m
on conflict (id) do nothing;

-- ---------- 4. Don nghi phep (TV4) ----------
insert into leave_requests
  (id, employee_id, leave_type_id, start_date, end_date, half_day, total_days,
   reason, status, approved_by, approved_at, reject_reason)
select v.id::uuid, p.id, lt.id, v.d1::date, v.d2::date, v.half, v.days, v.reason, v.status,
       case when v.status in ('approved', 'rejected') then m.id end,
       case when v.status in ('approved', 'rejected') then (v.d1::date - interval '2 days') end,
       v.rej
from (values
  ('e0000000-0000-4000-8000-000000000001', 'nhanvien.a@timekeeper.vn', 'annual', '2026-10-20', '2026-10-20', 'none',      1.0,
   'Viec gia dinh', 'approved', null),
  ('e0000000-0000-4000-8000-000000000002', 'nhanvien.a@timekeeper.vn', 'annual', '2026-10-23', '2026-10-23', 'afternoon', 0.5,
   'Di kham suc khoe', 'approved', null),
  ('e0000000-0000-4000-8000-000000000003', 'nhanvien.a@timekeeper.vn', 'annual', '2026-11-12', '2026-11-13', 'none',      2.0,
   'Ve que', 'pending', null),
  ('e0000000-0000-4000-8000-000000000004', 'nhanvien.a@timekeeper.vn', 'unpaid', '2026-11-20', '2026-11-20', 'none',      1.0,
   'Viec ca nhan', 'rejected', 'Trung lich ban giao du an'),
  ('e0000000-0000-4000-8000-000000000005', 'quanly.b@timekeeper.vn',   'sick',   '2026-10-29', '2026-10-29', 'none',      1.0,
   'Sot, co giay bac si', 'approved', null)
) as v(id, email, code, d1, d2, half, days, reason, status, rej)
join profiles p on p.email = v.email
join leave_types lt on lt.code = v.code
cross join (select id from profiles where email = 'quanly.b@timekeeper.vn') m
on conflict (id) do nothing;

-- So du phep: dam bao co dong cho nam 2026, roi tinh used_days tu cac don da duyet.
insert into leave_balances (employee_id, leave_type_id, year, total_days)
select p.id, lt.id, 2026, lt.default_days
from profiles p cross join leave_types lt
where p.email in ('nhanvien.a@timekeeper.vn', 'quanly.b@timekeeper.vn')
on conflict (employee_id, leave_type_id, year) do nothing;

update leave_balances lb set used_days = coalesce((
  select sum(lr.total_days) from leave_requests lr
  where lr.employee_id = lb.employee_id and lr.leave_type_id = lb.leave_type_id
    and lr.status = 'approved' and extract(year from lr.start_date) = lb.year
), 0)
where lb.year = 2026
  and lb.employee_id in (select id from profiles
                         where email in ('nhanvien.a@timekeeper.vn', 'quanly.b@timekeeper.vn'));

-- ---------- 5. Don bu cong (TV2) ----------
insert into attendance_corrections
  (id, employee_id, work_date, attendance_id, requested_check_in, requested_check_out,
   reason, status, approved_by, approved_at, reject_reason)
select v.id::uuid, p.id, v.d::date, a.id,
       case when v.tin is null then null
            else (v.d::date + v.tin::time) at time zone 'Asia/Ho_Chi_Minh' end,
       case when v.tout is null then null
            else (v.d::date + v.tout::time) at time zone 'Asia/Ho_Chi_Minh' end,
       v.reason, v.status,
       case when v.status in ('approved', 'rejected') then m.id end,
       case when v.status in ('approved', 'rejected') then (v.d::date + interval '1 day 10 hours') end,
       null
from (values
  ('c0000000-0000-4000-8000-000000000001', 'nhanvien.a@timekeeper.vn', '2026-11-05', null,    '17:05',
   'Quen check-out khi ve', 'pending'),
  ('c0000000-0000-4000-8000-000000000002', 'nhanvien.a@timekeeper.vn', '2026-10-29', '08:00', null,
   'May cham cong loi, thuc te den dung gio', 'approved'),
  ('c0000000-0000-4000-8000-000000000003', 'quanly.b@timekeeper.vn',   '2026-10-29', '08:00', '17:00',
   'Di cong tac ngoai van phong', 'pending')
) as v(id, email, d, tin, tout, reason, status)
join profiles p on p.email = v.email
left join attendance_records a on a.employee_id = p.id and a.work_date = v.d::date
cross join (select id from profiles where email = 'quanly.b@timekeeper.vn') m
on conflict (id) do nothing;

-- ---------- 6. Thong bao (TV5) ----------
insert into notifications (id, recipient_id, title, body, type, ref_table, ref_id, is_read, created_at)
select v.id::uuid, p.id, v.title, v.body, v.type, v.ref_table, v.ref_id::uuid, v.is_read,
       v.at::timestamp at time zone 'Asia/Ho_Chi_Minh'
from (values
  ('f0000000-0000-4000-8000-000000000001', 'nhanvien.a@timekeeper.vn', 'Don tang ca da duoc duyet',
   'Don tang ca ngay 28/10 (2 gio) da duoc quan ly duyet.', 'ot', 'ot_requests',
   'd0000000-0000-4000-8000-000000000001', true,  '2026-10-29 09:00'),
  ('f0000000-0000-4000-8000-000000000002', 'nhanvien.a@timekeeper.vn', 'Don tang ca bi tu choi',
   'Don tang ca ngay 31/10 bi tu choi: Khong co ke hoach lam viec thu Bay.', 'ot', 'ot_requests',
   'd0000000-0000-4000-8000-000000000002', true,  '2026-10-30 15:30'),
  ('f0000000-0000-4000-8000-000000000003', 'nhanvien.a@timekeeper.vn', 'Don tang ca da duoc duyet',
   'Don tang ca ngay 03/11 (2 gio) da duoc quan ly duyet.', 'ot', 'ot_requests',
   'd0000000-0000-4000-8000-000000000003', false, '2026-11-04 09:00'),
  ('f0000000-0000-4000-8000-000000000004', 'nhanvien.a@timekeeper.vn', 'Ban chua check-out',
   'Ngay 05/11 ban chua check-out. Hay gui don bu cong neu quen.', 'attendance', 'attendance_records',
   null, false, '2026-11-05 18:00'),
  ('f0000000-0000-4000-8000-000000000005', 'nhanvien.a@timekeeper.vn', 'Don nghi phep bi tu choi',
   'Don nghi ngay 20/11 bi tu choi: Trung lich ban giao du an.', 'leave', 'leave_requests',
   'e0000000-0000-4000-8000-000000000004', false, '2026-11-06 10:15'),
  ('f0000000-0000-4000-8000-000000000006', 'quanly.b@timekeeper.vn',   'Co don tang ca cho duyet',
   'Nguyen Van A gui don tang ca ngay 07/11 (3 gio).', 'ot', 'ot_requests',
   'd0000000-0000-4000-8000-000000000004', false, '2026-11-06 16:40'),
  ('f0000000-0000-4000-8000-000000000007', 'quanly.b@timekeeper.vn',   'Co don nghi phep cho duyet',
   'Nguyen Van A xin nghi phep nam 12-13/11 (2 ngay).', 'leave', 'leave_requests',
   'e0000000-0000-4000-8000-000000000003', false, '2026-11-06 11:05'),
  ('f0000000-0000-4000-8000-000000000008', 'quanly.b@timekeeper.vn',   'Co don bu cong cho duyet',
   'Nguyen Van A gui don bu cong ngay 05/11: Quen check-out khi ve.', 'correction', 'attendance_corrections',
   'c0000000-0000-4000-8000-000000000001', false, '2026-11-06 08:20')
) as v(id, email, title, body, type, ref_table, ref_id, is_read, at)
join profiles p on p.email = v.email
on conflict (id) do nothing;

-- ---------- 7. Kiem tra nhanh ----------
select 'attendance_records' as bang, count(*) as so_dong from attendance_records
union all select 'ot_requests', count(*) from ot_requests
union all select 'leave_requests', count(*) from leave_requests
union all select 'attendance_corrections', count(*) from attendance_corrections
union all select 'notifications', count(*) from notifications
union all select 'leave_balances', count(*) from leave_balances;

-- ---------- XOA DU LIEU DEMO (chi chay khi can don) ----------
-- delete from notifications where id::text like 'f0000000-0000-4000-8000-%';
-- delete from attendance_corrections where id::text like 'c0000000-0000-4000-8000-%';
-- delete from leave_requests where id::text like 'e0000000-0000-4000-8000-%';
-- delete from ot_requests where id::text like 'd0000000-0000-4000-8000-%';
-- delete from attendance_records where work_date between '2026-10-26' and '2026-11-06'
--   and employee_id in (select id from profiles
--                       where email in ('nhanvien.a@timekeeper.vn', 'quanly.b@timekeeper.vn'));
-- update leave_balances set used_days = 0 where year = 2026;
