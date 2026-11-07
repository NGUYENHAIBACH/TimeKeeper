import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/repositories/auth_repository.dart';
import 'package:timekeeper/repositories/profile_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'auth_viewmodel.g.dart';

/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<void> build() {}

  /// Đăng nhập email / mật khẩu rồi đồng bộ hồ sơ lên Supabase.
  Future<void> signIn(String email, String password) {
    final auth = ref.read(authRepositoryProvider);
    return _loginFlow(() => auth.signIn(email: email, password: password));
  }

  /// Đăng ký tài khoản mới rồi tạo hồ sơ trên Supabase.
  Future<void> register(String email, String password, String fullName) {
    final auth = ref.read(authRepositoryProvider);
    return _loginFlow(
      () => auth.register(email: email, password: password, fullName: fullName),
    );
  }

  /// Đăng nhập Google rồi đồng bộ hồ sơ.
  Future<void> signInWithGoogle() {
    final auth = ref.read(authRepositoryProvider);
    return _loginFlow(auth.signInWithGoogle);
  }

  /// Gửi email đặt lại mật khẩu. Trả về true khi gửi thành công.
  Future<bool> sendResetEmail(String email) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendResetEmail(email),
    );
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  /// Đăng xuất. Router sẽ đưa về Login khi `authState` phát ra null.
  Future<void> signOut() async {
    final auth = ref.read(authRepositoryProvider);
    final link = ref.keepAlive();
    try {
      state = const AsyncLoading();
      final result = await AsyncValue.guard(auth.signOut);
      if (ref.mounted) state = result;
    } finally {
      link.close();
    }
  }

  /// Luồng chung của 3 cách đăng nhập: xác thực với Firebase -> upsert hồ sơ
  /// lên Supabase -> báo ProfileViewModel tải lại.
  ///
  /// Lưu ý quan trọng: ngay khi Firebase xác thực xong, `authState` đổi và
  /// router rời màn Login/Register, khiến ViewModel autoDispose này mất hết
  /// listener. `ref.keepAlive()` giữ nó sống đến khi đồng bộ hồ sơ xong; các
  /// repository cũng được lấy ra TRƯỚC khi await để không dùng `ref` sau khi
  /// provider có thể đã bị hủy.
  Future<void> _loginFlow(Future<User> Function() authenticate) async {
    final profiles = ref.read(profileRepositoryProvider);
    final link = ref.keepAlive();
    try {
      state = const AsyncLoading();
      final result = await AsyncValue.guard(() async {
        final user = await authenticate();
        await profiles.syncAfterLogin(user);
      });
      if (!ref.mounted) return;
      state = result;
      // Hồ sơ vừa được ghi (có thể kèm họ tên mới) -> tải lại cho Home.
      if (!result.hasError) ref.invalidate(profileViewModelProvider);
    } finally {
      link.close();
    }
  }
}
