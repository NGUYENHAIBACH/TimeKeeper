import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/office_location.dart';
import 'package:timekeeper/models/work_shift.dart';

part 'attendance_remote_ds.g.dart';

/// DataSource Supabase cho chấm công.
@Riverpod(keepAlive: true)
AttendanceRemoteDataSource attendanceRemoteDataSource(Ref ref) =>
    AttendanceRemoteDataSource(ref.watch(supabaseProvider));

/// Đọc/ghi 3 bảng chấm công trên Supabase.
/// Mọi lệnh có timeout để app chuyển sang dữ liệu SQLite khi mạng chậm.
class AttendanceRemoteDataSource {
  AttendanceRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const _timeout = Duration(seconds: 10);

  /// Văn phòng đang hoạt động đầu tiên (theo tên).
  Future<OfficeLocation?> getActiveOffice() async {
    final row = await _client
        .from('office_locations')
        .select()
        .eq('is_active', true)
        .order('name')
        .limit(1)
        .maybeSingle()
        .timeout(_timeout);
    return row == null ? null : OfficeLocation.fromMap(row);
  }

  /// Ca làm theo `shifts.id` (bảng của TV1), null nếu không có.
  Future<WorkShift?> getShift(String id) async {
    final row = await _client
        .from('shifts')
        .select()
        .eq('id', id)
        .maybeSingle()
        .timeout(_timeout);
    return row == null ? null : WorkShift.fromMap(row);
  }

  /// Cập nhật tọa độ/bán kính văn phòng.
  Future<void> updateOffice(OfficeLocation office) => _client
      .from('office_locations')
      .update(office.toRemote())
      .eq('id', office.id)
      .timeout(_timeout);

  /// Bản ghi chấm công trong khoảng [from, to].
  Future<List<AttendanceRecord>> getRecordsBetween(
    String employeeId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _client
        .from('attendance_records')
        .select()
        .eq('employee_id', employeeId)
        .gte('work_date', AppDate.key(from))
        .lte('work_date', AppDate.key(to))
        .order('work_date')
        .timeout(_timeout);
    return rows.map(AttendanceRecord.fromMap).toList();
  }

  /// Thêm hoặc cập nhật bản ghi (khóa: nhân viên + ngày).
  Future<void> upsertRecord(AttendanceRecord record) => _client
      .from('attendance_records')
      .upsert(record.toRemote(), onConflict: 'employee_id,work_date')
      .timeout(_timeout);

  /// Đơn bù công trong khoảng [from, to], mới nhất trước.
  Future<List<AttendanceCorrection>> getCorrectionsBetween(
    String employeeId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _client
        .from('attendance_corrections')
        .select()
        .eq('employee_id', employeeId)
        .gte('work_date', AppDate.key(from))
        .lte('work_date', AppDate.key(to))
        .order('created_at', ascending: false)
        .timeout(_timeout);
    return rows.map(AttendanceCorrection.fromMap).toList();
  }

  /// Thêm hoặc cập nhật đơn bù công.
  Future<void> upsertCorrection(AttendanceCorrection c) => _client
      .from('attendance_corrections')
      .upsert(c.toRemote())
      .timeout(_timeout);
}
