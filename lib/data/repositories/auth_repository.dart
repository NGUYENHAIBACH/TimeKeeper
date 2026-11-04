import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/firebase_constants.dart';
import '../../core/providers/core_providers.dart';

part 'auth_repository.g.dart';

/// Lỗi xác thực đã dịch sang tiếng Việt để View hiển thị thẳng.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Repository xác thực: bọc Firebase Auth và Google Sign-In.
/// Đây là lớp duy nhất gọi SDK Firebase Auth; ViewModel không gọi trực tiếp.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

  /// Stream trạng thái đăng nhập, `null` khi chưa đăng nhập.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Người dùng hiện tại (có thể null).
  User? get currentUser => _auth.currentUser;

  /// Đăng nhập bằng email / mật khẩu.
  Future<User> signIn({required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_translate(e));
    }
  }

  /// Đăng ký tài khoản mới, đồng thời đặt tên hiển thị.
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await user.updateDisplayName(fullName.trim());
      await user.reload();
      return _auth.currentUser ?? user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_translate(e));
    }
  }

  /// Đăng nhập Google (google_sign_in 7.x: dùng `GoogleSignIn.instance`).
  /// Lấy idToken từ Google rồi đổi lấy credential Firebase.
  Future<User> signInWithGoogle() async {
    try {
      final google = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await google.initialize(serverClientId: FirebaseConstants.googleWebClientId);
        _googleInitialized = true;
      }
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('Không lấy được token từ Google');
      }
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final cred = await _auth.signInWithCredential(credential);
      return cred.user!;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Bạn đã hủy đăng nhập Google');
      }
      throw AuthException('Đăng nhập Google thất bại: ${e.description ?? e.code.name}');
    } on FirebaseAuthException catch (e) {
      throw AuthException(_translate(e));
    }
  }

  /// Gửi email đặt lại mật khẩu.
  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_translate(e));
    }
  }

  /// Đăng xuất cả Firebase lẫn Google (để lần sau chọn lại tài khoản).
  Future<void> signOut() async {
    if (_googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }

  /// Dịch mã lỗi Firebase sang tiếng Việt.
  static String _translate(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-disabled':
        return 'Tài khoản đã bị khóa';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Email hoặc mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email này đã được đăng ký';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'too-many-requests':
        return 'Bạn thử quá nhiều lần, vui lòng đợi rồi thử lại';
      case 'network-request-failed':
        return 'Không có kết nối mạng';
      case 'account-exists-with-different-credential':
        return 'Email này đã đăng ký bằng phương thức khác';
      default:
        return e.message ?? 'Đã xảy ra lỗi (${e.code})';
    }
  }
}

/// Provider AuthRepository, keepAlive vì dùng suốt vòng đời app.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}
