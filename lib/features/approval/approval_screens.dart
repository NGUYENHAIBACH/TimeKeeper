import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import 'approval_viewmodels.dart';

/// TV5 inbox. Mutations are handled by the ViewModel and repository.
class ApprovalInboxScreen extends ConsumerWidget {
  const ApprovalInboxScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(approvalInboxProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hộp duyệt đơn'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(approvalInboxProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: value.when(
        loading: () => const LoadingView(),
        error: (e, s) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(approvalInboxProvider),
        ),
        data: (rows) => rows.isEmpty
            ? const Center(child: Text('Không có đơn chờ duyệt'))
            : ListView(
                children: rows
                    .map(
                      (row) => Card(
                        child: ListTile(
                          title: Text(
                            '${row['table']} · ${row['employee_id']}',
                          ),
                          subtitle: Text('${row['reason'] ?? ''}'),
                          onTap: () => _decide(context, ref, row),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> row,
  ) async {
    final reason = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duyệt đơn'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                row.entries
                    .where((e) => e.key != 'table')
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n'),
              ),
              TextField(
                controller: reason,
                decoration: const InputDecoration(labelText: 'Lý do từ chối'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Từ chối'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Duyệt'),
          ),
        ],
      ),
    );
    final text = reason.text;
    reason.dispose();
    if (result == null || !context.mounted) return;
    try {
      await ref.read(approvalInboxProvider.notifier).decide(row, result, text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ErrorView.friendlyMessage(e))));
      }
    }
  }
}

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('Thông báo'),
      actions: [
        IconButton(
          onPressed: () => ref.invalidate(notificationCenterProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: ref
        .watch(notificationCenterProvider)
        .when(
          loading: () => const LoadingView(),
          error: (e, s) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(notificationCenterProvider),
          ),
          data: (rows) => rows.isEmpty
              ? const Center(child: Text('Chưa có thông báo'))
              : ListView(
                  children: rows
                      .map(
                        (row) => ListTile(
                          leading: Icon(
                            row['is_read'] == true
                                ? Icons.notifications_none
                                : Icons.notifications_active,
                          ),
                          title: Text('${row['title']}'),
                          subtitle: Text('${row['body']}'),
                          onTap: () async {
                            try {
                              final detail = await ref
                                  .read(notificationCenterProvider.notifier)
                                  .detail(
                                    row['ref_table'] as String,
                                    row['ref_id'] as String,
                                  );
                              await ref
                                  .read(notificationCenterProvider.notifier)
                                  .markRead(row['id'] as String);
                              if (context.mounted) {
                                showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('${row['title']}'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                        detail.entries
                                            .map((e) => '${e.key}: ${e.value}')
                                            .join('\n'),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Đóng'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text('$e')));
                              }
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
        ),
  );
}

class TeamDashboardScreen extends ConsumerWidget {
  const TeamDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('Đội nhóm hôm nay'),
      actions: [
        PopupMenuButton<bool>(
          itemBuilder: (_) => const [
            PopupMenuItem(value: true, child: Text('Xuất PDF')),
            PopupMenuItem(value: false, child: Text('Xuất Excel')),
          ],
          onSelected: (pdf) async {
            try {
              final path = await ref
                  .read(teamDashboardProvider.notifier)
                  .export(pdf);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Đã lưu: $path')));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(ErrorView.friendlyMessage(e))));
              }
            }
          },
        ),
        IconButton(
          onPressed: () => ref.invalidate(teamDashboardProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: ref
        .watch(teamDashboardProvider)
        .when(
          loading: () => const LoadingView(),
          error: (e, s) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(teamDashboardProvider),
          ),
          data: (rows) => rows.isEmpty
              ? const Center(
                  child: Text(
                    'Không có nhân viên đi muộn hoặc nghỉ phép hôm nay',
                  ),
                )
              : ListView(
                  children: rows
                      .map(
                        (row) => ListTile(
                          title: Text('${row['employee_id']}'),
                          subtitle: Text(
                            '${row['kind']} · ${row['late_minutes'] ?? row['reason'] ?? ''}',
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
  );
}
