import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/leave/leave_form_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

import 'leave_fakes.dart';

/// Thứ Hai đầu tiên của tháng 3 năm nay (ngày làm việc chắc chắn).
DateTime _firstMondayOfMarch() {
  var d = DateTime(testYear, 3, 1);
  while (d.weekday != DateTime.monday) {
    d = d.add(const Duration(days: 1));
  }
  return d;
}

void main() {
  late FakeLeaveRequestRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeLeaveRequestRepository();
    container = ProviderContainer(overrides: [
      leaveRequestRepositoryProvider.overrideWithValue(repo),
      profileViewModelProvider.overrideWith(FakeProfileViewModel.new),
    ]);
    // Giữ form provider sống trong suốt test (autoDispose).
    container.listen(leaveFormViewModelProvider, (_, _) {});
    container.listen(leaveSubmitViewModelProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('gửi đơn hợp lệ: tính đúng số ngày và gọi repository', () async {
    final mon = _firstMondayOfMarch();
    final ok = await container.read(leaveSubmitViewModelProvider.notifier).submit(
          type: annual,
          start: mon,
          end: mon.add(const Duration(days: 6)), // T2 -> CN = 5 ngày làm việc
          halfDay: HalfDay.none,
          reason: 'Đi du lịch cùng gia đình',
        );
    expect(ok, isTrue);
    expect(repo.submitted, hasLength(1));
    expect(repo.submitted.single.totalDays, 5);
    expect(repo.submitted.single.employeeId, testProfile.id);
  });

  test('xin đúng bằng số dư thì được, vượt 1 ngày thì báo lỗi', () async {
    final mon = _firstMondayOfMarch();
    // Còn 10 ngày phép năm. T2 tuần 1 -> CN tuần 2 = 10 ngày làm việc.
    final ok = await container.read(leaveSubmitViewModelProvider.notifier).submit(
          type: annual,
          start: mon,
          end: mon.add(const Duration(days: 13)),
          halfDay: HalfDay.none,
          reason: 'Nghỉ dài ngày',
        );
    expect(ok, isTrue);

    final ok2 = await container.read(leaveSubmitViewModelProvider.notifier).submit(
          type: annual,
          start: mon,
          end: mon.add(const Duration(days: 14)), // 11 ngày
          halfDay: HalfDay.none,
          reason: 'Nghỉ dài ngày',
        );
    expect(ok2, isFalse);
    expect(
      container.read(leaveSubmitViewModelProvider).error.toString(),
      contains('Vượt số dư'),
    );
  });

  test('phép ốm bắt buộc file đính kèm', () async {
    final mon = _firstMondayOfMarch();
    final ok = await container.read(leaveSubmitViewModelProvider.notifier).submit(
          type: sick,
          start: mon,
          end: mon,
          halfDay: HalfDay.morning,
          reason: 'Đi khám bệnh',
        );
    expect(ok, isFalse);
    expect(repo.submitted, isEmpty);
  });
}
