// FILE TẠM. Sẽ bị ghi đè khi chạy `flutterfire configure`.
// Giữ để project compile được trước khi có Firebase; main() bắt lỗi
// UnsupportedError và chạy tiếp ở chế độ "chưa có Firebase".

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Cấu hình Firebase theo nền tảng. Bản thật do FlutterFire CLI sinh ra.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// Ném lỗi cho đến khi `flutterfire configure` tạo file thật.
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Chưa cấu hình Firebase. Chạy: flutterfire configure',
    );
  }
}
