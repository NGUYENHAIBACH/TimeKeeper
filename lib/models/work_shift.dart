/// Ca làm việc dùng để tính đi muộn / về sớm / tăng ca.
///
/// Ánh xạ bảng `shifts` (TV1), gắn với nhân viên qua `profiles.shift_id`.
/// Nhân viên chưa được gán ca thì dùng [WorkShift.standard].
class WorkShift {
  const WorkShift({
    this.id,
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

  /// Đọc một dòng `shifts` (Supabase hoặc SQLite). Giờ dạng `HH:mm[:ss]`.
  factory WorkShift.fromMap(Map<String, dynamic> m) {
    final start = _parseTime(m['start_time'] as String);
    final end = _parseTime(m['end_time'] as String);
    return WorkShift(
      id: m['id'] as String?,
      startHour: start.$1,
      startMinute: start.$2,
      endHour: end.$1,
      endMinute: end.$2,
      lateGraceMinutes: (m['grace_minutes'] as num?)?.toInt() ?? 5,
    );
  }

  /// `shifts.id`; null với [standard].
  final String? id;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  /// Vào sau giờ bắt đầu quá số phút này thì tính là đi muộn
  /// (cột `shifts.grace_minutes`).
  final int lateGraceMinutes;

  /// Ra sau giờ kết thúc quá số phút này thì đánh dấu có làm thêm.
  final int overtimeThresholdMinutes;

  /// Map để lưu vào bảng `shifts` trong SQLite.
  Map<String, dynamic> toLocal() => {
        'id': id,
        'start_time': '${_two(startHour)}:${_two(startMinute)}',
        'end_time': '${_two(endHour)}:${_two(endMinute)}',
        'grace_minutes': lateGraceMinutes,
      };

  /// Giờ bắt đầu ca vào ngày [day].
  DateTime startOn(DateTime day) =>
      DateTime(day.year, day.month, day.day, startHour, startMinute);

  /// Giờ kết thúc ca vào ngày [day].
  DateTime endOn(DateTime day) =>
      DateTime(day.year, day.month, day.day, endHour, endMinute);

  static (int, int) _parseTime(String s) {
    final parts = s.split(':');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
