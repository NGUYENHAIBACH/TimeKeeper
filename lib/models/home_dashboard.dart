import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/profile.dart';

part 'home_dashboard.freezed.dart';

/// Toàn bộ dữ liệu màn Home Dashboard, gom lại để View chỉ watch một provider.
@freezed
abstract class HomeDashboard with _$HomeDashboard {
  const factory HomeDashboard({
    required Profile profile,

    /// Bản ghi chấm công hôm nay (model của TV2). Null = chưa chấm công.
    AttendanceRecord? today,
    required MonthlySummary summary,
    required LeaveBalanceSummary leave,
  }) = _HomeDashboard;
}
