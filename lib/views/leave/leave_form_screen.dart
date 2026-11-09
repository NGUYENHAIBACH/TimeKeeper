import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/core/widgets/app_button.dart';
import 'package:timekeeper/core/widgets/app_text_field.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/models/leave_type.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/leave/leave_form_viewmodel.dart';

/// Màn Form xin nghỉ (TV4): chọn loại phép, khoảng ngày, nửa ngày,
/// đính kèm file (Supabase Storage) và kiểm tra số dư trước khi gửi.
class LeaveFormScreen extends ConsumerWidget {
  const LeaveFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leaveFormViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Xin nghỉ phép')),
      body: async.when(
        loading: () => const LoadingView(message: 'Đang tải loại phép và số dư'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.read(leaveFormViewModelProvider.notifier).refresh(),
        ),
        data: (data) => LeaveForm(data: data),
      ),
    );
  }
}

/// Phần form khi đã có dữ liệu. Giữ state nhập liệu cục bộ (controller,
/// ngày đã chọn); nghiệp vụ tính ngày / kiểm tra nằm trong [LeaveFormData].
class LeaveForm extends ConsumerStatefulWidget {
  const LeaveForm({super.key, required this.data});

  final LeaveFormData data;

  @override
  ConsumerState<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends ConsumerState<LeaveForm> {
  static final _fmt = DateFormat('dd/MM/yyyy');

  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();
  LeaveType? _type;
  DateTime? _start;
  DateTime? _end;
  HalfDay _halfDay = HalfDay.none;
  LeaveAttachment? _attachment;

  LeaveFormData get _data => widget.data;

  bool get _singleDay =>
      _start != null && _end != null && LeaveCalculator.dateOnly(_start!) == LeaveCalculator.dateOnly(_end!);

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final year = _data.year;
    final now = DateTime.now();
    final initial = (isStart ? _start : _end ?? _start) ?? (now.year == year ? now : DateTime(year));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(year),
      lastDate: DateTime(year, 12, 31),
      helpText: isStart ? 'Ngày bắt đầu' : 'Ngày kết thúc',
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        if (_end == null || _end!.isBefore(picked)) _end = picked;
      } else {
        _end = picked;
        if (_start == null || _start!.isAfter(picked)) _start = picked;
      }
      if (!_singleDay) _halfDay = HalfDay.none;
    });
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: LeaveAttachment.allowedExtensions,
    );
    if (file == null) return;
    final size = await file.length();
    if (size != null && size > LeaveAttachment.maxBytes) {
      _snack('File quá lớn (tối đa 5 MB)');
      return;
    }
    final bytes = await file.readAsBytes();
    if (bytes.length > LeaveAttachment.maxBytes) {
      _snack('File quá lớn (tối đa 5 MB)');
      return;
    }
    if (!mounted) return;
    setState(() => _attachment = LeaveAttachment(name: file.name, bytes: bytes));
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref.read(leaveSubmitViewModelProvider.notifier).submit(
          type: _type,
          start: _start,
          end: _end,
          halfDay: _halfDay,
          reason: _reason.text,
          attachment: _attachment,
        );
    if (!mounted || !ok) return;
    _snack('Đã gửi đơn, chờ quản lý duyệt');
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.leaveHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(leaveSubmitViewModelProvider, (_, next) {
      if (next.hasError && !next.isLoading) _snack(ErrorView.friendlyMessage(next.error!));
    });
    final submitting = ref.watch(leaveSubmitViewModelProvider).isLoading;
    final days = (_start != null && _end != null) ? _data.countDays(_start!, _end!, _halfDay) : null;
    final available = _type == null ? null : _data.availableFor(_type!);
    final over = days != null && available != null && days > available;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<LeaveType>(
            key: const Key('leave_type_dropdown'),
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Loại phép',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: [
              for (final t in _data.types)
                DropdownMenuItem(
                  value: t,
                  child: Text(
                    t.isPaid
                        ? '${t.name} (còn ${LeaveCalculator.formatDays(_data.availableFor(t) ?? 0)} ngày)'
                        : t.name,
                  ),
                ),
            ],
            validator: (v) => v == null ? 'Chọn loại phép' : null,
            onChanged: (v) => setState(() => _type = v),
          ),
          if (_type?.requiresDocument == true)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('* Loại phép này bắt buộc đính kèm giấy tờ'),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  key: const Key('leave_start_date'),
                  label: 'Từ ngày',
                  value: _start == null ? null : _fmt.format(_start!),
                  onTap: () => _pickDate(isStart: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateField(
                  key: const Key('leave_end_date'),
                  label: 'Đến ngày',
                  value: _end == null ? null : _fmt.format(_end!),
                  onTap: () => _pickDate(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Thời lượng', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<HalfDay>(
            key: const Key('leave_half_day'),
            segments: [
              for (final h in HalfDay.values)
                ButtonSegment(
                  value: h,
                  label: Text(h.label),
                  enabled: h == HalfDay.none || _singleDay,
                ),
            ],
            selected: {_halfDay},
            onSelectionChanged: (s) => setState(() => _halfDay = s.first),
          ),
          if (!_singleDay)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Nghỉ nửa ngày chỉ chọn được khi nghỉ 1 ngày',
                  style: TextStyle(fontSize: 12)),
            ),
          const SizedBox(height: 16),
          _SummaryCard(days: days, type: _type, available: available, over: over),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('leave_reason'),
            label: 'Lý do',
            controller: _reason,
            prefixIcon: Icons.edit_note,
            maxLines: 3,
            validator: (v) =>
                (v == null || v.trim().length < 5) ? 'Lý do tối thiểu 5 ký tự' : null,
          ),
          const SizedBox(height: 16),
          _AttachmentTile(
            attachment: _attachment,
            onPick: submitting ? null : _pickFile,
            onRemove: () => setState(() => _attachment = null),
          ),
          const SizedBox(height: 24),
          AppButton(
            key: const Key('leave_submit'),
            label: 'Gửi đơn',
            icon: Icons.send,
            loading: submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Ô chọn ngày (bấm mở DatePicker).
class _DateField extends StatelessWidget {
  const _DateField({super.key, required this.label, required this.value, required this.onTap});

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.event)),
        child: Text(value ?? 'Chọn ngày'),
      ),
    );
  }
}

/// Thẻ tóm tắt: số ngày nghỉ tính được và số dư còn lại.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.days,
    required this.type,
    required this.available,
    required this.over,
  });

  final double? days;

  /// Loại phép đang chọn, null = chưa chọn.
  final LeaveType? type;
  final double? available;
  final bool over;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('leave_summary'),
      color: over ? scheme.errorContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Số ngày nghỉ',
                value: days == null ? '-' : LeaveCalculator.formatDays(days!),
              ),
            ),
            Expanded(
              child: _Stat(
                label: 'Số dư còn lại',
                value: type == null
                    ? '-'
                    : available == null
                        ? 'Không giới hạn'
                        : LeaveCalculator.formatDays(available!),
              ),
            ),
            if (over) Icon(Icons.warning_amber, color: scheme.error),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

/// Dòng đính kèm file: chọn / xem tên / gỡ file.
class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({required this.attachment, required this.onPick, required this.onRemove});

  final LeaveAttachment? attachment;
  final VoidCallback? onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final file = attachment;
    if (file == null) {
      return OutlinedButton.icon(
        key: const Key('leave_attach'),
        onPressed: onPick,
        icon: const Icon(Icons.attach_file),
        label: const Text('Đính kèm file (PDF/JPG/PNG, tối đa 5 MB)'),
      );
    }
    final kb = (file.bytes.length / 1024).toStringAsFixed(0);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.insert_drive_file_outlined),
        title: Text(file.name, overflow: TextOverflow.ellipsis),
        subtitle: Text('$kb KB'),
        trailing: IconButton(
          tooltip: 'Gỡ file',
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
