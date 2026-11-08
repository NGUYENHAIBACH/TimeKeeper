# views/leave — Nghỉ phép

Phụ trách: **TV4**

| Screen | File View | ViewModel | Nghiệp vụ |
|---|---|---|---|
| Form xin nghỉ (`/leave/new`) | `leave_form_screen.dart` | `LeaveFormViewModel`, `LeaveSubmitViewModel` | chọn loại phép, khoảng ngày, nửa ngày; tự tính số ngày (bỏ cuối tuần + ngày lễ); kiểm tra số dư (trừ đơn chờ duyệt), trùng ngày, bắt buộc giấy tờ; đính kèm file lên Supabase Storage |
| Lịch sử & Số dư (`/leave`) | `leave_history_screen.dart` | `LeaveHistoryViewModel`, `LeaveHistoryFilter` | số dư theo loại phép, lọc đơn theo trạng thái / loại, hủy đơn đang chờ |
| Lịch nghỉ team (`/leave/team`) | `leave_team_calendar_screen.dart` | `LeaveTeamCalendarViewModel` | calendar tháng đánh dấu ngày có người cùng phòng ban nghỉ, ngày lễ; chọn ngày xem ai nghỉ |

Các lớp khác:

- Model: `lib/models/leave_type.dart`, `leave_balance.dart`, `leave_request.dart`, `holiday.dart`
- DataSource: `lib/datasources/leave_request_datasource.dart` (bảng `leave_*`, `holidays`, bucket `leave_documents`)
- Repository: `lib/repositories/leave_request_repository.dart` (`leaveRequestRepositoryProvider`)
- `leave_datasource.dart` / `leave_repository.dart` (`LeaveRepository.getLeaveBalance`): phần đọc số dư phép năm cho Home Dashboard do TV1 viết, giữ nguyên.
- Logic: `lib/core/utils/leave_calculator.dart`
- Test: `test/leave/` (unit test logic, test ViewModel, Widget Test 3 màn)
- ERD cho báo cáo: `docs/ERD.md`

## Interface với module khác

- TV5 (duyệt đơn) đọc `leave_requests` có `status = 'pending'`; khi duyệt cập nhật `status`, `approved_by`, `approved_at` và cộng `leave_balances.used_days += total_days`.
- TV1 (Home) lấy số phép năm còn lại qua `LeaveRepository.getLeaveBalance` (đọc cùng bảng `leave_balances`).

## Chạy test

```bash
flutter test test/leave
```
