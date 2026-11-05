import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/models/today_attendance.dart';

part 'home_dashboard.freezed.dart';

/// Toàn bộ dữ liệu màn Home Dashboard, gom lại để View chỉ watch một provider.
@freezed
abstract class HomeDashboard with _$HomeDashboard {
  const factory HomeDashboard({
    required Profile profile,

    /// Null = hôm nay chưa chấm công.
    TodayAttendance? today,
    required MonthlySummary summary,
    required LeaveBalanceSummary leave,
  }) = _HomeDashboard;
}
