import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/env.dart';
import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/leave/attendance_reminder_viewmodel.dart';
import 'viewmodels/approval/approval_inbox_viewmodel.dart';
import 'viewmodels/approval/approval_notification_sync.dart';
import 'viewmodels/approval/notification_center_viewmodel.dart';
import 'viewmodels/settings/settings_viewmodel.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// Điểm vào app: khởi tạo Firebase, Supabase, SharedPreferences rồi chạy
/// [MyApp] trong ProviderScope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase: cho phép chạy tiếp nếu chưa `flutterfire configure`
  // để các thành viên khác vẫn dựng UI được. Khi có Firebase thật thì
  // khối try/catch này không còn tác dụng.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  } on UnsupportedError catch (e) {
    dev.log('Firebase chưa cấu hình: ${e.message}', name: 'main');
  }

  await Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabasePublishableKey);

  final prefs = await SharedPreferences.getInstance();

  // Tên thứ/tháng tiếng Việt cho lịch (table_calendar, intl) - TV2.
  await initializeDateFormatting('vi_VN');

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

/// Widget gốc. Watch `settingsViewModelProvider` để đổi theme ngay lập tức,
/// và `routerProvider` để điều hướng.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final router = ref.watch(routerProvider);
    ref.listen(approvalNotificationOpenEventsProvider, (_, next) {
      next.whenData((data) {
        final table = data['ref_table']?.toString();
        final id = data['ref_id']?.toString();
        if (table == null || id == null) {
          router.go(AppRoutes.notifications);
          return;
        }
        router.go(
          AppRoutes.notificationDetail(
            table: table,
            id: id,
            notificationId: data['notification_id']?.toString(),
          ),
        );
      });
    });
    ref.listen(approvalNotificationRealtimeEventsProvider, (_, next) {
      next.whenData((_) {
        ref.invalidate(notificationCenterViewModelProvider);
        ref.invalidate(approvalInboxViewModelProvider);
      });
    });
    ref.watch(approvalNotificationSyncProvider);
    // Nhắc check-in/check-out theo giờ trong Settings (TV4).
    ref.watch(attendanceReminderSyncProvider);

    return MaterialApp.router(
      title: 'TimeKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      // Ngôn ngữ của widget hệ thống (date/time picker, dialog...).
      locale: Locale(settings.locale),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
