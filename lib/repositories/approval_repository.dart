import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/profile.dart';
part 'approval_repository.g.dart';

/// Data access for TV5; request table names match the shared schema.
class ApprovalRepository {
  ApprovalRepository(this.client);
  final SupabaseClient client;
  Future<Map<String, dynamic>> detail(
    Profile actor,
    String table,
    String id,
  ) async {
    if (!tables.contains(table)) throw ArgumentError('Loại đơn không hợp lệ');
    final row = await client.from(table).select().eq('id', id).single();
    final employeeId = row['employee_id'] as String;
    if (employeeId != actor.id && !(await team(actor)).contains(employeeId)) {
      throw StateError('Bạn không có quyền xem đơn này');
    }
    return row;
  }

  static const tables = [
    'ot_requests',
    'leave_requests',
    'attendance_corrections',
  ];
  Future<List<String>> team(Profile actor) async {
    if (actor.role == UserRole.employee) {
      throw StateError('Chỉ quản lý được xem đội nhóm');
    }
    var query = client.from('profiles').select('id');
    if (actor.role != UserRole.admin) query = query.eq('manager_id', actor.id);
    return (await query)
        .map((row) => row['id'] as String)
        .where((id) => id != actor.id)
        .toList();
  }

  Future<List<Map<String, dynamic>>> inbox(Profile actor) async {
    final ids = await team(actor);
    if (ids.isEmpty) return [];
    final profileRows = await client
        .from('profiles')
        .select('id, full_name, email')
        .inFilter('id', ids);
    final profiles = {for (final row in profileRows) row['id'] as String: row};
    final result = <Map<String, dynamic>>[];
    for (final table in tables) {
      final rows = await client
          .from(table)
          .select()
          .inFilter('employee_id', ids)
          .eq('status', 'pending')
          .order('created_at');
      result.addAll(
        rows.map((row) {
          final employee = profiles[row['employee_id']];
          return {
            ...row,
            'table': table,
            'employee_name': employee?['full_name'],
            'employee_email': employee?['email'],
          };
        }),
      );
    }
    result.sort(
      (a, b) =>
          (a['created_at'] as String).compareTo(b['created_at'] as String),
    );
    return result;
  }

  Future<void> decide(
    Profile actor,
    Map<String, dynamic> row,
    bool approve,
    String reason,
  ) async {
    if (!tables.contains(row['table'])) {
      throw ArgumentError('Loại đơn không hợp lệ');
    }
    if (!approve && reason.trim().isEmpty) {
      throw ArgumentError('Cần nhập lý do từ chối');
    }
    if (!(await team(actor)).contains(row['employee_id'])) {
      throw StateError('Đơn không thuộc đội nhóm');
    }
    try {
      await client.rpc(
        'tv5_decide_request',
        params: {
          'p_table': row['table'],
          'p_id': row['id'],
          'p_actor': actor.id,
          'p_approve': approve,
          'p_reason': reason.trim(),
        },
      );
    } on PostgrestException catch (error) {
      // Giữ app chạy với database cũ trong lúc cả nhóm chưa chạy migration.
      // Sau khi chạy supabase/tv5_approval.sql, RPC xử lý mọi việc atomically.
      if (error.code != 'PGRST202') rethrow;
      await _decideWithCurrentDevPolicy(actor, row, approve, reason.trim());
    }
  }

  /// Cập nhật trực tiếp vì project đang dùng Firebase Auth tách rời Supabase
  /// Auth và schema dev cho phép role `anon` đọc/ghi. Khi chuyển sang production,
  /// thay phần này bằng RPC `tv5_decide_request` sau khi cấu hình Firebase JWT
  /// trong Supabase để việc cập nhật đơn + tạo thông báo chạy trong một transaction.
  Future<void> _decideWithCurrentDevPolicy(
    Profile actor,
    Map<String, dynamic> row,
    bool approve,
    String reason,
  ) async {
    final table = row['table'] as String;
    final requestId = row['id'] as String;
    final status = approve ? 'approved' : 'rejected';
    final updated = await client
        .from(table)
        .update({
          'status': status,
          'approved_by': actor.id,
          'approved_at': DateTime.now().toUtc().toIso8601String(),
          'reject_reason': approve ? null : reason,
        })
        .eq('id', requestId)
        .eq('status', 'pending')
        .select('id')
        .maybeSingle();

    if (updated == null) {
      throw StateError('Đơn đã được người khác xử lý hoặc không còn tồn tại');
    }

    if (approve) {
      await _applyApprovedEffects(row);
    }

    await client.from('notifications').insert({
      'recipient_id': row['employee_id'],
      'title': approve ? 'Đơn đã được duyệt' : 'Đơn bị từ chối',
      'body': approve
          ? 'Quản lý đã duyệt ${_requestTypeLabel(table)} của bạn.'
          : 'Quản lý đã từ chối ${_requestTypeLabel(table)}: $reason',
      'type': _notificationType(table),
      'ref_table': table,
      'ref_id': requestId,
    });
  }

  Future<void> _applyApprovedEffects(Map<String, dynamic> row) async {
    switch (row['table']) {
      case 'leave_requests':
        await _applyLeaveBalance(row);
        return;
      case 'attendance_corrections':
        await _applyAttendanceCorrection(row);
        return;
    }
  }

  Future<void> _applyLeaveBalance(Map<String, dynamic> row) async {
    final startDate = DateTime.parse(row['start_date'] as String);
    final employeeId = row['employee_id'] as String;
    final leaveTypeId = row['leave_type_id'] as String;
    final used = (row['total_days'] as num).toDouble();
    final existing = await client
        .from('leave_balances')
        .select('id, used_days')
        .eq('employee_id', employeeId)
        .eq('leave_type_id', leaveTypeId)
        .eq('year', startDate.year)
        .maybeSingle();
    if (existing != null) {
      await client
          .from('leave_balances')
          .update({
            'used_days': (existing['used_days'] as num).toDouble() + used,
          })
          .eq('id', existing['id'] as String);
      return;
    }
    final leaveType = await client
        .from('leave_types')
        .select('default_days')
        .eq('id', leaveTypeId)
        .single();
    await client.from('leave_balances').insert({
      'employee_id': employeeId,
      'leave_type_id': leaveTypeId,
      'year': startDate.year,
      'total_days': leaveType['default_days'],
      'used_days': used,
    });
  }

  Future<void> _applyAttendanceCorrection(Map<String, dynamic> row) async {
    Map<String, dynamic>? attendance;
    final attendanceId = row['attendance_id'] as String?;
    if (attendanceId != null) {
      attendance = await client
          .from('attendance_records')
          .select()
          .eq('id', attendanceId)
          .maybeSingle();
    }
    attendance ??= await client
        .from('attendance_records')
        .select()
        .eq('employee_id', row['employee_id'] as String)
        .eq('work_date', row['work_date'] as String)
        .maybeSingle();

    final checkIn = row['requested_check_in'] ?? attendance?['check_in_at'];
    final checkOut = row['requested_check_out'] ?? attendance?['check_out_at'];
    final checkInDate = checkIn == null ? null : DateTime.parse('$checkIn');
    final checkOutDate = checkOut == null ? null : DateTime.parse('$checkOut');
    if (checkInDate != null &&
        checkOutDate != null &&
        checkOutDate.isBefore(checkInDate)) {
      throw StateError('Giờ ra phải sau giờ vào');
    }
    final saved = await client
        .from('attendance_records')
        .upsert({
          if (attendance?['id'] != null) 'id': attendance!['id'],
          'employee_id': row['employee_id'],
          'work_date': row['work_date'],
          'check_in_at': checkIn,
          'check_out_at': checkOut,
          'work_hours': checkInDate != null && checkOutDate != null
              ? checkOutDate.difference(checkInDate).inMinutes / 60
              : (attendance?['work_hours'] ?? 0),
          'status': attendance?['status'] == 'absent'
              ? 'present'
              : (attendance?['status'] ?? 'present'),
          'note': 'Cập nhật từ đơn bù công ${row['id']}',
        }, onConflict: 'employee_id,work_date')
        .select('id')
        .single();
    await client
        .from('attendance_corrections')
        .update({'attendance_id': saved['id']})
        .eq('id', row['id'] as String);
  }

  String _requestTypeLabel(String table) => switch (table) {
    'ot_requests' => 'đơn tăng ca',
    'leave_requests' => 'đơn nghỉ phép',
    'attendance_corrections' => 'đơn bù công',
    _ => 'đơn',
  };

  String _notificationType(String table) => switch (table) {
    'ot_requests' => 'ot',
    'leave_requests' => 'leave',
    'attendance_corrections' => 'correction',
    _ => 'general',
  };

  Future<List<Map<String, dynamic>>> notifications(Profile actor) => client
      .from('notifications')
      .select()
      .eq('recipient_id', actor.id)
      .order('created_at', ascending: false)
      .limit(100);
  Future<void> markRead(Profile actor, String id) async {
    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id)
        .eq('recipient_id', actor.id);
  }

  Future<List<Map<String, dynamic>>> dashboard(Profile actor) async {
    final ids = await team(actor);
    if (ids.isEmpty) return [];
    final now = DateTime.now();
    final day =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final attendance = await client
        .from('attendance_records')
        .select()
        .inFilter('employee_id', ids)
        .eq('work_date', day)
        .gt('late_minutes', 0);
    final leave = await client
        .from('leave_requests')
        .select()
        .inFilter('employee_id', ids)
        .eq('status', 'approved')
        .lte('start_date', day)
        .gte('end_date', day);
    return [
      ...attendance.map((r) => {...r, 'kind': 'Đi muộn'}),
      ...leave.map((r) => {...r, 'kind': 'Nghỉ phép'}),
    ];
  }
}

@Riverpod(keepAlive: true)
ApprovalRepository approvalRepository(Ref ref) =>
    ApprovalRepository(ref.watch(supabaseProvider));
