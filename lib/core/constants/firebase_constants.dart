/// Hằng số Firebase dùng chung. Các giá trị này KHÔNG phải bí mật
/// (đã nằm trong google-services.json được commit), nên để ngoài env.dart.
class FirebaseConstants {
  FirebaseConstants._();

  /// Web client ID (client_type 3 trong google-services.json).
  /// google_sign_in 7.x cần giá trị này làm `serverClientId` để lấy idToken
  /// đăng nhập Firebase trên Android. Thay đổi khi đổi Firebase project.
  static const googleWebClientId =
      '650794462799-7n526kc6tkgs64e9jva0lr0fht99amre.apps.googleusercontent.com';
}
