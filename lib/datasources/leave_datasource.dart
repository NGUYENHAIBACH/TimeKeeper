import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timekeeper/core/providers/core_providers.dart';

part 'leave_datasource.g.dart';

/// Truy cập các bảng nghỉ phép trên Supabase.
/// TV1 viết phần ĐỌC số dư cho Dashboard; TV4 bổ sung đơn nghỉ, ngày lễ...
class LeaveDataSource {
  LeaveDataSource(this._client);

  final SupabaseClient _client;

  /// Số dư phép của [employeeId] trong [year], kèm mã loại phép.
  /// Mỗi phần tử: `{total_days, used_days, leave_types: {code}}`.
  Future<List<Map<String, dynamic>>> getBalances(String employeeId, int year) {
    return _client
        .from('leave_balances')
        .select('total_days, used_days, leave_types(code)')
        .eq('employee_id', employeeId)
        .eq('year', year);
  }

  /// Cấp số dư mặc định (theo `leave_types.default_days`) cho năm [year]
  /// nếu nhân viên chưa có. Dòng đã tồn tại được giữ nguyên.
  Future<void> createDefaultBalances(String employeeId, int year) async {
    final types = await _client.from('leave_types').select('id, default_days');
    if (types.isEmpty) return;
    final rows = [
      for (final t in types)
        {
          'employee_id': employeeId,
          'leave_type_id': t['id'],
          'year': year,
          'total_days': t['default_days'],
        },
    ];
    await _client.from('leave_balances').upsert(
          rows,
          onConflict: 'employee_id,leave_type_id,year',
          ignoreDuplicates: true,
        );
  }
}

/// Provider LeaveDataSource (keepAlive).
@Riverpod(keepAlive: true)
LeaveDataSource leaveDataSource(Ref ref) {
  return LeaveDataSource(ref.watch(supabaseProvider));
}
