import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'leave_team_calendar_viewmodel.g.dart';

/// Dữ liệu lịch nghỉ team của 1 tháng.
class TeamLeaveData {
  const TeamLeaveData({
    required this.month,
    required this.myEmployeeId,
    required this.leaves,
    required this.holidays,
  });

  /// Ngày đầu tháng đang xem.
  final DateTime month;
  final String myEmployeeId;
  final List<LeaveRequest> leaves;

  /// Ngày lễ trong tháng: ngày -> tên lễ.
  final Map<DateTime, String> holidays;

  /// Các đơn nghỉ phủ ngày [day] (bỏ cuối tuần / ngày lễ vì không phải đi làm).
  List<LeaveRequest> leavesOn(DateTime day) {
    final d = LeaveCalculator.dateOnly(day);
    if (!LeaveCalculator.isWorkingDay(d, holidays.keys.toSet())) return const [];
    return leaves.where((r) => r.covers(d)).toList();
  }

  /// Số người nghỉ (không tính trùng) trong tháng.
  int get peopleOnLeave => leaves.map((r) => r.employeeId).toSet().length;

  /// Ngày đông người nghỉ nhất trong tháng (null nếu không ai nghỉ).
  ({DateTime day, int count})? get busiestDay {
    ({DateTime day, int count})? best;
    final last = DateTime(month.year, month.month + 1, 0).day;
    for (var i = 1; i <= last; i++) {
      final d = DateTime(month.year, month.month, i);
      final c = leavesOn(d).map((r) => r.employeeId).toSet().length;
      if (c > 0 && (best == null || c > best.count)) best = (day: d, count: c);
    }
    return best;
  }
}

/// ViewModel màn Lịch nghỉ của team: xem đồng nghiệp cùng phòng ban
/// nghỉ ngày nào trong tháng.
@riverpod
class LeaveTeamCalendarViewModel extends _$LeaveTeamCalendarViewModel {
  DateTime _month = _firstOfMonth(DateTime.now());

  static DateTime _firstOfMonth(DateTime d) => DateTime(d.year, d.month);

  @override
  Future<TeamLeaveData> build() => _load(_month);

  Future<TeamLeaveData> _load(DateTime month) async {
    final profile = await ref.watch(profileViewModelProvider.future);
    if (profile == null) throw Exception('Chưa có hồ sơ nhân viên');
    final repo = ref.read(leaveRequestRepositoryProvider);
    final from = DateTime(month.year, month.month);
    final to = DateTime(month.year, month.month + 1, 0);
    final leaves = await repo.getTeamLeaves(
      from: from,
      to: to,
      departmentId: profile.departmentId,
    );
    final holidays = await repo.getHolidays(from, to);
    return TeamLeaveData(
      month: from,
      myEmployeeId: profile.id,
      leaves: leaves,
      holidays: {for (final h in holidays) LeaveCalculator.dateOnly(h.holidayDate): h.name},
    );
  }

  /// Chuyển sang tháng chứa ngày [month].
  Future<void> changeMonth(DateTime month) async {
    final m = _firstOfMonth(month);
    if (m == _month && state.hasValue) return;
    _month = m;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(m));
  }

  /// Tải lại tháng hiện tại.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(_month));
  }
}
