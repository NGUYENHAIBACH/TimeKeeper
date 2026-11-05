import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/today_attendance.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/repositories/leave_repository.dart';

/// Repository giả cùng interface với bản thật. Dùng cho unit test và để
/// dựng UI khi backend của module khác chưa xong:
///
/// ```dart
/// ProviderScope(overrides: [
///   attendanceRepositoryProvider.overrideWithValue(MockAttendanceRepository()),
///   leaveRepositoryProvider.overrideWithValue(MockLeaveRepository()),
/// ])
/// ```
class MockAttendanceRepository implements AttendanceRepository {
  MockAttendanceRepository({
    this.today,
    this.summary = const MonthlySummary(totalHours: 96.5, workDays: 12, lateDays: 1),
    this.error,
  });

  /// Chấm công hôm nay sẽ trả về (null = chưa check-in).
  final TodayAttendance? today;
  final MonthlySummary summary;

  /// Nếu khác null, mọi hàm sẽ ném lỗi này (để test nhánh error).
  final Object? error;

  @override
  Future<TodayAttendance?> getTodayAttendance(String employeeId) async {
    if (error != null) throw error!;
    return today;
  }

  @override
  Future<MonthlySummary> getMonthlySummary(String employeeId, DateTime month) async {
    if (error != null) throw error!;
    return summary;
  }
}

/// Repository nghỉ phép giả.
class MockLeaveRepository implements LeaveRepository {
  MockLeaveRepository({
    this.balance = const LeaveBalanceSummary(totalDays: 12, usedDays: 3.5),
    this.error,
  });

  final LeaveBalanceSummary balance;
  final Object? error;

  @override
  Future<LeaveBalanceSummary> getLeaveBalance(String employeeId, {int? year}) async {
    if (error != null) throw error!;
    return balance;
  }
}
