import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/datasources/leave_datasource.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';

part 'leave_repository.g.dart';

/// Interface nghỉ phép mà các module khác dùng (TV1 Dashboard, TV3, TV5).
/// TV4 bổ sung tạo đơn nghỉ, danh sách ngày lễ... vào đây.
abstract interface class LeaveRepository {
  /// Số dư phép năm (loại `annual`) của nhân viên trong [year]
  /// (mặc định năm hiện tại).
  Future<LeaveBalanceSummary> getLeaveBalance(String employeeId, {int? year});
}

/// Bản thật: đọc từ Supabase qua [LeaveDataSource].
class SupabaseLeaveRepository implements LeaveRepository {
  SupabaseLeaveRepository(this._ds);

  final LeaveDataSource _ds;

  /// Mã loại phép hiển thị trên Dashboard.
  static const annualCode = 'annual';

  @override
  Future<LeaveBalanceSummary> getLeaveBalance(String employeeId, {int? year}) async {
    final y = year ?? DateTime.now().year;
    var rows = await _ds.getBalances(employeeId, y);
    // Nhân viên mới chưa có số dư năm nay -> cấp mặc định rồi đọc lại.
    if (rows.isEmpty) {
      await _ds.createDefaultBalances(employeeId, y);
      rows = await _ds.getBalances(employeeId, y);
    }
    return pickAnnual(rows);
  }

  /// Lấy dòng phép năm trong danh sách số dư. Tách riêng để test.
  static LeaveBalanceSummary pickAnnual(List<Map<String, dynamic>> rows) {
    for (final row in rows) {
      final type = row['leave_types'];
      if (type is Map && type['code'] == annualCode) {
        return LeaveBalanceSummary(
          totalDays: (row['total_days'] as num?)?.toDouble() ?? 0,
          usedDays: (row['used_days'] as num?)?.toDouble() ?? 0,
        );
      }
    }
    return const LeaveBalanceSummary();
  }
}

/// Provider trả về interface, test override bằng bản mock.
@Riverpod(keepAlive: true)
LeaveRepository leaveRepository(Ref ref) {
  return SupabaseLeaveRepository(ref.watch(leaveDataSourceProvider));
}
