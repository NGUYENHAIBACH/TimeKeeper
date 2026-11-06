import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/core/utils/date_utils.dart';

/// Kiểm tra đơn bù công trước khi gửi. Trả về danh sách lỗi (rỗng = hợp lệ).
class CorrectionValidator {
  CorrectionValidator._();

  /// Số ký tự tối thiểu của lý do.
  static const minReasonLength = 10;

  /// Kiểm tra đơn bù công cho ngày [workDate]. [existing] là các đơn đã có
  /// của ngày đó (để chặn gửi trùng khi còn đơn chờ duyệt).
  static List<String> validate({
    required DateTime workDate,
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String reason,
    required DateTime now,
    List<AttendanceCorrection> existing = const [],
  }) {
    final errors = <String>[];
    final date = AppDate.dateOnly(workDate);

    if (date.isAfter(AppDate.dateOnly(now))) {
      errors.add('Không thể gửi đơn bù công cho ngày chưa tới.');
    }
    if (checkIn == null && checkOut == null) {
      errors.add('Cần nhập ít nhất giờ vào hoặc giờ ra.');
    }
    if (checkIn != null && checkOut != null && !checkOut.isAfter(checkIn)) {
      errors.add('Giờ ra phải sau giờ vào.');
    }
    if (checkOut != null && checkOut.isAfter(now)) {
      errors.add('Giờ ra không được ở tương lai.');
    }
    if (reason.trim().length < minReasonLength) {
      errors.add('Lý do cần ít nhất $minReasonLength ký tự.');
    }
    if (existing.any((c) => c.status == CorrectionStatus.pending)) {
      errors.add('Ngày này đã có đơn đang chờ duyệt.');
    }
    return errors;
  }
}
