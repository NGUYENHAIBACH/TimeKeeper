import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/core_providers.dart';
import '../../../data/models/app_settings.dart';

part 'settings_viewmodel.g.dart';

/// ViewModel cấu hình app (theme, ngôn ngữ, giờ nhắc, vân tay).
/// keepAlive vì `MyApp` watch nó để đổi theme, và TV4 đọc giờ nhắc.
/// Đọc/ghi SharedPreferences đồng bộ nên state là [AppSettings] thường,
/// không cần AsyncValue.
@Riverpod(keepAlive: true)
class SettingsViewModel extends _$SettingsViewModel {
  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final themeIndex = prefs.getInt(AppSettingsKeys.themeMode);
    return AppSettings(
      themeMode: themeIndex == null
          ? ThemeMode.system
          : ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)],
      locale: prefs.getString(AppSettingsKeys.locale) ?? 'vi',
      reminderCheckinTime: prefs.getString(AppSettingsKeys.reminderCheckinTime),
      reminderCheckoutTime: prefs.getString(AppSettingsKeys.reminderCheckoutTime),
      biometricEnabled: prefs.getBool(AppSettingsKeys.biometricEnabled) ?? false,
    );
  }

  /// Đổi chế độ sáng/tối. Áp dụng ngay vì MyApp đang watch state này.
  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(sharedPrefsProvider).setInt(AppSettingsKeys.themeMode, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  /// Đổi ngôn ngữ ('vi' / 'en').
  Future<void> setLocale(String locale) async {
    await ref.read(sharedPrefsProvider).setString(AppSettingsKeys.locale, locale);
    state = state.copyWith(locale: locale);
  }

  /// Đặt giờ nhắc check-in ('HH:mm'), truyền null để tắt.
  Future<void> setReminderCheckin(String? time) async {
    await _setNullableString(AppSettingsKeys.reminderCheckinTime, time);
    state = state.copyWith(reminderCheckinTime: time);
  }

  /// Đặt giờ nhắc check-out ('HH:mm'), truyền null để tắt.
  Future<void> setReminderCheckout(String? time) async {
    await _setNullableString(AppSettingsKeys.reminderCheckoutTime, time);
    state = state.copyWith(reminderCheckoutTime: time);
  }

  /// Bật/tắt xác thực vân tay.
  Future<void> setBiometricEnabled(bool enabled) async {
    await ref.read(sharedPrefsProvider).setBool(AppSettingsKeys.biometricEnabled, enabled);
    state = state.copyWith(biometricEnabled: enabled);
  }

  Future<void> _setNullableString(String key, String? value) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
