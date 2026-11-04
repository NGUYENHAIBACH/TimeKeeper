import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/profile.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../settings/viewmodel/profile_viewmodel.dart';

/// Home Dashboard (bản khung). Hiện hồ sơ + lối tắt tới các module.
/// Các thẻ chấm công / giờ tháng / số phép sẽ nối với repository của
/// TV2 và TV4 ở bước sau (HomeViewModel).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeKeeper'),
        actions: [
          IconButton(
            tooltip: 'Cài đặt',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingView(message: 'Đang tải hồ sơ'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.read(profileViewModelProvider.notifier).refresh(),
        ),
        data: (profile) => _HomeBody(profile: profile),
      ),
    );
  }
}

/// Nội dung Home khi đã có hồ sơ.
class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.profile});
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final name = profile?.fullName?.trim().isNotEmpty == true
        ? profile!.fullName!
        : (profile?.email ?? 'bạn');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
              child: profile?.avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            title: Text('Xin chào, $name'),
            subtitle: Text('Vai trò: ${profile?.role.name ?? '-'}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.profile),
          ),
        ),
        const SizedBox(height: 16),
        Text('Lối tắt', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: const [
            _ShortcutCard(icon: Icons.fingerprint, label: 'Chấm công', route: AppRoutes.checkin),
            _ShortcutCard(icon: Icons.calendar_month, label: 'Lịch công', route: AppRoutes.attendanceCalendar),
            _ShortcutCard(icon: Icons.more_time, label: 'Tăng ca', route: AppRoutes.otList),
            _ShortcutCard(icon: Icons.beach_access, label: 'Nghỉ phép', route: AppRoutes.leaveHistory),
            _ShortcutCard(icon: Icons.fact_check, label: 'Duyệt đơn', route: AppRoutes.approvalInbox),
            _ShortcutCard(icon: Icons.notifications, label: 'Thông báo', route: AppRoutes.notifications),
          ],
        ),
      ],
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
            Text(label),
          ],
        ),
      ),
    );
  }
}
