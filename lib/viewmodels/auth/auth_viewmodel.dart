import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/repositories/auth_repository.dart';
import 'package:timekeeper/repositories/profile_repository.dart';

part 'auth_viewmodel.g.dart';

/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<void> build() {}

  AuthRepository get _auth => ref.read(authRepositoryProvider);
  ProfileRepository get _profile => ref.read(profileRepositoryProvider);

  /// Đăng nhập email / mật khẩu rồi đồng bộ hồ sơ lên Supabase.
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _auth.signIn(email: email, password: password);
      await _profile.syncAfterLogin(user);
    });
  }

  /// Đăng ký tài khoản mới rồi tạo hồ sơ trên Supabase.
  Future<void> register(String email, String password, String fullName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _auth.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      await _profile.syncAfterLogin(user);
    });
  }

  /// Đăng nhập Google rồi đồng bộ hồ sơ.
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _auth.signInWithGoogle();
      await _profile.syncAfterLogin(user);
    });
  }

  /// Gửi email đặt lại mật khẩu. Trả về true khi gửi thành công.
  Future<bool> sendResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _auth.sendResetEmail(email));
    return !state.hasError;
  }

  /// Đăng xuất. Router sẽ đưa về Login khi `authState` phát ra null.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_auth.signOut);
  }
}
