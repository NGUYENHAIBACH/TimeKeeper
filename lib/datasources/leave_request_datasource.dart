import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/holiday.dart';
import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/models/leave_type.dart';

part 'leave_request_datasource.g.dart';

/// DataSource module Nghỉ phép (TV4), gọi các bảng trên Supabase:
/// `leave_types`, `leave_balances`, `leave_requests`, `holidays`
/// và bucket Storage `leave_documents`. Chỉ Repository mới dùng lớp này.
class LeaveRequestDataSource {
  LeaveRequestDataSource(this._client);

  final SupabaseClient _client;

  static const _types = 'leave_types';
  static const _balances = 'leave_balances';
  static const _requests = 'leave_requests';
  static const _holidays = 'holidays';
  static const bucket = 'leave_documents';

  static final _dateFmt = DateFormat('yyyy-MM-dd');

  /// Chuỗi ngày dạng `yyyy-MM-dd` cho cột kiểu `date`.
  static String toDbDate(DateTime d) => _dateFmt.format(d);

  /// Tất cả loại phép, sắp theo tên.
  Future<List<LeaveType>> getLeaveTypes() async {
    final rows = await _client.from(_types).select().order('name');
    return rows.map(LeaveType.fromJson).toList();
  }

  /// Ngày lễ trong khoảng [from]..[to].
  Future<List<Holiday>> getHolidays(DateTime from, DateTime to) async {
    final rows = await _client
        .from(_holidays)
        .select()
        .gte('holiday_date', toDbDate(from))
        .lte('holiday_date', toDbDate(to))
        .order('holiday_date');
    return rows.map(Holiday.fromJson).toList();
  }

  /// Số dư phép của nhân viên trong năm, kèm thông tin loại phép.
  Future<List<LeaveBalance>> getBalances(String employeeId, int year) async {
    final rows = await _client
        .from(_balances)
        .select('*, leave_types(*)')
        .eq('employee_id', employeeId)
        .eq('year', year);
    return rows.map(LeaveBalance.fromJson).toList();
  }

  /// Tạo dòng số dư còn thiếu (bỏ qua dòng đã có nhờ unique key).
  Future<void> insertBalances(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await _client.from(_balances).upsert(
          rows,
          onConflict: 'employee_id,leave_type_id,year',
          ignoreDuplicates: true,
        );
  }

  /// Đơn nghỉ của 1 nhân viên, mới nhất trước.
  Future<List<LeaveRequest>> getMyRequests(String employeeId) async {
    final rows = await _client
        .from(_requests)
        .select('*, leave_types(*)')
        .eq('employee_id', employeeId)
        .order('start_date', ascending: false);
    return rows.map(LeaveRequest.fromJson).toList();
  }

  /// Tạo đơn mới, trả về đơn vừa tạo.
  Future<LeaveRequest> insertRequest(Map<String, dynamic> data) async {
    final row = await _client
        .from(_requests)
        .insert(data)
        .select('*, leave_types(*)')
        .single();
    return LeaveRequest.fromJson(row);
  }

  /// Hủy đơn: chỉ đổi được khi đơn còn `pending`.
  Future<void> cancelRequest(String id) async {
    await _client
        .from(_requests)
        .update({'status': LeaveStatus.cancelled.dbValue})
        .eq('id', id)
        .eq('status', LeaveStatus.pending.dbValue);
  }

  /// Đơn nghỉ (đã duyệt + chờ duyệt) của đồng nghiệp giao với [from]..[to].
  /// Lọc theo phòng ban nếu có [departmentId], không thì lấy cả công ty.
  Future<List<LeaveRequest>> getTeamLeaves({
    required DateTime from,
    required DateTime to,
    String? departmentId,
  }) async {
    var query = _client
        .from(_requests)
        .select(
          '*, leave_types(*), '
          'employee:profiles!employee_id!inner(full_name, email, department_id)',
        )
        .inFilter('status', [LeaveStatus.approved.dbValue, LeaveStatus.pending.dbValue])
        .lte('start_date', toDbDate(to))
        .gte('end_date', toDbDate(from));
    if (departmentId != null) {
      query = query.eq('employee.department_id', departmentId);
    }
    final rows = await query.order('start_date');
    return rows.map((row) {
      final emp = row['employee'] as Map<String, dynamic>?;
      final name = (emp?['full_name'] as String?)?.trim();
      final email = emp?['email'] as String?;
      return LeaveRequest.fromJson({
        ...row,
        'employee_name': (name == null || name.isEmpty) ? email : name,
      });
    }).toList();
  }

  /// Upload file đính kèm lên bucket `leave_documents`, trả URL public.
  /// Đường dẫn: `<employeeId>/<timestamp>_<tên file>`.
  Future<String> uploadAttachment(
    String employeeId,
    Uint8List bytes,
    String fileName,
  ) async {
    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final path = '$employeeId/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    await _client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: _contentType(safeName)),
        );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Xóa file đính kèm theo URL public (dùng khi gửi đơn thất bại).
  Future<void> deleteAttachment(String publicUrl) async {
    final marker = '/$bucket/';
    final i = publicUrl.indexOf(marker);
    if (i < 0) return;
    await _client.storage.from(bucket).remove([publicUrl.substring(i + marker.length)]);
  }

  static String _contentType(String name) {
    final ext = name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => 'application/octet-stream',
    };
  }
}

/// Provider LeaveRequestDataSource (keepAlive).
@Riverpod(keepAlive: true)
LeaveRequestDataSource leaveRequestDataSource(Ref ref) {
  return LeaveRequestDataSource(ref.watch(supabaseProvider));
}
