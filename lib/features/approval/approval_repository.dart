import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';
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
    return await client
        .from(table)
        .select()
        .eq('id', id)
        .eq('employee_id', actor.id)
        .single();
  }

  Future<String> export(List<Map<String, dynamic>> rows, bool pdf) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/team-${DateTime.now().millisecondsSinceEpoch}.${pdf ? 'pdf' : 'xlsx'}',
    );
    final data = rows
        .map(
          (r) => [
            '${r['employee_id']}',
            r['kind'] == 'Đi muộn' ? 'Late' : 'Leave',
            '${r['late_minutes'] ?? ''}',
          ],
        )
        .toList();
    if (pdf) {
      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          build: (_) => [
            pw.Text('TimeKeeper - Team report'),
            pw.TableHelper.fromTextArray(
              headers: ['Employee ID', 'Status', 'Late minutes'],
              data: data,
            ),
          ],
        ),
      );
      await file.writeAsBytes(await document.save());
    } else {
      final book = Excel.createExcel();
      final sheet = book['Team'];
      for (final row in [
        ['Employee ID', 'Status', 'Late minutes'],
        ...data,
      ]) {
        sheet.appendRow(row.map((cell) => TextCellValue(cell)).toList());
      }
      book.delete('Sheet1');
      await file.writeAsBytes(book.encode()!);
    }
    return file.path;
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
  }

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
Future<Profile> currentProfile(Ref ref) async {
  final profile = await ref.read(profileViewModelProvider.future);
  if (profile == null) throw StateError('Chưa có hồ sơ nhân viên');
  return profile;
}
