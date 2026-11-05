# views/leave — Nghỉ phép (form xin nghỉ, lịch sử & số dư, lịch nghỉ team, nhắc giờ)

Phụ trách: **TV4**

- `lib/views/leave/`      : `<ten>_screen.dart` (ConsumerWidget, dùng AsyncValue.when)
- `lib/viewmodels/leave/` : `<ten>_viewmodel.dart` (`@riverpod class ... extends _$...`)
- Model → `lib/models/`, DataSource → `lib/datasources/`, Repository → `lib/repositories/`
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Quy trình làm một màn hình: xem mục 3 và mục 6 trong `README.md` ở thư mục gốc.
