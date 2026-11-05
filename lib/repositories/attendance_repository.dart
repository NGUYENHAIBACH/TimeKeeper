import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/datasources/attendance_datasource.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/today_attendance.dart';

part 'attendance_repository.g.dart';

/// Interface chấm công mà các module khác dùng (TV1 Dashboard, TV3 báo cáo,
/// TV5 Team Dashboard). TV2 bổ sung checkIn / checkOut vào đây.
abstract interface class AttendanceRepository {
  /// Chấm công hôm nay của nhân viên. Null nếu chưa check-in.
  Future<TodayAttendance?> getTodayAttendance(String employeeId);

  /// Tổng hợp công của tháng chứa [month].
  Future<MonthlySummary> getMonthlySummary(String employeeId, DateTime month);
}

/// Bản thật: đọc từ Supabase qua [AttendanceDataSource].
class SupabaseAttendanceRepository implements AttendanceRepository {
  SupabaseAttendanceRepository(this._ds);

  final AttendanceDataSource _ds;

  @override
  Future<TodayAttendance?> getTodayAttendance(String employeeId) async {
    final row = await _ds.getByDate(employeeId, DateTime.now());
    return row == null ? null : TodayAttendance.fromJson(row);
  }

  @override
  Future<MonthlySummary> getMonthlySummary(String employeeId, DateTime month) async {
    final rows = await _ds.getRange(
      employeeId,
      AppDateUtils.firstDayOfMonth(month),
      AppDateUtils.lastDayOfMonth(month),
    );
    return summarize(rows.map(TodayAttendance.fromJson));
  }

  /// Cộng dồn danh sách bản ghi thành [MonthlySummary]. Tách riêng để test.
  static MonthlySummary summarize(Iterable<TodayAttendance> records) {
    var hours = 0.0;
    var workDays = 0;
    var lateDays = 0;
    for (final r in records) {
      hours += r.workHours;
      if (r.checkInAt != null) workDays++;
      if (r.lateMinutes > 0) lateDays++;
    }
    return MonthlySummary(totalHours: hours, workDays: workDays, lateDays: lateDays);
  }
}

/// Provider trả về interface. Test override bằng bản mock:
/// `attendanceRepositoryProvider.overrideWithValue(MockAttendanceRepository())`.
@Riverpod(keepAlive: true)
AttendanceRepository attendanceRepository(Ref ref) {
  return SupabaseAttendanceRepository(ref.watch(attendanceDataSourceProvider));
}
