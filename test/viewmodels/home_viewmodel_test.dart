// Unit test HomeViewModel với repository giả (cùng interface với bản thật).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/models/today_attendance.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/repositories/leave_repository.dart';
import 'package:timekeeper/repositories/mock/mock_repositories.dart';
import 'package:timekeeper/viewmodels/home/home_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

import '../helpers/fakes.dart';

ProviderContainer _container({
  Profile? profile = testProfile,
  AttendanceRepository? attendance,
  LeaveRepository? leave,
}) {
  final container = ProviderContainer(
    // Tắt tự động retry của Riverpod 3 để nhánh lỗi kết thúc ngay trong test.
    retry: (_, _) => null,
    overrides: [
      profileViewModelProvider.overrideWith(() => FakeProfileViewModel(profile)),
      attendanceRepositoryProvider
          .overrideWithValue(attendance ?? MockAttendanceRepository()),
      leaveRepositoryProvider.overrideWithValue(leave ?? MockLeaveRepository()),
    ],
  );
  addTearDown(container.dispose);
  // Giữ provider autoDispose sống trong suốt test.
  container.listen(homeViewModelProvider, (_, _) {});
  return container;
}

void main() {
  test('gom đủ hồ sơ, chấm công, tổng tháng và số phép', () async {
    final today = TodayAttendance(
      id: 'a1',
      workDate: DateTime(2026, 11, 5),
      checkInAt: DateTime(2026, 11, 5, 8, 2),
      lateMinutes: 2,
    );
    final c = _container(
      attendance: MockAttendanceRepository(
        today: today,
        summary: const MonthlySummary(totalHours: 40, workDays: 5, lateDays: 1),
      ),
      leave: MockLeaveRepository(
        balance: const LeaveBalanceSummary(totalDays: 12, usedDays: 2),
      ),
    );

    final dashboard = await c.read(homeViewModelProvider.future);

    expect(dashboard, isNotNull);
    expect(dashboard!.profile.email, testProfile.email);
    expect(dashboard.today, today);
    expect(dashboard.today!.isWorking, isTrue);
    expect(dashboard.summary.totalHours, 40);
    expect(dashboard.summary.workDays, 5);
    expect(dashboard.leave.remainingDays, 10);
  });

  test('chưa chấm công hôm nay -> today = null', () async {
    final c = _container();
    final dashboard = await c.read(homeViewModelProvider.future);
    expect(dashboard!.today, isNull);
  });

  test('chưa đăng nhập -> null, không gọi repository', () async {
    final c = _container(
      profile: null,
      attendance: MockAttendanceRepository(error: StateError('không được gọi')),
    );
    expect(await c.read(homeViewModelProvider.future), isNull);
  });

  test('repository lỗi -> state là AsyncError', () async {
    final c = _container(
      attendance: MockAttendanceRepository(error: Exception('Mất kết nối')),
    );
    await expectLater(
      c.read(homeViewModelProvider.future),
      throwsA(isA<Exception>()),
    );
    expect(c.read(homeViewModelProvider).hasError, isTrue);
  });

  test('refresh lấy dữ liệu mới từ repository', () async {
    var balance = const LeaveBalanceSummary(totalDays: 12, usedDays: 0);
    final c = _container(leave: _MutableLeaveRepository(() => balance));

    expect((await c.read(homeViewModelProvider.future))!.leave.remainingDays, 12);

    balance = const LeaveBalanceSummary(totalDays: 12, usedDays: 1.5);
    await c.read(homeViewModelProvider.notifier).refresh();

    expect(c.read(homeViewModelProvider).value!.leave.remainingDays, 10.5);
  });
}

/// Repository phép trả về giá trị thay đổi được, để test refresh.
class _MutableLeaveRepository implements LeaveRepository {
  _MutableLeaveRepository(this._get);
  final LeaveBalanceSummary Function() _get;

  @override
  Future<LeaveBalanceSummary> getLeaveBalance(String employeeId, {int? year}) async =>
      _get();
}
