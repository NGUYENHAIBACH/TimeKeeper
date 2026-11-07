// Unit test HomeViewModel với repository giả (cùng interface với bản thật
// của TV2 và TV4).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/leave_balance_summary.dart';
import 'package:timekeeper/models/profile.dart';
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
      // Provider của TV2 là bất đồng bộ (mở SQLite) nên override bằng hàm async.
      attendanceRepositoryProvider
          .overrideWith((ref) async => attendance ?? MockAttendanceRepository()),
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
    final today = attendanceOf(5, checkIn: (8, 2), late: 2);
    final c = _container(
      attendance: MockAttendanceRepository(
        today: today,
        monthRecords: [...sampleMonthRecords, today],
      ),
      leave: MockLeaveRepository(
        balance: const LeaveBalanceSummary(totalDays: 12, usedDays: 2),
      ),
    );

    final dashboard = await c.read(homeViewModelProvider.future);

    expect(dashboard, isNotNull);
    expect(dashboard!.profile.email, testProfile.email);
    expect(dashboard.today, today);
    expect(dashboard.today!.hasCheckedIn, isTrue);
    expect(dashboard.today!.hasCheckedOut, isFalse);
    // 8 + 7.5 + 0 (hôm nay chưa check-out) giờ; 3 ngày có check-in; 2 ngày trễ.
    expect(dashboard.summary.totalHours, 15.5);
    expect(dashboard.summary.workDays, 3);
    expect(dashboard.summary.lateDays, 2);
    expect(dashboard.leave.remainingDays, 10);
  });

  test('chưa chấm công hôm nay -> today = null, số liệu tháng bằng 0', () async {
    final c = _container();
    final dashboard = await c.read(homeViewModelProvider.future);
    expect(dashboard!.today, isNull);
    expect(dashboard.summary.totalHours, 0);
    expect(dashboard.summary.workDays, 0);
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
