/// Ca làm việc dùng để tính đi muộn / về sớm / tăng ca.
///
/// TẠM THỜI: ca thật nằm trong bảng `shifts` (TV1), gắn với nhân viên qua
/// `profiles.shift_id`. Khi TV1 có `profileViewModelProvider`, đọc ca thật
/// thay cho [WorkShift.standard].
class WorkShift {
  const WorkShift({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.lateGraceMinutes = 5,
    this.overtimeThresholdMinutes = 30,
  });

  /// Ca hành chính 08:00 – 17:00 (giống "Ca hanh chinh" trong seed.sql).
  static const standard = WorkShift(
    startHour: 8,
    startMinute: 0,
    endHour: 17,
    endMinute: 0,
  );

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  /// Vào sau giờ bắt đầu quá số phút này thì tính là đi muộn
  /// (cột `shifts.grace_minutes`).
  final int lateGraceMinutes;

  /// Ra sau giờ kết thúc quá số phút này thì đánh dấu có làm thêm.
  final int overtimeThresholdMinutes;

  /// Giờ bắt đầu ca vào ngày [day].
  DateTime startOn(DateTime day) =>
      DateTime(day.year, day.month, day.day, startHour, startMinute);

  /// Giờ kết thúc ca vào ngày [day].
  DateTime endOn(DateTime day) =>
      DateTime(day.year, day.month, day.day, endHour, endMinute);
}
