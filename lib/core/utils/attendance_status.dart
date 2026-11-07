import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/work_shift.dart';
import 'package:timekeeper/core/utils/date_utils.dart';

/// Trạng thái một ngày công, dùng để tô màu lịch.
enum AttendanceStatus {
  onTime('Đúng giờ'),
  late('Đi muộn'),
  overtime('Có tăng ca'),
  missingCheckOut('Thiếu check-out'),
  absent('Vắng'),
  inProgress('Đang làm'),
  dayOff('Ngày nghỉ'),
  upcoming('Chưa tới');

  const AttendanceStatus(this.label);

  /// Nhãn tiếng Việt để hiển thị.
  final String label;

  /// Trạng thái cần gửi đơn bù công.
  bool get needsCorrection =>
      this == AttendanceStatus.absent ||
      this == AttendanceStatus.missingCheckOut ||
      this == AttendanceStatus.late;
}

/// Tính trạng thái ngày công. Hàm thuần, không gọi DB, dễ viết unit test.
class AttendanceStatusCalculator {
  const AttendanceStatusCalculator({this.shift = WorkShift.standard});

  /// Ca làm dùng để so giờ vào/ra.
  final WorkShift shift;

  /// Trạng thái của ngày [day] dựa trên bản ghi [record] và thời điểm [now].
  /// Thứ tự ưu tiên: vắng > thiếu check-out > muộn > tăng ca > đúng giờ.
  AttendanceStatus statusFor({
    required DateTime day,
    required AttendanceRecord? record,
    required DateTime now,
  }) {
    final today = AppDate.dateOnly(now);
    final date = AppDate.dateOnly(day);

    if (date.isAfter(today)) return AttendanceStatus.upcoming;

    if (record == null || !record.hasCheckedIn) {
      if (AppDate.isWeekend(date)) return AttendanceStatus.dayOff;
      // Hôm nay mà chưa hết ca thì chưa tính vắng.
      if (date == today && now.isBefore(shift.endOn(date))) {
        return AttendanceStatus.upcoming;
      }
      return AttendanceStatus.absent;
    }

    if (!record.hasCheckedOut) {
      return date == today
          ? AttendanceStatus.inProgress
          : AttendanceStatus.missingCheckOut;
    }

    if (isLate(record)) return AttendanceStatus.late;
    if (hasOvertime(record)) return AttendanceStatus.overtime;
    return AttendanceStatus.onTime;
  }

  /// Vào muộn hơn giờ bắt đầu ca + số phút cho phép.
  bool isLate(AttendanceRecord record) {
    final checkIn = record.checkInAt;
    if (checkIn == null) return false;
    return _isLateAt(record.workDate, checkIn);
  }

  /// Giống [isLate] nhưng dùng khi chưa có bản ghi (lúc đang check-in).
  bool isLateAt(DateTime checkIn) => _isLateAt(checkIn, checkIn);

  bool _isLateAt(DateTime day, DateTime checkIn) {
    final limit =
        shift.startOn(day).add(Duration(minutes: shift.lateGraceMinutes));
    return checkIn.isAfter(limit);
  }

  /// Số phút đi muộn so với giờ bắt đầu ca (0 nếu đúng giờ).
  int lateMinutes(AttendanceRecord record) {
    final checkIn = record.checkInAt;
    return checkIn == null ? 0 : lateMinutesAt(checkIn);
  }

  /// Số phút đi muộn nếu vào lúc [checkIn].
  int lateMinutesAt(DateTime checkIn) {
    final diff = checkIn.difference(shift.startOn(checkIn)).inMinutes;
    return diff > 0 ? diff : 0;
  }

  /// Số phút về sớm nếu ra lúc [checkOut] (0 nếu ra sau giờ kết thúc ca).
  int earlyLeaveMinutesAt(DateTime checkOut) {
    final diff = shift.endOn(checkOut).difference(checkOut).inMinutes;
    return diff > 0 ? diff : 0;
  }

  /// TẠM THỜI: OT thật lấy từ đơn OT đã duyệt của TV3.
  /// Hiện tại chỉ đánh dấu khi ra muộn hơn giờ kết thúc ca.
  bool hasOvertime(AttendanceRecord record) {
    final checkOut = record.checkOutAt;
    if (checkOut == null) return false;
    final limit = shift
        .endOn(record.workDate)
        .add(Duration(minutes: shift.overtimeThresholdMinutes));
    return checkOut.isAfter(limit);
  }
}
