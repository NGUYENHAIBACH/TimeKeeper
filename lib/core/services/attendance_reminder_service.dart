import 'dart:developer' as dev;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timekeeper/core/utils/date_utils.dart';

part 'attendance_reminder_service.g.dart';

/// Service đặt thông báo nhắc check-in / check-out hằng ngày.
@Riverpod(keepAlive: true)
AttendanceReminderService attendanceReminderService(Ref ref) =>
    AttendanceReminderService();

/// Bọc flutter_local_notifications: đặt lại lịch nhắc theo giờ trong Settings.
class AttendanceReminderService {
  AttendanceReminderService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  /// Id riêng của nhắc giờ. Chỉ hủy đúng 2 id này để không đụng thông báo
  /// duyệt đơn của TV5.
  static const checkinId = 9101;
  static const checkoutId = 9102;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'attendance_reminder',
      'Nhắc chấm công',
      channelDescription: 'Nhắc giờ check-in và check-out hằng ngày',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  /// Lần nhắc kế tiếp lúc [hour]:[minute]: hôm nay nếu chưa tới giờ,
  /// nếu đã qua thì ngày mai.
  static DateTime nextOccurrence(DateTime now, int hour, int minute) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    return today.isAfter(now)
        ? today
        : DateTime(now.year, now.month, now.day + 1, hour, minute);
  }

  /// Đặt lại lịch nhắc. [checkin] / [checkout] dạng 'HH:mm', null = tắt.
  Future<void> apply({String? checkin, String? checkout}) async {
    await _ensureInitialized();
    await _plugin.cancel(id: checkinId);
    await _plugin.cancel(id: checkoutId);

    final checkinTime = AppDateUtils.parseHourMinute(checkin);
    final checkoutTime = AppDateUtils.parseHourMinute(checkout);
    if (checkinTime == null && checkoutTime == null) return;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Android 13+ phải được người dùng cho phép mới hiện thông báo.
    final granted = await android?.requestNotificationsPermission();
    if (granted == false) {
      dev.log('Chưa được cấp quyền thông báo', name: 'AttendanceReminder');
    }
    final exact = await android?.canScheduleExactNotifications() ?? false;
    final mode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    if (checkinTime != null) {
      await _schedule(
        id: checkinId,
        time: checkinTime,
        mode: mode,
        title: 'Nhắc check-in',
        body: 'Đến giờ check-in rồi, mở TimeKeeper để chấm công.',
      );
    }
    if (checkoutTime != null) {
      await _schedule(
        id: checkoutId,
        time: checkoutTime,
        mode: mode,
        title: 'Nhắc check-out',
        body: 'Đến giờ check-out rồi, đừng quên chấm công trước khi về.',
      );
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _initialized = true;
  }

  /// Đổi giờ máy sang UTC để khỏi cần dữ liệu múi giờ. Giờ Việt Nam không đổi
  /// theo mùa nên lặp hằng ngày vẫn đúng; lịch được đặt lại mỗi lần mở app.
  Future<void> _schedule({
    required int id,
    required (int, int) time,
    required AndroidScheduleMode mode,
    required String title,
    required String body,
  }) {
    final next = nextOccurrence(DateTime.now(), time.$1, time.$2);
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(next, tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: mode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
