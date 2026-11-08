import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/services/attendance_reminder_service.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';
import 'package:timekeeper/viewmodels/settings/settings_viewmodel.dart';

part 'attendance_reminder_viewmodel.g.dart';

/// Giữ lịch nhắc khớp với giờ trong Settings: tự đặt lại khi người dùng đổi
/// giờ, bật/tắt nhắc, đăng nhập hoặc đăng xuất. Đăng xuất thì tắt hết nhắc.
/// `MyApp` watch provider này để nó chạy suốt vòng đời app.
@Riverpod(keepAlive: true)
Future<void> attendanceReminderSync(Ref ref) async {
  final checkin = ref.watch(
    settingsViewModelProvider.select((s) => s.reminderCheckinTime),
  );
  final checkout = ref.watch(
    settingsViewModelProvider.select((s) => s.reminderCheckoutTime),
  );
  final user = await ref.watch(authStateProvider.future);

  final service = ref.read(attendanceReminderServiceProvider);
  if (user == null) {
    await service.apply();
  } else {
    await service.apply(checkin: checkin, checkout: checkout);
  }
}
