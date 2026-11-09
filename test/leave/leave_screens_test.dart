// Widget Test module Nghỉ phép (TV4). Repository và hồ sơ được thay bằng
// bản giả qua `overrides`, nên test không cần Firebase / Supabase.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';
import 'package:timekeeper/views/leave/leave_form_screen.dart';
import 'package:timekeeper/views/leave/leave_history_screen.dart';
import 'package:timekeeper/views/leave/leave_team_calendar_screen.dart';

import 'leave_fakes.dart';

/// Dựng [child] trong ProviderScope với repository / hồ sơ giả, trên màn
/// hình cao 2000px để ListView dựng đủ các phần tử.
Future<void> _pump(WidgetTester tester, FakeLeaveRequestRepository repo, Widget child) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      leaveRequestRepositoryProvider.overrideWithValue(repo),
      profileViewModelProvider.overrideWith(FakeProfileViewModel.new),
    ],
    child: MaterialApp(home: child),
  ));
  await tester.pumpAndSettle();
}

/// Thứ Hai đầu tiên sau ngày 7 của tháng hiện tại (luôn là ngày làm việc
/// trong tháng đang hiển thị trên calendar).
DateTime _aMondayThisMonth() {
  final now = DateTime.now();
  var d = DateTime(now.year, now.month, 8);
  while (d.weekday != DateTime.monday) {
    d = d.add(const Duration(days: 1));
  }
  return d;
}

void main() {
  group('LeaveHistoryScreen', () {
    testWidgets('hiển thị số dư theo loại phép và danh sách đơn', (tester) async {
      final repo = FakeLeaveRequestRepository(requests: [
        request('r1', start: DateTime(testYear, 3, 2), days: 1, reason: 'Về quê'),
        request('r2', start: DateTime(testYear, 2, 2), status: LeaveStatus.approved),
      ]);
      await _pump(tester, repo, const LeaveHistoryScreen());

      expect(find.text('Số dư phép năm $testYear'), findsOneWidget);
      expect(find.text('Còn 10/12'), findsOneWidget); // phép năm: 12 - 2
      expect(find.text('Còn 30/30'), findsOneWidget); // nghỉ ốm
      expect(find.text('Phép năm còn lại'), findsOneWidget);
      expect(find.text('10 ngày'), findsOneWidget); // chỉ tính phép năm, không cộng nghỉ ốm
      expect(find.text('1 ngày'), findsOneWidget); // đang chờ duyệt
      expect(find.text('Về quê'), findsOneWidget);
    });

    testWidgets('lọc theo trạng thái', (tester) async {
      final repo = FakeLeaveRequestRepository(requests: [
        request('r1', start: DateTime(testYear, 3, 2), reason: 'Đơn chờ duyệt'),
        request('r2', start: DateTime(testYear, 2, 2), status: LeaveStatus.rejected, reason: 'Đơn bị từ chối'),
      ]);
      await _pump(tester, repo, const LeaveHistoryScreen());
      expect(find.text('Đơn chờ duyệt'), findsOneWidget);
      expect(find.text('Đơn bị từ chối'), findsOneWidget);

      await tester.tap(find.byKey(const Key('leave_filter_rejected')));
      await tester.pumpAndSettle();
      expect(find.text('Đơn chờ duyệt'), findsNothing);
      expect(find.text('Đơn bị từ chối'), findsOneWidget);
    });

    testWidgets('hủy đơn đang chờ duyệt sau khi xác nhận', (tester) async {
      final repo = FakeLeaveRequestRepository(requests: [
        request('r1', start: DateTime(testYear, 3, 2)),
      ]);
      await _pump(tester, repo, const LeaveHistoryScreen());

      await tester.tap(find.byKey(const Key('leave_cancel_r1')));
      await tester.pumpAndSettle();
      expect(find.text('Hủy đơn nghỉ?'), findsOneWidget);

      await tester.tap(find.text('Hủy đơn'));
      await tester.pumpAndSettle();
      expect(repo.cancelled, ['r1']);
      expect(find.text('Đã hủy đơn'), findsOneWidget);
      expect(find.byKey(const Key('leave_cancel_r1')), findsNothing);
    });

    testWidgets('lỗi tải dữ liệu thì hiện ErrorView có nút Thử lại', (tester) async {
      final repo = FakeLeaveRequestRepository(error: Exception('Mất kết nối'));
      await _pump(tester, repo, const LeaveHistoryScreen());
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Mất kết nối'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });
  });

  group('LeaveFormScreen', () {
    testWidgets('dropdown hiện số dư còn lại đã trừ đơn chờ duyệt', (tester) async {
      final repo = FakeLeaveRequestRepository(requests: [
        request('r1', start: DateTime(testYear, 3, 2), days: 1),
      ]);
      await _pump(tester, repo, const LeaveFormScreen());

      await tester.tap(find.byKey(const Key('leave_type_dropdown')));
      await tester.pumpAndSettle();
      // 12 - 2 đã dùng - 1 đang chờ = 9.
      expect(find.text('Nghỉ phép năm (còn 9 ngày)'), findsWidgets);
      expect(find.text('Nghỉ ốm (còn 30 ngày)'), findsWidgets);
      expect(find.text('Nghỉ không lương'), findsWidgets);
    });

    testWidgets('bấm Gửi khi chưa nhập thì báo lỗi validation', (tester) async {
      final repo = FakeLeaveRequestRepository();
      await _pump(tester, repo, const LeaveFormScreen());

      await tester.ensureVisible(find.byKey(const Key('leave_submit')));
      await tester.tap(find.byKey(const Key('leave_submit')));
      await tester.pumpAndSettle();
      expect(find.text('Chọn loại phép'), findsOneWidget);
      expect(find.text('Lý do tối thiểu 5 ký tự'), findsOneWidget);
      expect(repo.submitted, isEmpty);
    });

    testWidgets('chọn loại bắt buộc giấy tờ thì hiện ghi chú', (tester) async {
      await _pump(tester, FakeLeaveRequestRepository(), const LeaveFormScreen());
      await tester.tap(find.byKey(const Key('leave_type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nghỉ ốm (còn 30 ngày)').last);
      await tester.pumpAndSettle();
      expect(find.text('* Loại phép này bắt buộc đính kèm giấy tờ'), findsOneWidget);
    });

    testWidgets('chọn phép không lương thì số dư hiện Không giới hạn', (tester) async {
      await _pump(tester, FakeLeaveRequestRepository(), const LeaveFormScreen());
      await tester.tap(find.byKey(const Key('leave_type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nghỉ không lương').last);
      await tester.pumpAndSettle();
      expect(find.text('Không giới hạn'), findsOneWidget);
    });

    testWidgets('chưa chọn loại phép thì số dư hiện dấu gạch', (tester) async {
      await _pump(tester, FakeLeaveRequestRepository(), const LeaveFormScreen());
      expect(find.text('Không giới hạn'), findsNothing);
      expect(find.text('-'), findsNWidgets(2)); // số ngày nghỉ và số dư
    });

    testWidgets('nút nửa ngày bị khóa khi chưa chọn 1 ngày', (tester) async {
      await _pump(tester, FakeLeaveRequestRepository(), const LeaveFormScreen());
      expect(find.text('Nghỉ nửa ngày chỉ chọn được khi nghỉ 1 ngày'), findsOneWidget);
    });
  });

  group('LeaveTeamCalendarScreen', () {
    testWidgets('chọn ngày thì hiện đồng nghiệp nghỉ ngày đó', (tester) async {
      final monday = _aMondayThisMonth();
      final repo = FakeLeaveRequestRepository(teamLeaves: [
        request('t1',
            start: monday,
            end: monday.add(const Duration(days: 1)),
            days: 2,
            status: LeaveStatus.approved,
            employeeId: 'emp-2',
            employeeName: 'Trần Thị B'),
        request('t2',
            start: monday,
            halfDay: HalfDay.morning,
            days: 0.5,
            employeeId: 'emp-1',
            employeeName: 'Nguyễn Văn A'),
      ]);
      await _pump(tester, repo, const LeaveTeamCalendarScreen());

      expect(find.text('Tháng ${monday.month}/${monday.year}'), findsOneWidget);
      await tester.tap(find.text('${monday.day}').first);
      await tester.pumpAndSettle();

      expect(find.text('Trần Thị B'), findsOneWidget);
      expect(find.text('Nguyễn Văn A (bạn)'), findsOneWidget);
      expect(find.textContaining('2 người có lịch nghỉ'), findsOneWidget);
    });
  });
}
