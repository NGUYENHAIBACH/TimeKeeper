import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/models/app_settings.dart';
import 'package:timekeeper/viewmodels/auth/auth_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/settings_viewmodel.dart';

/// Màn Cài đặt: giao diện, ngôn ngữ, giờ nhắc chấm công, vân tay, đăng xuất.
/// Mọi thay đổi lưu ngay vào SharedPreferences qua [SettingsViewModel] và
/// áp dụng tức thì (MyApp watch cùng provider).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final vm = ref.read(settingsViewModelProvider.notifier);

    // Báo lỗi nếu đăng xuất thất bại.
    ref.listen(authViewModelProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorView.friendlyMessage(next.error!))),
        );
      }
    });
    final signingOut = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Hồ sơ cá nhân'),
            subtitle: const Text('Họ tên, số điện thoại, ảnh đại diện'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.profile),
          ),
          const Divider(),
          const _SectionTitle('Giao diện'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text('Hệ thống'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Sáng'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Tối'),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => vm.setThemeMode(s.first),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Ngôn ngữ'),
            trailing: DropdownButton<String>(
              value: settings.locale,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (v) {
                if (v != null) vm.setLocale(v);
              },
            ),
          ),
          const Divider(),
          const _SectionTitle('Nhắc chấm công'),
          _ReminderTile(
            icon: Icons.login,
            title: 'Nhắc check-in',
            value: settings.reminderCheckinTime,
            defaultTime: const TimeOfDay(hour: 7, minute: 45),
            onChanged: vm.setReminderCheckin,
          ),
          _ReminderTile(
            icon: Icons.logout,
            title: 'Nhắc check-out',
            value: settings.reminderCheckoutTime,
            defaultTime: const TimeOfDay(hour: 17, minute: 0),
            onChanged: vm.setReminderCheckout,
          ),
          const Divider(),
          const _SectionTitle('Bảo mật'),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Chấm công bằng vân tay'),
            subtitle: const Text('Yêu cầu xác thực sinh trắc học khi check-in/out'),
            value: settings.biometricEnabled,
            onChanged: (enabled) async {
              final ok = await vm.setBiometricEnabled(enabled);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Không bật được: thiết bị chưa cài vân tay hoặc xác thực thất bại',
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(
              'Đăng xuất',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            enabled: !signingOut,
            onTap: () => _confirmSignOut(context, ref),
          ),
          const SizedBox(height: 24),
          const _SettingsSummary(),
        ],
      ),
    );
  }

  /// Hỏi lại trước khi đăng xuất. Router tự đưa về Login khi authState = null.
  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authViewModelProvider.notifier).signOut();
    }
  }
}

/// Tiêu đề nhóm cài đặt.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

/// Một dòng nhắc giờ: công tắc bật/tắt + bấm để chọn giờ.
class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.defaultTime,
    required this.onChanged,
  });

  final IconData icon;
  final String title;

  /// Giờ đang lưu dạng 'HH:mm', null = tắt.
  final String? value;

  /// Giờ gợi ý khi bật lần đầu.
  final TimeOfDay defaultTime;

  /// Gọi với 'HH:mm' khi đặt giờ, null khi tắt.
  final Future<void> Function(String?) onChanged;

  Future<void> _pick(BuildContext context) async {
    final parsed = AppDateUtils.parseHourMinute(value);
    final initial = parsed == null
        ? defaultTime
        : TimeOfDay(hour: parsed.$1, minute: parsed.$2);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      await onChanged(AppDateUtils.formatHourMinute(picked.hour, picked.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = value != null;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(enabled ? 'Hằng ngày lúc $value' : 'Đang tắt'),
      onTap: enabled ? () => _pick(context) : null,
      trailing: Switch(
        value: enabled,
        onChanged: (on) {
          if (on) {
            onChanged(
              AppDateUtils.formatHourMinute(defaultTime.hour, defaultTime.minute),
            );
          } else {
            onChanged(null);
          }
        },
      ),
    );
  }
}

/// Dòng ghi chú cuối màn: nơi lưu cấu hình.
class _SettingsSummary extends ConsumerWidget {
  const _SettingsSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSettings s = ref.watch(settingsViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'Cấu hình được lưu trên thiết bị (SharedPreferences) và giữ nguyên sau '
        'khi tắt app. Ngôn ngữ hiện tại: ${s.locale == 'vi' ? 'Tiếng Việt' : 'English'}.',
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
