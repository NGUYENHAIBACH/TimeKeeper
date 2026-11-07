// Unit test SettingsViewModel: đọc/ghi SharedPreferences đúng key, đổi theme,
// giờ nhắc và quy tắc bật vân tay.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/app_settings.dart';
import 'package:timekeeper/core/services/biometric_service.dart';
import 'package:timekeeper/viewmodels/settings/settings_viewmodel.dart';

/// Vân tay giả (thay BiometricService của TV2): điều khiển được kết quả.
class _FakeBiometric implements BiometricService {
  _FakeBiometric({this.available = true, this.authOk = true});
  final bool available;
  final bool authOk;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<BiometricResult> authenticate(String reason) async {
    if (!available) return BiometricResult.notAvailable;
    return authOk ? BiometricResult.success : BiometricResult.failed;
  }
}

Future<(ProviderContainer, SharedPreferences)> _setup({
  Map<String, Object> initial = const {},
  BiometricService? biometric,
}) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      biometricServiceProvider.overrideWithValue(biometric ?? _FakeBiometric()),
    ],
  );
  addTearDown(container.dispose);
  return (container, prefs);
}

void main() {
  test('giá trị mặc định khi chưa lưu gì', () async {
    final (c, _) = await _setup();
    final s = c.read(settingsViewModelProvider);
    expect(s.themeMode, ThemeMode.system);
    expect(s.locale, 'vi');
    expect(s.reminderCheckinTime, isNull);
    expect(s.reminderCheckoutTime, isNull);
    expect(s.biometricEnabled, isFalse);
  });

  test('đọc lại đúng giá trị đã lưu (mô phỏng mở lại app)', () async {
    final (c, _) = await _setup(initial: {
      AppSettingsKeys.themeMode: ThemeMode.dark.index,
      AppSettingsKeys.locale: 'en',
      AppSettingsKeys.reminderCheckinTime: '07:45',
      AppSettingsKeys.biometricEnabled: true,
    });
    final s = c.read(settingsViewModelProvider);
    expect(s.themeMode, ThemeMode.dark);
    expect(s.locale, 'en');
    expect(s.reminderCheckinTime, '07:45');
    expect(s.biometricEnabled, isTrue);
  });

  test('setThemeMode cập nhật state và lưu theme_mode', () async {
    final (c, prefs) = await _setup();
    await c.read(settingsViewModelProvider.notifier).setThemeMode(ThemeMode.dark);
    expect(c.read(settingsViewModelProvider).themeMode, ThemeMode.dark);
    expect(prefs.getInt(AppSettingsKeys.themeMode), ThemeMode.dark.index);
  });

  test('setLocale lưu locale', () async {
    final (c, prefs) = await _setup();
    await c.read(settingsViewModelProvider.notifier).setLocale('en');
    expect(c.read(settingsViewModelProvider).locale, 'en');
    expect(prefs.getString(AppSettingsKeys.locale), 'en');
  });

  test('giờ nhắc: đặt thì lưu HH:mm, tắt thì xóa key', () async {
    final (c, prefs) = await _setup();
    final vm = c.read(settingsViewModelProvider.notifier);

    await vm.setReminderCheckin('07:45');
    await vm.setReminderCheckout('17:00');
    expect(prefs.getString(AppSettingsKeys.reminderCheckinTime), '07:45');
    expect(c.read(settingsViewModelProvider).reminderCheckoutTime, '17:00');

    await vm.setReminderCheckin(null);
    expect(prefs.containsKey(AppSettingsKeys.reminderCheckinTime), isFalse);
    expect(c.read(settingsViewModelProvider).reminderCheckinTime, isNull);
  });

  group('vân tay', () {
    test('bật thành công khi thiết bị hỗ trợ và xác thực đúng', () async {
      final (c, prefs) = await _setup();
      final ok =
          await c.read(settingsViewModelProvider.notifier).setBiometricEnabled(true);
      expect(ok, isTrue);
      expect(prefs.getBool(AppSettingsKeys.biometricEnabled), isTrue);
    });

    test('không bật khi thiết bị không có vân tay', () async {
      final (c, prefs) = await _setup(biometric: _FakeBiometric(available: false));
      final ok =
          await c.read(settingsViewModelProvider.notifier).setBiometricEnabled(true);
      expect(ok, isFalse);
      expect(c.read(settingsViewModelProvider).biometricEnabled, isFalse);
      expect(prefs.containsKey(AppSettingsKeys.biometricEnabled), isFalse);
    });

    test('không bật khi xác thực thất bại', () async {
      final (c, _) = await _setup(biometric: _FakeBiometric(authOk: false));
      final ok =
          await c.read(settingsViewModelProvider.notifier).setBiometricEnabled(true);
      expect(ok, isFalse);
      expect(c.read(settingsViewModelProvider).biometricEnabled, isFalse);
    });

    test('tắt không cần xác thực', () async {
      final (c, prefs) = await _setup(
        initial: {AppSettingsKeys.biometricEnabled: true},
        biometric: _FakeBiometric(available: false),
      );
      final ok =
          await c.read(settingsViewModelProvider.notifier).setBiometricEnabled(false);
      expect(ok, isTrue);
      expect(prefs.getBool(AppSettingsKeys.biometricEnabled), isFalse);
    });
  });
}
