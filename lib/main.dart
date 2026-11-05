import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/env.dart';
import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';
import 'firebase_options.dart';

/// Điểm vào app: khởi tạo Firebase, Supabase, SharedPreferences rồi chạy
/// [MyApp] trong ProviderScope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase: cho phép chạy tiếp nếu chưa `flutterfire configure`
  // để các thành viên khác vẫn dựng UI được. Khi có Firebase thật thì
  // khối try/catch này không còn tác dụng.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

    return MaterialApp.router(
      title: 'TimeKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: Locale(settings.locale),
      routerConfig: router,
    );
  }
}
