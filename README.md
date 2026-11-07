# TimeKeeper — App Chấm công, OT & Nghỉ phép (PRM393)

Flutter + Firebase Auth + Supabase + Riverpod 3 (MVVM).

## 1. Chạy project lần đầu

```bash
git clone <repo-url>
cd timekeeper
flutter pub get
```

1. Copy `lib/core/constants/env.example.dart` → `lib/core/constants/env.dart`, điền URL và publishable key Supabase (hỏi TV1). File `env.dart` **không commit**.
2. Firebase đã cấu hình sẵn trong repo (`lib/firebase_options.dart`, `android/app/google-services.json`, project `timekeeper-prm393`). Không cần chạy `flutterfire configure`. Muốn test Google Sign-In trên máy mình thì gửi SHA-1 debug cho TV1 thêm vào Firebase (lấy bằng `cd android && ./gradlew signingReport`).
3. Windows: bật **Developer Mode** (Settings → System → For developers) vì plugin Flutter cần symlink.
4. Sinh code và chạy:

```bash
dart run build_runner watch -d
```

```bash
flutter run
```

## 2. Cấu trúc thư mục

```
lib/
├── core/
│   ├── constants/   env.dart (không commit), env.example.dart
│   ├── providers/   core_providers.dart  (firebaseAuth, supabase, sharedPrefs)
│   ├── router/      app_router.dart, app_routes.dart
│   ├── theme/       app_theme.dart
│   ├── utils/       validators, ot_calculator, leave_calculator
│   └── widgets/     AppTextField, AppButton, LoadingView, ErrorView, PlaceholderScreen
├── models/          Model: freezed + json (profile.dart, app_settings.dart, ...)
├── datasources/     gọi Supabase / SQLite / Firebase (1 file / bảng)
├── repositories/    gom datasource, cung cấp cho ViewModel
├── viewmodels/<module>/   ViewModel: `@riverpod class ... extends _$...`
├── views/<module>/        View: `*_screen.dart` (ConsumerWidget)
│   module = auth, home, settings (TV1) · attendance (TV2) · overtime (TV3)
│            · leave (TV4) · approval (TV5)
└── main.dart
supabase/schema.sql, seed.sql
```

MVVM kiểu cổ điển: `models/` là Model, `views/<module>/` là View, `viewmodels/<module>/` là ViewModel. Import luôn dùng dạng `package:timekeeper/...`, không dùng đường dẫn tương đối.

## 3. Quy ước Riverpod (bắt buộc)

- Mọi provider dùng `@riverpod` / `@Riverpod(keepAlive: true)` + `part 'x.g.dart';`. Không viết provider tay, không dùng `StateProvider`.
- keepAlive: core providers, DataSource, Repository, `authState`, `SettingsViewModel`, `router`. ViewModel màn hình để autoDispose mặc định.
- ViewModel bất đồng bộ:

```dart
@riverpod
class OtListViewModel extends _$OtListViewModel {
  @override
  Future<List<OtRequest>> build() => ref.watch(otRepositoryProvider).getMyRequests();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(otRepositoryProvider).getMyRequests());
  }
}
```

- View là `ConsumerWidget`: `ref.watch` để hiển thị, `ref.read(x.notifier)` để gọi hành động, `ref.listen` để hiện SnackBar lỗi. Mỗi màn xử lý đủ 3 trạng thái bằng `AsyncValue.when` với `LoadingView` / `ErrorView`.
- Riverpod 3: dùng `.value` (không có `valueOrNull`).
- View **không** gọi Firebase/Supabase trực tiếp.

## 4. Quy ước dữ liệu

- Mọi bảng nghiệp vụ tham chiếu `profiles.id` qua `employee_id`. Lấy profile hiện tại từ `profileViewModelProvider` (TV1).
- Trạng thái đơn: `pending` / `approved` / `rejected` / `cancelled`.
- Điều hướng chỉ dùng hằng trong `AppRoutes`, ví dụ `context.go(AppRoutes.checkin)`.
- Thêm/sửa bảng: sửa `supabase/schema.sql` rồi chạy lại trên SQL Editor. Không dùng service_role / secret key.

## 5. Git

- Nhánh `feature/<module>` (vd `feature/attendance`), Pull Request vào `main`.
- Commit nhỏ, message dạng `feat(attendance): check-in bằng GPS`, `fix(leave): tính ngày nghỉ bỏ cuối tuần`.
- Không commit `env.dart`, file build, `.g.dart`/`.freezed.dart` thì **có** commit để clone về chạy được ngay.

## 6. Checklist mỗi screen (yêu cầu môn)

- [ ] ViewModel Riverpod riêng, đủ loading / error / data
- [ ] Đọc/ghi dữ liệu thật (Supabase / SQLite / SharedPreferences)
- [ ] Có nghiệp vụ: form + validation, lọc, duyệt hoặc tính toán
- [ ] Comment cho class và hàm public

## 7. Trạng thái phần TV1 (đã xong)

| Screen | View | ViewModel | Dữ liệu |
|---|---|---|---|
| Login / Register / Quên mật khẩu | `views/auth/*` | `AuthViewModel` | Firebase Auth → upsert `profiles` (Supabase) |
| Home Dashboard | `views/home/home_screen.dart` | `HomeViewModel` | `profiles`, `attendance_records`, `leave_balances` |
| Profile & Settings | `views/settings/*` | `ProfileViewModel`, `SettingsViewModel` | `profiles` + bucket `avatars`, SharedPreferences |

TV1 cung cấp cho nhóm: `authStateProvider`, `profileViewModelProvider` (lấy `employee_id`, role),
`settingsViewModelProvider` (giờ nhắc, vân tay), interface `AttendanceRepository` / `LeaveRepository`
kèm bản mock (`lib/repositories/mock/mock_repositories.dart`).
