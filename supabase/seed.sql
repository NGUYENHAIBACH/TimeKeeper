-- =====================================================================
-- TimeKeeper - Du lieu mau cho ca nhom. Chay SAU schema.sql.
-- profiles KHONG seed: ban ghi duoc tao tu dong khi dang nhap lan dau
-- (ProfileRepository.syncAfterLogin). Nang role bang lenh update o cuoi file.
-- =====================================================================

-- TV1
insert into departments (name) values
  ('Ban Giam doc'),
  ('Phong Ky thuat'),
  ('Phong Kinh doanh'),
  ('Phong Nhan su')
on conflict (name) do nothing;

insert into shifts (name, start_time, end_time, grace_minutes) values
  ('Ca hanh chinh', '08:00', '17:00', 5),
  ('Ca sang',       '06:00', '14:00', 5),
  ('Ca chieu',      '14:00', '22:00', 5)
on conflict (name) do nothing;

-- TV2: van phong mau (FPT University HCM). Doi toa do cho dung noi test.
insert into office_locations (name, address, latitude, longitude, radius_meters)
select 'Van phong chinh', 'Lo E2a-7, Duong D1, Khu Cong nghe cao, TP. Thu Duc',
       10.8411, 106.8098, 100
where not exists (select 1 from office_locations where name = 'Van phong chinh');

-- TV4: loai phep
insert into leave_types (code, name, default_days, is_paid, requires_document) values
  ('annual',       'Nghi phep nam',     12, true,  false),
  ('sick',      'Nghi om',           30, true,  true),
  ('unpaid',    'Nghi khong luong',   0, false, false),
  ('maternity', 'Nghi thai san',    180, true,  true),
  ('wedding',   'Nghi cuoi',          3, true,  false)
on conflict (code) do nothing;

-- TV4: ngay le Viet Nam 2026
insert into holidays (holiday_date, name) values
  ('2026-01-01', 'Tet Duong lich'),
  ('2026-02-16', 'Tet Nguyen dan (29 Tet)'),
  ('2026-02-17', 'Tet Nguyen dan (Mung 1)'),
  ('2026-02-18', 'Tet Nguyen dan (Mung 2)'),
  ('2026-02-19', 'Tet Nguyen dan (Mung 3)'),
  ('2026-02-20', 'Tet Nguyen dan (Mung 4)'),
  ('2026-04-26', 'Gio To Hung Vuong'),
  ('2026-04-30', 'Ngay Giai phong mien Nam'),
  ('2026-05-01', 'Quoc te Lao dong'),
  ('2026-09-02', 'Quoc khanh'),
  ('2026-09-03', 'Quoc khanh (ngay 2)')
on conflict (holiday_date) do nothing;

-- Sau khi da dang nhap bang app it nhat 1 lan, nang quyen (thay email):
-- update profiles set role = 'admin'   where email = 'admin@example.com';
-- update profiles set role = 'manager' where email = 'manager@example.com';
-- Gan manager cho nhan vien:
-- update profiles set manager_id = (select id from profiles where email = 'manager@example.com')
--   where email = 'employee@example.com';
-- Cap so du phep nam 2026 cho moi nhan vien:
-- insert into leave_balances (employee_id, leave_type_id, year, total_days)
-- select p.id, lt.id, 2026, lt.default_days from profiles p cross join leave_types lt
-- on conflict (employee_id, leave_type_id, year) do nothing;
