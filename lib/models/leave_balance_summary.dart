import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance_summary.freezed.dart';

/// Số dư phép năm của nhân viên (loại phép `annual`), dùng cho Dashboard.
/// TV4 có thể mở rộng thành danh sách theo từng loại phép.
@freezed
abstract class LeaveBalanceSummary with _$LeaveBalanceSummary {
  const LeaveBalanceSummary._();

  const factory LeaveBalanceSummary({
    @Default(0) double totalDays,
    @Default(0) double usedDays,
  }) = _LeaveBalanceSummary;

  /// Số ngày phép còn lại.
  double get remainingDays => totalDays - usedDays;
}
