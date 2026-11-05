import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_repository.g.dart';

/// Bọc plugin `local_auth`. TV1 dùng để kiểm tra trước khi bật vân tay
/// trong Settings; TV2 dùng `authenticate` khi chấm công.
class BiometricRepository {
  BiometricRepository([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Thiết bị có hỗ trợ và đã cài vân tay / khuôn mặt hay chưa.
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      if (!await _auth.canCheckBiometrics) return false;
      final types = await _auth.getAvailableBiometrics();
      return types.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Hiện hộp thoại xác thực sinh trắc học. Trả về true khi thành công,
  /// false khi người dùng hủy hoặc thiết bị không hỗ trợ.
  Future<bool> authenticate({String reason = 'Xác thực để tiếp tục'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } catch (_) {
      return false;
    }
  }
}

/// Provider BiometricRepository (keepAlive).
@Riverpod(keepAlive: true)
BiometricRepository biometricRepository(Ref ref) => BiometricRepository();
