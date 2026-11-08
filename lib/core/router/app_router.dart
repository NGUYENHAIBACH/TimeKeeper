import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/views/attendance/attendance_calendar_screen.dart';
import 'package:timekeeper/views/attendance/check_in_screen.dart';
import 'package:timekeeper/views/attendance/correction_form_screen.dart';
import 'package:timekeeper/views/attendance/day_detail_screen.dart';
import 'package:timekeeper/views/auth/forgot_password_screen.dart';
import 'package:timekeeper/views/auth/login_screen.dart';
import 'package:timekeeper/views/auth/register_screen.dart';
import 'package:timekeeper/views/auth/splash_screen.dart';
import 'package:timekeeper/views/home/home_screen.dart';
import 'package:timekeeper/views/leave/leave_form_screen.dart';
import 'package:timekeeper/views/leave/leave_history_screen.dart';
import 'package:timekeeper/views/leave/leave_team_calendar_screen.dart';
import 'package:timekeeper/views/settings/profile_screen.dart';
import 'package:timekeeper/views/settings/settings_screen.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';
import 'package:timekeeper/core/widgets/placeholder_screen.dart';
import 'package:timekeeper/views/overtime/ot_form_screen.dart';
import 'package:timekeeper/views/overtime/ot_list_screen.dart';
import 'package:timekeeper/views/overtime/ot_report_screen.dart';
import 'package:timekeeper/features/approval/approval_screens.dart';

import 'app_routes.dart';

part 'app_router.g.dart';

/// Đọc `?date=yyyy-MM-dd` (TV2). Sai định dạng hoặc thiếu thì lấy hôm nay.
DateTime _dateParam(GoRouterState state) {
  final parsed = DateTime.tryParse(state.uri.queryParameters['date'] ?? '');
  final d = parsed ?? DateTime.now();
  return DateTime(d.year, d.month, d.day);
}

/// GoRouter của toàn app. keepAlive vì chỉ tạo một lần.
///
/// Redirect dựa trên `authState`:
/// - Firebase chưa khôi phục xong phiên  -> ở Splash
/// - Chưa đăng nhập mà vào route private  -> Login
/// - Đã đăng nhập mà vào Login/Register   -> Home
///
/// Chỉ có MỘT GoRouter suốt vòng đời app. Khi `authState` đổi ta không tạo
/// router mới (sẽ mất ngăn xếp màn hình) mà báo router chạy lại `redirect`
/// thông qua `refreshListenable`.
///
/// Mỗi thành viên thay `PlaceholderScreen` của route mình bằng screen thật.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    refreshListenable: refresh,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final location = state.matchedLocation;
      final isPublic = AppRoutes.publicRoutes.contains(location);

      // Chưa biết trạng thái đăng nhập -> giữ ở Splash.
      if (auth.isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final loggedIn = auth.value != null;
      if (!loggedIn) {
        return isPublic && location != AppRoutes.splash
            ? null
            : AppRoutes.login;
      }
      // Đã đăng nhập: không cho quay lại các màn auth.
      return isPublic ? AppRoutes.home : null;
    },
    routes: [
      // ----- TV1 -----
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),

      // ----- TV2: Chấm công -----
      GoRoute(
        path: AppRoutes.checkin,
        builder: (_, _) => const CheckInScreen(),
      ),
      GoRoute(
        path: AppRoutes.attendanceCalendar,
        builder: (_, _) => const AttendanceCalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.attendanceDay,
        builder: (_, state) => DayDetailScreen(day: _dateParam(state)),
      ),
      GoRoute(
        path: AppRoutes.attendanceCorrection,
        builder: (_, state) => CorrectionFormScreen(day: _dateParam(state)),
      ),

      // ----- TV3: OT + Báo cáo -----
      GoRoute(
        path: AppRoutes.otList,
        builder: (_, _) => const OtListScreen(),
      ),
      GoRoute(
        path: AppRoutes.otForm,
        builder: (_, _) => const OtFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.otReport,
        builder: (_, _) => const OtReportScreen(),
      ),

      // ----- TV4: Nghỉ phép -----
      GoRoute(
        path: AppRoutes.leaveHistory,
        builder: (_, _) => const LeaveHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.leaveForm,
        builder: (_, _) => const LeaveFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.leaveTeamCalendar,
        builder: (_, _) => const LeaveTeamCalendarScreen(),
      ),

      // ----- TV5: Duyệt đơn & Thông báo -----
      GoRoute(
        path: AppRoutes.approvalInbox,
        builder: (_, _) => const ApprovalInboxScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.teamDashboard,
        builder: (_, _) => const TeamDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy')),
      body: Center(child: Text('Không có route: ${state.uri}')),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
}
