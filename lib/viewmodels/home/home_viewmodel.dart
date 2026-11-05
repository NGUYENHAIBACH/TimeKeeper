import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/models/home_dashboard.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/today_attendance.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/repositories/leave_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'home_viewmodel.g.dart';

/// ViewModel màn Home Dashboard.
/// Gom hồ sơ (TV1) + chấm công hôm nay và tổng giờ tháng (TV2) + số phép
/// còn (TV4) thành một [HomeDashboard]. Trả null khi chưa đăng nhập.
///
/// autoDispose: rời Home là giải phóng, quay lại sẽ tải dữ liệu mới.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeDashboard?> build() async {
    final profile = await ref.watch(profileViewModelProvider.future);
    if (profile == null) return null;

    final attendance = ref.watch(attendanceRepositoryProvider);
    final leave = ref.watch(leaveRepositoryProvider);

    // Ba truy vấn độc lập nên chạy song song cho nhanh. Dùng Future.wait
    // (không dùng record.wait) để lỗi gốc được ném nguyên vẹn ra View.
    final results = await Future.wait<Object?>([
      attendance.getTodayAttendance(profile.id),
      attendance.getMonthlySummary(profile.id, DateTime.now()),
      leave.getLeaveBalance(profile.id),
    ]);

    return HomeDashboard(
      profile: profile,
      today: results[0] as TodayAttendance?,
      summary: results[1]! as MonthlySummary,
      leave: results[2]! as LeaveBalanceSummary,
    );
  }

  /// Kéo để tải lại (pull-to-refresh) hoặc bấm "Thử lại" khi lỗi.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
