import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timekeeper/models/attendance_record.dart';

part 'monthly_summary.freezed.dart';

/// Tổng hợp công của một tháng, tính từ các dòng `attendance_records`.
@freezed
abstract class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    /// Tổng số giờ làm trong tháng.
    @Default(0) double totalHours,

    /// Số ngày có check-in.
    @Default(0) int workDays,

    /// Số ngày đi trễ (late_minutes > 0).
    @Default(0) int lateDays,
  }) = _MonthlySummary;

  /// Cộng dồn danh sách bản ghi chấm công (của TV2) thành số liệu cho
  /// Dashboard. Hàm thuần, không gọi mạng, nên unit test trực tiếp được.
  static MonthlySummary fromRecords(Iterable<AttendanceRecord> records) {
    var hours = 0.0;
    var workDays = 0;
    var lateDays = 0;
    for (final r in records) {
      hours += r.workHours;
      if (r.hasCheckedIn) workDays++;
      if (r.lateMinutes > 0) lateDays++;
    }
    return MonthlySummary(totalHours: hours, workDays: workDays, lateDays: lateDays);
  }
}
