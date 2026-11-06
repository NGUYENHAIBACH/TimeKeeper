import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_service.g.dart';

/// Service vân tay dùng chung cho cả app.
@Riverpod(keepAlive: true)
BiometricService biometricService(Ref ref) => BiometricService();

/// Kết quả xác thực vân tay / khuôn mặt.
enum BiometricResult { success, failed, notAvailable, cancelled, lockedOut }

/// Bọc local_auth: xác thực trước khi chấm công.
class BiometricService {
  BiometricService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Máy có hỗ trợ khóa sinh trắc học hoặc mã PIN không.
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Hiện hộp thoại xác thực với lời nhắc [reason]. Cho phép dùng PIN máy
  /// nếu không có vân tay.
  Future<BiometricResult> authenticate(String reason) async {
    if (!await isAvailable()) return BiometricResult.notAvailable;
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        // Cho phép dùng PIN/mật khẩu máy nếu không có vân tay.
        biometricOnly: false,
      );
      return ok ? BiometricResult.success : BiometricResult.failed;
    } on LocalAuthException catch (e) {
      return switch (e.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.userRequestedFallback =>
          BiometricResult.cancelled,
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout =>
          BiometricResult.lockedOut,
        LocalAuthExceptionCode.noCredentialsSet ||
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noBiometricHardware =>
          BiometricResult.notAvailable,
        _ => BiometricResult.failed,
      };
    }
  }
}
