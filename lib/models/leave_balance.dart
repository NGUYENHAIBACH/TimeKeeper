// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timekeeper/models/leave_type.dart';

part 'leave_balance.freezed.dart';
part 'leave_balance.g.dart';

/// Số dư phép của 1 nhân viên / 1 loại phép / 1 năm (bảng `leave_balances`).
@freezed
abstract class LeaveBalance with _$LeaveBalance {
  const LeaveBalance._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LeaveBalance({
    required String id,
    required String employeeId,
    required String leaveTypeId,
    required int year,
    @Default(0) double totalDays,
    @Default(0) double usedDays,

    /// Cột generated trên DB = total_days - used_days.
    @Default(0) double remainingDays,

    /// Loại phép (join `leave_types(*)`).
    @JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType,
  }) = _LeaveBalance;

  factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceFromJson(json);

  /// Tỉ lệ đã dùng (0..1), dùng cho thanh tiến độ.
  double get usedRatio =>
      totalDays <= 0 ? 0 : (usedDays / totalDays).clamp(0, 1).toDouble();
}
