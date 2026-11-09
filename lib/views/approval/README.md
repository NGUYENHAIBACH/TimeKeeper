# views/approval — Duyệt đơn & Thông báo (hộp duyệt, notification center, team dashboard)

Phụ trách: **TV5**

- `lib/views/approval/approval_screens.dart`: 3 màn hình TV5, dùng `AsyncValue.when`.
- `lib/viewmodels/approval/`: ViewModel riêng cho Hộp duyệt đơn, Thông báo và Team Dashboard.
- `lib/repositories/approval_repository.dart`: đọc/ghi Supabase cho module TV5.
- `lib/core/services/approval_notification_service.dart`: FCM và local notification.
- `lib/services/approval/team_report_export_service.dart`: xuất PDF/Excel.
- Module dùng các model nghiệp vụ dùng chung trong `lib/models/`, không tạo model trùng lặp.
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Quy trình làm một màn hình: xem mục 3 và mục 6 trong `README.md` ở thư mục gốc.
