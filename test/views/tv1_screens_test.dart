// Widget test các màn của TV1: Login (validation), Home (đủ 3 trạng thái),
// Settings (đổi theme lưu SharedPreferences).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/app_settings.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/repositories/leave_repository.dart';
import 'package:timekeeper/repositories/mock/mock_repositories.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';
import 'package:timekeeper/views/auth/login_screen.dart';
import 'package:timekeeper/views/home/home_screen.dart';
import 'package:timekeeper/views/settings/settings_screen.dart';

import '../helpers/fakes.dart';

void main() {
  group('LoginScreen', () {
    Future<void> pumpLogin(WidgetTester tester) => tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    testWidgets('bỏ trống rồi bấm Đăng nhập -> hiện lỗi bắt buộc', (
      tester,
    ) async {
      await pumpLogin(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
      await tester.pump();

      expect(find.text('Vui lòng nhập email'), findsOneWidget);
      expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
    });

    testWidgets('email sai định dạng, mật khẩu đăng nhập ngắn vẫn hợp lệ', (
      tester,
    ) async {
      await pumpLogin(tester);
      await tester.enterText(find.byType(TextFormField).at(0), 'abc');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
      await tester.pump();

      expect(find.text('Email không đúng định dạng'), findsOneWidget);
      expect(find.text('Mật khẩu phải có ít nhất 8 ký tự'), findsNothing);
    });
  });

  group('HomeScreen', () {
    Widget app({AttendanceRepository? attendance, LeaveRepository? leave}) {
      return ProviderScope(
        retry: (_, _) => null,
        overrides: [
          profileViewModelProvider.overrideWith(
            () => FakeProfileViewModel(testProfile),
          ),
          attendanceRepositoryProvider.overrideWith(
            (ref) async =>
                attendance ??
                MockAttendanceRepository(monthRecords: sampleMonthRecords),
          ),
          leaveRepositoryProvider.overrideWithValue(
            leave ?? MockLeaveRepository(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      );
    }

    testWidgets('loading rồi hiện dữ liệu', (tester) async {
      await tester.pumpWidget(app());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Xin chào, Nguyen Van A'), findsOneWidget);
      expect(find.text('Chưa chấm công'), findsOneWidget);
      expect(find.text('Check-in ngay'), findsOneWidget);
      expect(find.text('15.5 h'), findsOneWidget);
      expect(find.text('8.5 ngày'), findsOneWidget);
      // Nhân viên thường không thấy lối tắt Duyệt đơn.
      expect(find.text('Duyệt đơn'), findsNothing);
    });

    testWidgets('lỗi -> hiện thông báo và nút Thử lại', (tester) async {
      await tester.pumpWidget(
        app(
          attendance: MockAttendanceRepository(error: Exception('Mất kết nối')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mất kết nối'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('chọn theme Tối -> lưu theme_mode vào SharedPreferences', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('Tối'));
      await tester.pumpAndSettle();

      expect(prefs.getInt(AppSettingsKeys.themeMode), ThemeMode.dark.index);
    });

    testWidgets('bật nhắc check-in -> lưu giờ mặc định 07:45', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('Đang tắt'), findsNWidgets(2));
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(prefs.getString(AppSettingsKeys.reminderCheckinTime), '07:45');
      expect(find.text('Hằng ngày lúc 07:45'), findsOneWidget);
    });
  });
}
