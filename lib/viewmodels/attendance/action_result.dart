/// Kết quả một thao tác (check-in, gửi đơn…) để View hiện thông báo.
class ActionResult {
  const ActionResult.success(this.message) : success = true;
  const ActionResult.failure(this.message) : success = false;

  /// true = thành công.
  final bool success;
  /// Câu thông báo cho người dùng.
  final String message;
}
