import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/core/services/attendance_reminder_service.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';
import 'package:timekeeper/viewmodels/leave/attendance_reminder_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/settings_viewmodel.dart';

class _User extends Fake implements User {}

/// Service giả: ghi lại các lần đặt lịch, không gọi plugin thật.
class _FakeService implements AttendanceReminderService {
  final calls = <(String?, String?)>[];

  @override
  Future<void> apply({String? checkin, String? checkout}) async {
    calls.add((checkin, checkout));
  }
}

void main() {
  group('nextOccurrence', () {
    final now = DateTime(2026, 11, 9, 8, 0);

    test('chưa tới giờ thì nhắc hôm nay', () {
      expect(
        AttendanceReminderService.nextOccurrence(now, 17, 30),
        DateTime(2026, 11, 9, 17, 30),
      );
    });

    test('đã qua giờ thì nhắc ngày mai', () {
      expect(
        AttendanceReminderService.nextOccurrence(now, 7, 45),
        DateTime(2026, 11, 10, 7, 45),
      );
    });

    test('đúng giờ hiện tại thì nhắc ngày mai', () {
      expect(
        AttendanceReminderService.nextOccurrence(now, 8, 0),
        DateTime(2026, 11, 10, 8, 0),
      );
    });

    test('qua cuối tháng', () {
      expect(
        AttendanceReminderService.nextOccurrence(DateTime(2026, 11, 30, 20), 7, 45),
        DateTime(2026, 12, 1, 7, 45),
      );
    });
  });

  group('attendanceReminderSync', () {
    late _FakeService service;

    Future<ProviderContainer> container(User? user) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = _FakeService();
      final c = ProviderContainer(overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        attendanceReminderServiceProvider.overrideWithValue(service),
        authStateProvider.overrideWith((ref) => Stream.value(user)),
      ]);
      addTearDown(c.dispose);
      c.listen(attendanceReminderSyncProvider, (_, _) {});
      await c.read(attendanceReminderSyncProvider.future);
      return c;
    }

    test('đổi giờ trong Settings thì đặt lại lịch nhắc', () async {
      final c = await container(_User());
      expect(service.calls.last, (null, null));

      await c.read(settingsViewModelProvider.notifier).setReminderCheckin('07:45');
      await c.read(attendanceReminderSyncProvider.future);
      expect(service.calls.last, ('07:45', null));

      await c.read(settingsViewModelProvider.notifier).setReminderCheckout('17:00');
      await c.read(attendanceReminderSyncProvider.future);
      expect(service.calls.last, ('07:45', '17:00'));

      await c.read(settingsViewModelProvider.notifier).setReminderCheckin(null);
      await c.read(attendanceReminderSyncProvider.future);
      expect(service.calls.last, (null, '17:00'));
    });

    test('chưa đăng nhập thì tắt nhắc dù đã lưu giờ', () async {
      final c = await container(null);
      await c.read(settingsViewModelProvider.notifier).setReminderCheckin('07:45');
      await c.read(attendanceReminderSyncProvider.future);
      expect(service.calls.last, (null, null));
    });

    test('đổi ngôn ngữ không đặt lại lịch nhắc', () async {
      final c = await container(_User());
      final before = service.calls.length;
      await c.read(settingsViewModelProvider.notifier).setLocale('en');
      await c.read(attendanceReminderSyncProvider.future);
      expect(service.calls.length, before);
    });
  });
}
