import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/models/ot_request.dart';
import 'package:timekeeper/viewmodels/overtime/ot_list_viewmodel.dart';

class OtListScreen extends ConsumerWidget {
  const OtListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(otListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đơn tăng ca')),
      body: stateAsync.when(
        loading: () => const LoadingView(message: 'Đang tải đơn tăng ca'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(otListViewModelProvider),
        ),
        data: (state) => _OtListBody(state: state),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await context.push<bool>(AppRoutes.otForm);
          await ref.read(otListViewModelProvider.notifier).refresh();
          if (created == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gửi đơn OT thành công')),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tạo đơn'),
      ),
    );
  }
}

class _OtListBody extends ConsumerWidget {
  const _OtListBody({required this.state});

  final OtListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = state.filteredRequests;

    return RefreshIndicator(
      onRefresh: ref.read(otListViewModelProvider.notifier).refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _Filters(state: state)),
          if (requests.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              sliver: SliverList.separated(
                itemCount: requests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _OtRequestCard(
                  request: requests[index],
                  isCancelling: state.cancellingId == requests[index].id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({required this.state});

  final OtListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthKeys = <String>{
      for (final request in state.requests) _monthKey(request.otDate),
      _monthKey(DateTime.now()),
    }.toList()..sort((a, b) => b.compareTo(a));
    final selectedKey = state.selectedMonth == null
        ? 'all'
        : _monthKey(state.selectedMonth!);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: selectedKey,
              decoration: const InputDecoration(
                labelText: 'Tháng',
                prefixIcon: Icon(Icons.calendar_month),
              ),
              items: [
                const DropdownMenuItem(
                  value: 'all',
                  child: Text('Tất cả tháng'),
                ),
                for (final key in monthKeys)
                  DropdownMenuItem(value: key, child: Text(_monthLabel(key))),
              ],
              onChanged: (value) {
                if (value == null || value == 'all') {
                  ref.read(otListViewModelProvider.notifier).setMonth(null);
                  return;
                }
                final parts = value.split('-');
                ref
                    .read(otListViewModelProvider.notifier)
                    .setMonth(
                      DateTime(int.parse(parts[0]), int.parse(parts[1])),
                    );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: state.selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
                prefixIcon: Icon(Icons.filter_alt_outlined),
              ),
              items: [
                for (final status in otStatuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(status)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(otListViewModelProvider.notifier).setStatus(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OtRequestCard extends ConsumerWidget {
  const _OtRequestCard({required this.request, required this.isCancelling});

  final OtRequest request;
  final bool isCancelling;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetail(context, ref, request),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${AppDate.weekdayName(request.otDate)}, '
                      '${AppDate.display(request.otDate)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(status: request.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 6),
                  Text(request.timeRange),
                  const Spacer(),
                  Text(
                    '${_number(request.hours)} giờ · x${_number(request.multiplier)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (request.canCancel) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: isCancelling
                        ? null
                        : () => _confirmCancel(context, ref, request),
                    icon: isCancelling
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cancel_outlined),
                    label: const Text('Hủy đơn'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showDetail(
  BuildContext context,
  WidgetRef ref,
  OtRequest request,
) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chi tiết đơn OT',
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                ),
                _StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Ngày tăng ca',
              value: AppDate.display(request.otDate),
            ),
            _DetailRow(label: 'Thời gian', value: request.timeRange),
            _DetailRow(label: 'Số giờ', value: '${_number(request.hours)} giờ'),
            _DetailRow(
              label: 'Loại OT',
              value:
                  '${_typeLabel(request.otType)} '
                  '(x${_number(request.multiplier)})',
            ),
            _DetailRow(
              label: 'Giờ quy đổi',
              value: '${_number(request.paidHours)} giờ',
            ),
            _DetailRow(label: 'Lý do', value: request.reason),
            if (request.rejectReason?.isNotEmpty ?? false)
              _DetailRow(label: 'Lý do từ chối', value: request.rejectReason!),
            _DetailRow(
              label: 'Ngày tạo',
              value:
                  '${AppDate.display(request.createdAt)} '
                  '${AppDate.time(request.createdAt)}',
            ),
            if (request.canCancel) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await _confirmCancel(context, ref, request);
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Hủy đơn đang chờ'),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

Future<void> _confirmCancel(
  BuildContext context,
  WidgetRef ref,
  OtRequest request,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Hủy đơn tăng ca?'),
      content: const Text(
        'Đơn sẽ chuyển sang trạng thái đã hủy và không thể gửi lại.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Không'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Hủy đơn'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  try {
    await ref.read(otListViewModelProvider.notifier).cancel(request.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã hủy đơn tăng ca')));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Không thể hủy đơn: $error')));
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, status);
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(_statusLabel(status)),
      side: BorderSide.none,
      backgroundColor: color.withValues(alpha: 0.14),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.more_time_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'Không có đơn OT phù hợp',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text(
              'Đổi bộ lọc hoặc tạo đơn tăng ca mới.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _monthKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}';

String _monthLabel(String key) {
  final parts = key.split('-');
  return 'Tháng ${int.parse(parts[1])}/${parts[0]}';
}

String _number(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2);

String _statusLabel(String status) => switch (status) {
  'all' => 'Tất cả',
  'pending' => 'Chờ duyệt',
  'approved' => 'Đã duyệt',
  'rejected' => 'Từ chối',
  'cancelled' => 'Đã hủy',
  _ => status,
};

String _typeLabel(String type) => switch (type) {
  'weekday' => 'Ngày thường',
  'weekend' => 'Cuối tuần',
  'holiday' => 'Ngày lễ',
  _ => type,
};

Color _statusColor(BuildContext context, String status) => switch (status) {
  'approved' => Colors.green,
  'rejected' => Theme.of(context).colorScheme.error,
  'cancelled' => Theme.of(context).colorScheme.outline,
  _ => Colors.orange.shade800,
};
