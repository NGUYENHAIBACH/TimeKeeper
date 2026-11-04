# features/attendance — Chấm công (check-in/out GPS + vân tay, lịch công, đơn bù công)

Phụ trách: **TV2**

- `view/`      : `<ten>_screen.dart` (ConsumerWidget, dùng AsyncValue.when)
- `viewmodel/` : `<ten>_viewmodel.dart` (`@riverpod class ... extends _$...`)
- Model → `lib/data/models/`, DataSource → `lib/data/datasources/`, Repository → `lib/data/repositories/`
- Route đã có sẵn trong `lib/core/router/app_routes.dart`; thay `PlaceholderScreen` trong `app_router.dart` bằng screen thật.

Xem `docs/HUONG_DAN.md` mục 7 để biết quy trình làm một màn hình.
