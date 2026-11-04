# features/leave — Nghỉ phép (form xin nghỉ, lịch sử & số dư, lịch nghỉ team, nhắc giờ)

Phụ trách: **TV4**

- `view/`      : `<ten>_screen.dart` (ConsumerWidget, dùng AsyncValue.when)
- `viewmodel/` : `<ten>_viewmodel.dart` (`@riverpod class ... extends _$...`)
- Model → `lib/data/models/`, DataSource → `lib/data/datasources/`, Repository → `lib/data/repositories/`
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Xem `docs/HUONG_DAN.md` mục 7 để biết quy trình làm một màn hình.
