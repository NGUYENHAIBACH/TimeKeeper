import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/attendance/view/attendance_calendar_screen.dart';
import '../../features/attendance/view/check_in_screen.dart';
import '../../features/attendance/view/correction_form_screen.dart';
import '../../features/attendance/view/day_detail_screen.dart';
import '../../features/auth/view/splash_screen.dart';
import '../../features/auth/viewmodel/auth_state_provider.dart';
import '../widgets/placeholder_screen.dart';
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
/// Mỗi thành viên thay `PlaceholderScreen` của route mình bằng screen thật.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublic = AppRoutes.publicRoutes.contains(location);

      // Chưa biết trạng thái đăng nhập -> giữ ở Splash.
      if (auth.isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final loggedIn = auth.value != null;
      if (!loggedIn) {
        return isPublic && location != AppRoutes.splash ? null : AppRoutes.login;
      }
      // Đã đăng nhập: không cho quay lại các màn auth.
      return isPublic ? AppRoutes.home : null;
    },
    routes: [
      // ----- TV1 -----
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const PlaceholderScreen(title: 'Đăng nhập', owner: 'TV1'),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const PlaceholderScreen(title: 'Đăng ký', owner: 'TV1'),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const PlaceholderScreen(title: 'Quên mật khẩu', owner: 'TV1'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const PlaceholderScreen(title: 'Trang chủ', owner: 'TV1'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const PlaceholderScreen(title: 'Hồ sơ', owner: 'TV1'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const PlaceholderScreen(title: 'Cài đặt', owner: 'TV1'),
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
        builder: (_, _) => const PlaceholderScreen(title: 'Danh sách đơn OT', owner: 'TV3'),
      ),
      GoRoute(
        path: AppRoutes.otForm,
        builder: (_, _) => const PlaceholderScreen(title: 'Tạo đơn OT', owner: 'TV3'),
      ),
      GoRoute(
        path: AppRoutes.otReport,
        builder: (_, _) => const PlaceholderScreen(title: 'Thống kê OT', owner: 'TV3'),
      ),

      // ----- TV4: Nghỉ phép -----
      GoRoute(
        path: AppRoutes.leaveHistory,
        builder: (_, _) => const PlaceholderScreen(title: 'Lịch sử nghỉ phép', owner: 'TV4'),
      ),
      GoRoute(
        path: AppRoutes.leaveForm,
        builder: (_, _) => const PlaceholderScreen(title: 'Xin nghỉ phép', owner: 'TV4'),
      ),
      GoRoute(
        path: AppRoutes.leaveTeamCalendar,
        builder: (_, _) => const PlaceholderScreen(title: 'Lịch nghỉ team', owner: 'TV4'),
      ),

      // ----- TV5: Duyệt đơn & Thông báo -----
      GoRoute(
        path: AppRoutes.approvalInbox,
        builder: (_, _) => const PlaceholderScreen(title: 'Hộp duyệt đơn', owner: 'TV5'),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const PlaceholderScreen(title: 'Thông báo', owner: 'TV5'),
      ),
      GoRoute(
        path: AppRoutes.teamDashboard,
        builder: (_, _) => const PlaceholderScreen(title: 'Team Dashboard', owner: 'TV5'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy')),
      body: Center(child: Text('Không có route: ${state.uri}')),
    ),
  );
}
