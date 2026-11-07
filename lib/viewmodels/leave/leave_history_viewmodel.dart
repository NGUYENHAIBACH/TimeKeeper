import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'leave_history_viewmodel.g.dart';

/// Bộ lọc danh sách đơn. Null = tất cả.
class LeaveFilter {
  const LeaveFilter({this.status, this.leaveTypeId});

  final LeaveStatus? status;
  final String? leaveTypeId;

  /// Đơn [r] có thỏa bộ lọc không.
  bool matches(LeaveRequest r) =>
      (status == null || r.status == status) &&
      (leaveTypeId == null || r.leaveTypeId == leaveTypeId);
}

/// Dữ liệu màn Lịch sử & Số dư phép.
class LeaveHistoryData {
  const LeaveHistoryData({required this.year, required this.balances, required this.requests});

  final int year;
  final List<LeaveBalance> balances;
  final List<LeaveRequest> requests;

  /// Tổng số ngày phép (có lương) còn lại.
  double get totalRemaining => balances
      .where((b) => b.leaveType?.isPaid ?? true)
      .fold(0, (s, b) => s + b.remainingDays);

  /// Tổng số ngày đang chờ duyệt.
  double get pendingDays => requests
      .where((r) => r.status == LeaveStatus.pending)
      .fold(0, (s, r) => s + r.totalDays);

  /// Danh sách đơn sau khi áp bộ lọc.
  List<LeaveRequest> filtered(LeaveFilter f) => requests.where(f.matches).toList();
}

/// ViewModel màn Lịch sử & Số dư phép.
@riverpod
class LeaveHistoryViewModel extends _$LeaveHistoryViewModel {
  @override
  Future<LeaveHistoryData> build() async {
    final profile = await ref.watch(profileViewModelProvider.future);
    if (profile == null) throw Exception('Chưa có hồ sơ nhân viên');
    final repo = ref.read(leaveRequestRepositoryProvider);
    final year = DateTime.now().year;
    final balances = await repo.getBalances(profile.id, year);
    final requests = await repo.getMyRequests(profile.id);
    return LeaveHistoryData(year: year, balances: balances, requests: requests);
  }

  /// Kéo để tải lại.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Hủy đơn đang chờ duyệt rồi tải lại danh sách.
  /// Trả thông báo lỗi nếu thất bại, null nếu thành công.
  Future<String?> cancel(LeaveRequest request) async {
    if (!request.canCancel) return 'Chỉ hủy được đơn đang chờ duyệt';
    try {
      await ref.read(leaveRequestRepositoryProvider).cancel(request.id);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

/// Bộ lọc đang chọn ở màn Lịch sử (trạng thái, loại phép).
@riverpod
class LeaveHistoryFilter extends _$LeaveHistoryFilter {
  @override
  LeaveFilter build() => const LeaveFilter();

  /// Đổi trạng thái lọc (null = tất cả).
  void setStatus(LeaveStatus? status) =>
      state = LeaveFilter(status: status, leaveTypeId: state.leaveTypeId);

  /// Đổi loại phép lọc (null = tất cả).
  void setLeaveType(String? typeId) =>
      state = LeaveFilter(status: state.status, leaveTypeId: typeId);

  /// Bỏ mọi bộ lọc.
  void clear() => state = const LeaveFilter();
}
