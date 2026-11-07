import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/models/home_dashboard.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/models/today_attendance.dart';
import 'package:timekeeper/viewmodels/home/home_viewmodel.dart';

/// Home Dashboard: trạng thái chấm công hôm nay, tổng giờ tháng, số phép
/// còn, nút check-in nhanh và lối tắt tới các module.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeKeeper'),
        actions: [
          IconButton(
            tooltip: 'Thông báo',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          IconButton(
            tooltip: 'Cài đặt',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const LoadingView(message: 'Đang tải dữ liệu'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.read(homeViewModelProvider.notifier).refresh(),
        ),
        data: (dashboard) {
          if (dashboard == null) {
            return const LoadingView(message: 'Đang đăng nhập');
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: _DashboardBody(dashboard: dashboard),
          );
        },
      ),
    );
  }
}

/// Nội dung Dashboard khi đã có dữ liệu.
class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard});
  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final profile = dashboard.profile;
    final isManager = profile.role != UserRole.employee;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _GreetingCard(profile: profile),
        const SizedBox(height: 12),
        _TodayCard(today: dashboard.today),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.schedule,
                label: 'Giờ làm tháng này',
                value: '${dashboard.summary.totalHours.toStringAsFixed(1)} h',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.beach_access,
                label: 'Phép năm còn',
                value: '${_formatDays(dashboard.leave.remainingDays)} ngày',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.event_available,
                label: 'Ngày công',
                value: '${dashboard.summary.workDays}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.timer_off_outlined,
                label: 'Ngày đi trễ',
                value: '${dashboard.summary.lateDays}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Lối tắt', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            const _ShortcutCard(
              icon: Icons.calendar_month,
              label: 'Lịch công',
              route: AppRoutes.attendanceCalendar,
            ),
            const _ShortcutCard(
              icon: Icons.more_time,
              label: 'Tăng ca',
              route: AppRoutes.otForm,
            ),
            const _ShortcutCard(
              icon: Icons.event_busy,
              label: 'Nghỉ phép',
              route: AppRoutes.leaveHistory,
            ),
            const _ShortcutCard(
              icon: Icons.bar_chart,
              label: 'Báo cáo OT',
              route: AppRoutes.otReport,
            ),
            // Chỉ quản lý / admin mới thấy duyệt đơn và team.
            if (isManager) ...const [
              _ShortcutCard(
                icon: Icons.fact_check,
                label: 'Duyệt đơn',
                route: AppRoutes.approvalInbox,
              ),
              _ShortcutCard(
                icon: Icons.groups,
                label: 'Team',
                route: AppRoutes.teamDashboard,
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// 8.0 -> "8", 8.5 -> "8.5".
  static String _formatDays(double days) =>
      days == days.roundToDouble() ? days.toStringAsFixed(0) : days.toStringAsFixed(1);
}

/// Thẻ chào + avatar, bấm để mở Hồ sơ.
class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.profile});
  final Profile profile;

  static const _roleLabels = {
    UserRole.employee: 'Nhân viên',
    UserRole.manager: 'Quản lý',
    UserRole.admin: 'Quản trị viên',
  };

  @override
  Widget build(BuildContext context) {
    final name = (profile.fullName?.trim().isNotEmpty ?? false)
        ? profile.fullName!
        : profile.email;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage:
              profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text('Xin chào, $name'),
        subtitle: Text(_roleLabels[profile.role]!),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.profile),
      ),
    );
  }
}

/// Thẻ trạng thái chấm công hôm nay + nút check-in / check-out nhanh.
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.today});
  final TodayAttendance? today;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final String title;
    final String subtitle;
    final String buttonLabel;
    final IconData icon;
    final Color color;

    final t = today;
    if (t == null || t.checkInAt == null) {
      title = 'Chưa chấm công';
      subtitle = 'Bạn chưa check-in hôm nay';
      buttonLabel = 'Check-in ngay';
      icon = Icons.login;
      color = scheme.error;
    } else if (t.isWorking) {
      title = 'Đang làm việc';
      subtitle = 'Check-in lúc ${AppDateUtils.toHourMinute(t.checkInAt!)}'
          '${t.lateMinutes > 0 ? ' · trễ ${t.lateMinutes} phút' : ''}';
      buttonLabel = 'Check-out';
      icon = Icons.logout;
      color = scheme.primary;
    } else {
      title = 'Đã hoàn thành';
      subtitle = '${AppDateUtils.toHourMinute(t.checkInAt!)} - '
          '${AppDateUtils.toHourMinute(t.checkOutAt!)} · '
          '${t.workHours.toStringAsFixed(1)} giờ';
      buttonLabel = 'Xem chi tiết';
      icon = Icons.check_circle_outline;
      color = scheme.tertiary;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fingerprint, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hôm nay', style: text.labelMedium),
                      Text(title, style: text.titleLarge?.copyWith(color: color)),
                      Text(subtitle, style: text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.checkin),
              icon: Icon(icon),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ô số liệu nhỏ (giờ tháng, phép còn, ngày công, ngày trễ).
class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: text.headlineSmall),
            Text(label, style: text.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Ô lối tắt tới một module.
class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
