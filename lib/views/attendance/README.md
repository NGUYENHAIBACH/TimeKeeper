# views/attendance — Chấm công (check-in/out GPS + vân tay, lịch công, đơn bù công)

Phụ trách: **TV2**

- `lib/views/attendance/`      : `<ten>_screen.dart` (ConsumerWidget, dùng AsyncValue.when)
- `lib/viewmodels/attendance/` : `<ten>_viewmodel.dart` (`@riverpod class ... extends _$...`)
- Model → `lib/models/`, DataSource → `lib/datasources/`, Repository → `lib/repositories/`
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Quy trình làm một màn hình: xem mục 3 và mục 6 trong `README.md` ở thư mục gốc.
