import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/repositories/leave_repository.dart';

/// Repository giả cùng interface với bản thật. Dùng cho unit test và để
/// dựng UI khi backend của module khác chưa xong:
///
/// ```dart
/// ProviderScope(overrides: [
///   attendanceRepositoryProvider.overrideWith((ref) async => MockAttendanceRepository()),
///   leaveRepositoryProvider.overrideWithValue(MockLeaveRepository()),
/// ])
/// ```
///
/// Bản giả chấm công chỉ cài 2 hàm ĐỌC mà Dashboard cần ([getRecord],
/// [getRecordsInMonth]); gọi hàm khác của interface sẽ ném NoSuchMethodError.
class MockAttendanceRepository implements AttendanceRepository {
  MockAttendanceRepository({this.today, this.monthRecords = const [], this.error});

  /// Bản ghi hôm nay sẽ trả về (null = chưa check-in).
  final AttendanceRecord? today;

  /// Các bản ghi trong tháng, dùng để tính tổng giờ / ngày công / ngày trễ.
  final List<AttendanceRecord> monthRecords;

  /// Nếu khác null, mọi hàm sẽ ném lỗi này (để test nhánh error).
  final Object? error;

  @override
  Future<AttendanceRecord?> getRecord(String employeeId, DateTime day) async {
    if (error != null) throw error!;
    return today;
  }

  @override
  Future<List<AttendanceRecord>> getRecordsInMonth(
    String employeeId,
    DateTime month,
  ) async {
    if (error != null) throw error!;
    return monthRecords;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
