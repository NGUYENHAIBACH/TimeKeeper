import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Cấu hình người dùng, lưu trong SharedPreferences.
/// Key SharedPreferences tương ứng nằm trong [AppSettingsKeys].
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// Chế độ sáng / tối / theo hệ thống.
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// Mã ngôn ngữ: 'vi' hoặc 'en'.
    @Default('vi') String locale,

    /// Giờ nhắc check-in, dạng 'HH:mm'. Null = tắt nhắc.
    String? reminderCheckinTime,

    /// Giờ nhắc check-out, dạng 'HH:mm'. Null = tắt nhắc.
    String? reminderCheckoutTime,

    /// Bật xác thực vân tay khi chấm công.
    @Default(false) bool biometricEnabled,
  }) = _AppSettings;
}

/// Tên key trong SharedPreferences. Các module khác đọc cấu hình qua
/// `settingsViewModelProvider`, không đọc SharedPreferences trực tiếp.
class AppSettingsKeys {
  AppSettingsKeys._();

  static const themeMode = 'theme_mode';
  static const locale = 'locale';
  static const reminderCheckinTime = 'reminder_checkin_time';
  static const reminderCheckoutTime = 'reminder_checkout_time';
  static const biometricEnabled = 'biometric_enabled';
}
