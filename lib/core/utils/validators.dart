/// Các hàm validate dùng cho TextFormField. Trả về null khi hợp lệ,
/// ngược lại trả về thông báo lỗi tiếng Việt để hiển thị dưới ô nhập.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _phoneRegex = RegExp(r'^(0|\+84)\d{9}$');

  /// Email đúng định dạng.
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập email';
    if (!_emailRegex.hasMatch(v)) return 'Email không đúng định dạng';
    return null;
  }

  /// Mật khẩu tối thiểu 8 ký tự, có cả chữ và số.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
    if (!RegExp(r'[A-Za-z]').hasMatch(v)) return 'Mật khẩu phải có chữ cái';
    if (!RegExp(r'\d').hasMatch(v)) return 'Mật khẩu phải có chữ số';
    return null;
  }

  /// Xác nhận mật khẩu phải khớp với [original].
  static String? Function(String?) confirmPassword(String original) {
    return (value) {
      if ((value ?? '').isEmpty) return 'Vui lòng nhập lại mật khẩu';
      if (value != original) return 'Mật khẩu nhập lại không khớp';
      return null;
    };
  }

  /// Trường bắt buộc, không được để trống.
  static String? required(String? value, {String field = 'Trường này'}) {
    if ((value ?? '').trim().isEmpty) return '$field không được để trống';
    return null;
  }

  /// Số điện thoại Việt Nam: 0xxxxxxxxx hoặc +84xxxxxxxxx. Cho phép để trống.
  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (!_phoneRegex.hasMatch(v)) return 'Số điện thoại không hợp lệ';
    return null;
  }
}
