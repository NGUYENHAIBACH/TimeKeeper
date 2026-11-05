import 'package:freezed_annotation/freezed_annotation.dart';

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
}
