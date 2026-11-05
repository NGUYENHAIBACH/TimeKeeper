import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/attendance_correction.dart';
import '../viewmodel/day_detail_viewmodel.dart';
import 'widgets/status_style.dart';

/// Screen 3 (TV2): Chi tiết ngày công + danh sách đơn bù công.
class DayDetailScreen extends ConsumerWidget {
  const DayDetailScreen({super.key, required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = dayDetailViewModelProvider(day);
    final async = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: Text('${AppDate.weekdayName(day)}, ${AppDate.display(day)}')),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(provider)),
        data: (s) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Text('Trạng thái', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              StatusChip(s.status),
            ]),
            const SizedBox(height: 12),
            _RecordCard(state: s),
            const SizedBox(height: 24),
            Row(children: [
              Text('Đơn bù công', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              if (s.canRequestCorrection)
                FilledButton.tonalIcon(
                  // Theme chung cho nút rộng hết màn; nút trong Row phải tự co lại.
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Gửi đơn'),
                  onPressed: () => context.push(AppRoutes.attendanceCorrectionOf(day)),
                ),
            ]),
            const SizedBox(height: 8),
            if (s.corrections.isEmpty)
              Text(
                s.status.needsCorrection
                    ? 'Quên chấm công? Gửi đơn để quản lý xác nhận giờ vào/ra.'
                    : 'Không có đơn nào.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              for (final c in s.corrections) _CorrectionTile(correction: c),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.state});
  final DayDetailState state;

  @override
  Widget build(BuildContext context) {
    final r = state.record;
    final shift = state.shift;
    final shiftText =
        '${AppDate.time(shift.startOn(state.day))} – ${AppDate.time(shift.endOn(state.day))}';
    final worked = r?.workedDuration;

    return Card(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Ca làm'),
          trailing: Text(shiftText),
        ),
        ListTile(
          leading: const Icon(Icons.login, color: Colors.green),
          title: const Text('Giờ vào'),
          subtitle: state.lateMinutes > 0
              ? Text('Muộn ${state.lateMinutes} phút',
                  style: const TextStyle(color: Colors.orange))
              : null,
          trailing: Text(AppDate.time(r?.checkInAt),
              style: Theme.of(context).textTheme.titleMedium),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.orange),
          title: const Text('Giờ ra'),
          trailing: Text(AppDate.time(r?.checkOutAt),
              style: Theme.of(context).textTheme.titleMedium),
        ),
        ListTile(
          leading: const Icon(Icons.timelapse),
          title: const Text('Tổng thời gian'),
          trailing: Text(worked == null ? '--' : AppDate.duration(worked)),
        ),
        if (r?.checkInLat != null)
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Vị trí check-in'),
            subtitle: Text(
              '${r!.checkInLat!.toStringAsFixed(5)}, ${r.checkInLng!.toStringAsFixed(5)}',
            ),
            trailing: Icon(
              r.synced ? Icons.cloud_done : Icons.cloud_off,
              color: r.synced ? Colors.green : Colors.grey,
            ),
          ),
      ]),
    );
  }
}

class _CorrectionTile extends StatelessWidget {
  const _CorrectionTile({required this.correction});
  final AttendanceCorrection correction;

  @override
  Widget build(BuildContext context) {
    final c = correction;
    final color = switch (c.status) {
      CorrectionStatus.pending => Colors.amber[800],
      CorrectionStatus.approved => Colors.green[700],
      CorrectionStatus.rejected => Colors.red[700],
      CorrectionStatus.cancelled => Colors.grey[700],
    };
    return Card(
      child: ListTile(
        title: Text('Vào ${AppDate.time(c.requestedCheckIn)} · Ra ${AppDate.time(c.requestedCheckOut)}'),
        subtitle: Text(
          '${c.reason}\nGửi lúc ${AppDate.time(c.createdAt)} ${AppDate.display(c.createdAt)}'
          '${c.rejectReason != null ? '\nLý do từ chối: ${c.rejectReason}' : ''}',
        ),
        isThreeLine: true,
        trailing: Text(c.status.label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
