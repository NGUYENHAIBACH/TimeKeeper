# features/approval — Duyệt đơn & Thông báo (hộp duyệt, notification center, team dashboard)

Phụ trách: **TV5**

- `view/`      : `<ten>_screen.dart` (ConsumerWidget, dùng AsyncValue.when)
- `viewmodel/` : `<ten>_viewmodel.dart` (`@riverpod class ... extends _$...`)
- Model → `lib/data/models/`, DataSource → `lib/data/datasources/`, Repository → `lib/data/repositories/`
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Xem `docs/HUONG_DAN.md` mục 7 để biết quy trình làm một màn hình.
