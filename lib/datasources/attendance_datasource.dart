import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/core/utils/date_utils.dart';

part 'attendance_datasource.g.dart';

/// Truy cập bảng `attendance_records` trên Supabase.
/// TV1 viết phần ĐỌC cho Dashboard; TV2 bổ sung check-in / check-out /
/// đơn bù công vào chính lớp này.
class AttendanceDataSource {
  AttendanceDataSource(this._client);

  final SupabaseClient _client;
  static const _table = 'attendance_records';

  /// Dòng chấm công của [employeeId] trong ngày [date]. Null nếu chưa có.
  Future<Map<String, dynamic>?> getByDate(String employeeId, DateTime date) {
    return _client
        .from(_table)
        .select()
        .eq('employee_id', employeeId)
        .eq('work_date', AppDateUtils.toDateString(date))
        .maybeSingle();
  }

  /// Các dòng chấm công từ [from] đến [to] (tính cả hai đầu).
  Future<List<Map<String, dynamic>>> getRange(
    String employeeId,
    DateTime from,
    DateTime to,
  ) {
    return _client
        .from(_table)
        .select()
        .eq('employee_id', employeeId)
        .gte('work_date', AppDateUtils.toDateString(from))
        .lte('work_date', AppDateUtils.toDateString(to))
        .order('work_date');
  }
}

/// Provider AttendanceDataSource (keepAlive).
@Riverpod(keepAlive: true)
AttendanceDataSource attendanceDataSource(Ref ref) {
  return AttendanceDataSource(ref.watch(supabaseProvider));
}
