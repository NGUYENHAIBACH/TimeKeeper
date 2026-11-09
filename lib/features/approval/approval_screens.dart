import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
                        margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(_requestIcon(row['table'] as String)),
                          ),
                          title: Text(_requestTitle(row['table'] as String)),
                          subtitle: Text(
                            '${_employeeLabel(row)}\n${_requestSummary(row)}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
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
      builder: (context) =>
          _ApprovalDecisionDialog(row: row, reasonController: reason),
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

class _ApprovalDecisionDialog extends StatefulWidget {
  const _ApprovalDecisionDialog({
    required this.row,
    required this.reasonController,
  });

  final Map<String, dynamic> row;
  final TextEditingController reasonController;

  @override
  State<_ApprovalDecisionDialog> createState() =>
      _ApprovalDecisionDialogState();
}

class _ApprovalDecisionDialogState extends State<_ApprovalDecisionDialog> {
  String? _reasonError;

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 8, 0),
      title: Row(
        children: [
          Expanded(child: Text(_requestTitle(row['table'] as String))),
          IconButton(
            tooltip: 'Đóng',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _employeeLabel(row),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if ((row['employee_email'] as String?)?.isNotEmpty == true) ...[
                const SizedBox(height: 2),
                Text(
                  row['employee_email'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              ..._requestDetails(row).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          item.$1,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(child: Text(item.$2)),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              TextField(
                controller: widget.reasonController,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Lý do từ chối',
                  hintText: 'Bắt buộc khi từ chối đơn',
                  errorText: _reasonError,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  if (_reasonError != null) {
                    setState(() => _reasonError = null);
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reject,
                      icon: const Icon(Icons.close),
                      label: const Text('Từ chối'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.check),
                      label: const Text('Duyệt'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reject() {
    if (widget.reasonController.text.trim().isEmpty) {
      setState(() => _reasonError = 'Vui lòng nhập lý do từ chối');
      return;
    }
    Navigator.pop(context, false);
  }
}

String _requestTitle(String table) => switch (table) {
  'ot_requests' => 'Đơn tăng ca',
  'leave_requests' => 'Đơn nghỉ phép',
  'attendance_corrections' => 'Đơn bù công',
  _ => 'Đơn cần duyệt',
};

IconData _requestIcon(String table) => switch (table) {
  'ot_requests' => Icons.more_time,
  'leave_requests' => Icons.beach_access_outlined,
  'attendance_corrections' => Icons.edit_calendar_outlined,
  _ => Icons.description_outlined,
};

String _employeeLabel(Map<String, dynamic> row) {
  final name = (row['employee_name'] as String?)?.trim();
  return name == null || name.isEmpty ? 'Nhân viên' : name;
}

String _requestSummary(Map<String, dynamic> row) => switch (row['table']) {
  'ot_requests' =>
    '${_date(row['ot_date'])} · ${_time(row['start_time'])}–${_time(row['end_time'])}',
  'leave_requests' => '${_date(row['start_date'])}–${_date(row['end_date'])}',
  'attendance_corrections' => _date(row['work_date']),
  _ => '${row['reason'] ?? ''}',
};

List<(String, String)> _requestDetails(Map<String, dynamic> row) {
  final common = <(String, String)>[
    if ('${row['reason'] ?? ''}'.trim().isNotEmpty)
      ('Lý do', '${row['reason']}'),
  ];
  return switch (row['table']) {
    'ot_requests' => [
      ('Ngày tăng ca', _date(row['ot_date'])),
      ('Thời gian', '${_time(row['start_time'])} – ${_time(row['end_time'])}'),
      ('Số giờ', '${row['hours'] ?? '-'} giờ'),
      ('Loại OT', _otType('${row['ot_type'] ?? ''}')),
      ...common,
    ],
    'leave_requests' => [
      ('Từ ngày', _date(row['start_date'])),
      ('Đến ngày', _date(row['end_date'])),
      ('Số ngày', '${row['total_days'] ?? '-'} ngày'),
      if ('${row['half_day'] ?? 'none'}' != 'none')
        ('Nửa ngày', row['half_day'] == 'morning' ? 'Buổi sáng' : 'Buổi chiều'),
      ...common,
    ],
    'attendance_corrections' => [
      ('Ngày làm việc', _date(row['work_date'])),
      if (row['requested_check_in'] != null)
        ('Giờ vào đề nghị', _dateTime(row['requested_check_in'])),
      if (row['requested_check_out'] != null)
        ('Giờ ra đề nghị', _dateTime(row['requested_check_out'])),
      ...common,
    ],
    _ => common,
  };
}

String _date(dynamic value) {
  final parsed = DateTime.tryParse('$value');
  return parsed == null
      ? '-'
      : DateFormat('dd/MM/yyyy').format(parsed.toLocal());
}

String _dateTime(dynamic value) {
  final parsed = DateTime.tryParse('$value');
  return parsed == null
      ? '-'
      : DateFormat('HH:mm · dd/MM/yyyy').format(parsed.toLocal());
}

String _time(dynamic value) {
  final text = '$value';
  return text.length >= 5 ? text.substring(0, 5) : text;
}

String _otType(String value) => switch (value) {
  'weekday' => 'Ngày thường',
  'weekend' => 'Cuối tuần',
  'holiday' => 'Ngày lễ',
  _ => value,
};

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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ErrorView.friendlyMessage(e))),
                );
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
