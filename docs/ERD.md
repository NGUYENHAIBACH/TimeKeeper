# Thiết kế cơ sở dữ liệu (ERD) — TimeKeeper

Phần báo cáo do **TV4** phụ trách. Nguồn: `supabase/schema.sql` (13 bảng, Supabase PostgreSQL).

## 1. Sơ đồ quan hệ

```mermaid
erDiagram
    departments ||--o{ profiles : "có"
    shifts ||--o{ profiles : "áp dụng"
    profiles ||--o{ profiles : "manager_id"

    profiles ||--o{ attendance_records : "chấm công"
    office_locations ||--o{ attendance_records : "tại"
    profiles ||--o{ attendance_corrections : "gửi"
    attendance_records ||--o{ attendance_corrections : "bù cho"

    profiles ||--o{ ot_requests : "gửi"

    leave_types ||--o{ leave_balances : "cấp"
    profiles ||--o{ leave_balances : "sở hữu"
    leave_types ||--o{ leave_requests : "thuộc loại"
    profiles ||--o{ leave_requests : "gửi / duyệt"

    profiles ||--o{ notifications : "nhận"
    profiles ||--o{ fcm_tokens : "thiết bị"

    departments {
        uuid id PK
        text name UK
    }
    shifts {
        uuid id PK
        text name UK
        time start_time
        time end_time
        int grace_minutes
    }
    profiles {
        uuid id PK
        text firebase_uid UK
        text email
        text full_name
        text role "employee|manager|admin"
        uuid department_id FK
        uuid manager_id FK
        uuid shift_id FK
    }
    office_locations {
        uuid id PK
        text name
        float latitude
        float longitude
        int radius_meters
    }
    attendance_records {
        uuid id PK
        uuid employee_id FK
        date work_date
        timestamptz check_in_at
        timestamptz check_out_at
        numeric work_hours
        text status
    }
    attendance_corrections {
        uuid id PK
        uuid employee_id FK
        uuid attendance_id FK
        date work_date
        text reason
        text status
    }
    ot_requests {
        uuid id PK
        uuid employee_id FK
        date ot_date
        numeric hours
        numeric multiplier
        numeric paid_hours "generated"
        text status
    }
    leave_types {
        uuid id PK
        text code UK
        text name
        numeric default_days
        bool is_paid
        bool requires_document
    }
    leave_balances {
        uuid id PK
        uuid employee_id FK
        uuid leave_type_id FK
        int year
        numeric total_days
        numeric used_days
        numeric remaining_days "generated"
    }
    leave_requests {
        uuid id PK
        uuid employee_id FK
        uuid leave_type_id FK
        date start_date
        date end_date
        text half_day "none|morning|afternoon"
        numeric total_days
        text reason
        text attachment_url
        text status
        uuid approved_by FK
    }
    holidays {
        uuid id PK
        date holiday_date UK
        text name
    }
    notifications {
        uuid id PK
        uuid recipient_id FK
        text type
        text ref_table
        uuid ref_id
        bool is_read
    }
    fcm_tokens {
        uuid id PK
        uuid employee_id FK
        text token UK
    }
```

## 2. Nhóm bảng theo module

| Module | Bảng | Phụ trách |
|---|---|---|
| Người dùng | `departments`, `shifts`, `profiles` | TV1 |
| Chấm công | `office_locations`, `attendance_records`, `attendance_corrections` | TV2 |
| Tăng ca | `ot_requests` | TV3 |
| Nghỉ phép | `leave_types`, `leave_balances`, `leave_requests`, `holidays` | TV4 |
| Thông báo | `notifications`, `fcm_tokens` | TV5 |

## 3. Quyết định thiết kế chính

- **Khóa chính `uuid`** (`gen_random_uuid()`) cho mọi bảng, dễ sinh ở client và không lộ số thứ tự.
- **`profiles` là trung tâm**: Firebase Auth giữ danh tính, `profiles.firebase_uid` (unique) nối sang Supabase. Mọi bảng nghiệp vụ tham chiếu `profiles.id` qua `employee_id`, không dùng `firebase_uid` làm khóa ngoại.
- **Trạng thái đơn thống nhất** `pending | approved | rejected | cancelled` cho `ot_requests`, `leave_requests`, `attendance_corrections`, nên TV5 gộp được 3 loại đơn vào một hộp duyệt; cột `approved_by`, `approved_at`, `reject_reason` giống nhau.
- **Cột generated** (`leave_balances.remaining_days`, `ot_requests.paid_hours`) để DB tự tính, tránh lệch số liệu giữa các màn hình.
- **Ràng buộc unique**: `attendance_records(employee_id, work_date)` (1 bản ghi / ngày), `leave_balances(employee_id, leave_type_id, year)` (1 số dư / loại / năm), `holidays.holiday_date`.
- **`notifications.ref_table + ref_id`**: liên kết đa hình tới đơn liên quan, bấm thông báo mở đúng đơn.
- **Index** trên `employee_id`, `status` và khoảng ngày (`leave_requests(start_date, end_date)`) cho các truy vấn lọc thường dùng.
- **RLS** bật cho mọi bảng; giai đoạn dev dùng policy `dev_all_<bảng>` (cách A) cho anon/authenticated.

## 4. Module Nghỉ phép (TV4)

```
leave_types (1) ──< leave_balances >── (1) profiles
leave_types (1) ──< leave_requests >── (1) profiles
holidays: bảng độc lập, dùng để trừ ngày lễ khi tính số ngày nghỉ
Storage bucket "leave_documents": file đính kèm, URL lưu ở leave_requests.attachment_url
```

Luồng dữ liệu:

1. Mở form xin nghỉ → `LeaveRequestRepository.getBalances()`; nếu nhân viên chưa có dòng `leave_balances` của năm thì tự tạo theo `leave_types.default_days`.
2. Tính `total_days` bằng `LeaveCalculator.countDays()`: bỏ thứ 7, chủ nhật, ngày trong `holidays`; nửa ngày = 0.5.
3. Kiểm tra số dư: `remaining_days` trừ tổng `total_days` của các đơn `pending` cùng loại (đơn chờ duyệt "giữ chỗ").
4. Có file → upload lên bucket `leave_documents` theo đường dẫn `<employee_id>/<timestamp>_<tên file>` rồi ghi `attachment_url`; ghi đơn lỗi thì xóa file vừa upload.
5. TV5 duyệt đơn → cập nhật `status`, `approved_by`, `approved_at` và cộng `leave_balances.used_days`.
6. Lịch nghỉ team: `leave_requests` join `profiles!employee_id!inner` lọc theo `department_id`, trạng thái `approved` + `pending`, giao với tháng đang xem.
