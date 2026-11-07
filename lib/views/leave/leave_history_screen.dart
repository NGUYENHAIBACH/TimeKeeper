import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/viewmodels/leave/leave_history_viewmodel.dart';
import 'package:timekeeper/views/leave/widgets/leave_status_chip.dart';

/// Màn Lịch sử & Số dư phép (TV4): số ngày phép theo loại, danh sách đơn
/// có lọc theo trạng thái / loại phép, hủy đơn đang chờ duyệt.
class LeaveHistoryScreen extends ConsumerWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leaveHistoryViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nghỉ phép'),
        actions: [
          IconButton(
            tooltip: 'Lịch nghỉ team',
            icon: const Icon(Icons.groups_outlined),
            onPressed: () => context.push(AppRoutes.leaveTeamCalendar),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('leave_new'),
        onPressed: () => context.push(AppRoutes.leaveForm),
        icon: const Icon(Icons.add),
        label: const Text('Xin nghỉ'),
      ),
      body: async.when(
        loading: () => const LoadingView(message: 'Đang tải số dư phép'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.read(leaveHistoryViewModelProvider.notifier).refresh(),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(leaveHistoryViewModelProvider.notifier).refresh(),
          child: _HistoryBody(data: data),
        ),
      ),
    );
  }
}

class _HistoryBody extends ConsumerWidget {
  const _HistoryBody({required this.data});

  final LeaveHistoryData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(leaveHistoryFilterProvider);
    final items = data.filtered(filter);
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Text('Số dư phép năm ${data.year}', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TotalCard(
                label: 'Còn lại (có lương)',
                value: LeaveCalculator.formatDays(data.totalRemaining),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TotalCard(
                label: 'Đang chờ duyệt',
                value: LeaveCalculator.formatDays(data.pendingDays),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final b in data.balances) _BalanceTile(balance: b),
        const SizedBox(height: 16),
        Text('Đơn của tôi', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        _FilterBar(data: data, filter: filter),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Không có đơn nào')),
          )
        else
          for (final r in items) _RequestTile(request: r),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('$value ngày', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

/// Một dòng số dư: tên loại phép, đã dùng / tổng, thanh tiến độ.
class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.balance});
  final LeaveBalance balance;

  @override
  Widget build(BuildContext context) {
    final type = balance.leaveType;
    final paid = type?.isPaid ?? true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(type?.name ?? 'Loại phép',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                Text(
                  paid
                      ? 'Còn ${LeaveCalculator.formatDays(balance.remainingDays)}'
                          '/${LeaveCalculator.formatDays(balance.totalDays)}'
                      : 'Đã nghỉ ${LeaveCalculator.formatDays(balance.usedDays)}',
                ),
              ],
            ),
            if (paid) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: balance.usedRatio, minHeight: 6),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lọc theo trạng thái (chip) và loại phép (dropdown).
class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.data, required this.filter});
  final LeaveHistoryData data;
  final LeaveFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(leaveHistoryFilterProvider.notifier);
    final types = {
      for (final b in data.balances)
        if (b.leaveType != null) b.leaveTypeId: b.leaveType!.name,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('Tất cả'),
                  selected: filter.status == null,
                  onSelected: (_) => notifier.setStatus(null),
                ),
              ),
              for (final s in LeaveStatus.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    key: Key('leave_filter_${s.name}'),
                    label: Text(s.label),
                    selected: filter.status == s,
                    onSelected: (_) => notifier.setStatus(s),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          key: ValueKey('leave_filter_type_${filter.leaveTypeId}'),
          initialValue: filter.leaveTypeId,
          decoration: const InputDecoration(
            labelText: 'Loại phép',
            isDense: true,
            prefixIcon: Icon(Icons.filter_list),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('Tất cả loại phép')),
            for (final e in types.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: notifier.setLeaveType,
        ),
      ],
    );
  }
}

/// Một đơn nghỉ trong danh sách, có nút hủy khi đơn đang chờ duyệt.
class _RequestTile extends ConsumerWidget {
  const _RequestTile({required this.request});
  final LeaveRequest request;

  static final _fmt = DateFormat('dd/MM/yyyy');

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy đơn nghỉ?'),
        content: const Text('Đơn sẽ chuyển sang trạng thái "Đã hủy".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Không')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hủy đơn')),
        ],
      ),
    );
    if (yes != true) return;
    final err = await ref.read(leaveHistoryViewModelProvider.notifier).cancel(request);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err == null ? 'Đã hủy đơn' : ErrorView.friendlyMessage(err))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = request;
    final range = r.startDate == r.endDate
        ? _fmt.format(r.startDate)
        : '${_fmt.format(r.startDate)} - ${_fmt.format(r.endDate)}';
    final half = r.halfDay == HalfDay.none ? '' : ' (${r.halfDay.label})';
    return Card(
      child: ListTile(
        title: Text(r.leaveType?.name ?? 'Nghỉ phép'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$range$half · ${LeaveCalculator.formatDays(r.totalDays)} ngày'),
            Text(r.reason, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (r.status == LeaveStatus.rejected && r.rejectReason != null)
              Text('Lý do từ chối: ${r.rejectReason}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            if (r.attachmentUrl != null)
              const Row(children: [
                Icon(Icons.attach_file, size: 14),
                Text(' Có file đính kèm'),
              ]),
          ],
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LeaveStatusChip(status: r.status),
            if (r.canCancel)
              InkWell(
                key: Key('leave_cancel_${r.id}'),
                onTap: () => _confirmCancel(context, ref),
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('Hủy', style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
