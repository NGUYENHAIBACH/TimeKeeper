import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/correction_validator.dart';
import '../../../core/utils/date_utils.dart';
import '../viewmodel/day_detail_viewmodel.dart';

/// Form gửi đơn bù công (thuộc Screen 3 – Chi tiết ngày + Đơn bù công).
/// Dùng chung ViewModel với DayDetailScreen.
class CorrectionFormScreen extends ConsumerStatefulWidget {
  const CorrectionFormScreen({super.key, required this.day});
  final DateTime day;

  @override
  ConsumerState<CorrectionFormScreen> createState() => _CorrectionFormScreenState();
}

class _CorrectionFormScreenState extends ConsumerState<CorrectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();
  TimeOfDay? _checkIn;
  TimeOfDay? _checkOut;
  bool _submitting = false;
  bool _triedSubmit = false;
  List<String> _errors = const [];

  @override
  void initState() {
    super.initState();
    // Điền sẵn giờ đã có, người dùng chỉ cần bổ sung phần thiếu.
    final record = ref.read(dayDetailViewModelProvider(widget.day)).value?.record;
    if (record?.checkInAt != null) _checkIn = TimeOfDay.fromDateTime(record!.checkInAt!);
    if (record?.checkOutAt != null) _checkOut = TimeOfDay.fromDateTime(record!.checkOutAt!);
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  DateTime? _toDate(TimeOfDay? t) => t == null
      ? null
      : DateTime(widget.day.year, widget.day.month, widget.day.day, t.hour, t.minute);

  Future<void> _pick(bool isCheckIn) async {
    final initial = (isCheckIn ? _checkIn : _checkOut) ??
        (isCheckIn
            ? const TimeOfDay(hour: 8, minute: 0)
            : const TimeOfDay(hour: 17, minute: 0));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isCheckIn ? 'Giờ vào' : 'Giờ ra',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
      } else {
        _checkOut = picked;
      }
      _errors = const [];
    });
  }

  Future<void> _submit() async {
    setState(() => _triedSubmit = true);
    if (!_formKey.currentState!.validate()) return;
    final vm = ref.read(dayDetailViewModelProvider(widget.day).notifier);
    final errors = vm.validate(
      checkIn: _toDate(_checkIn),
      checkOut: _toDate(_checkOut),
      reason: _reason.text,
    );
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }

    setState(() => _submitting = true);
    final result = await vm.submitCorrection(
      checkIn: _toDate(_checkIn),
      checkOut: _toDate(_checkOut),
      reason: _reason.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      context.pop();
    } else {
      setState(() => _errors = result.message.split('\n'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn bù công')),
      body: Form(
        key: _formKey,
        // Sau lần bấm gửi đầu tiên thì kiểm tra lại ngay khi gõ.
        autovalidateMode: _triedSubmit
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Ngày ${AppDate.display(widget.day)}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _TimeField(
                label: 'Giờ vào',
                value: _checkIn,
                onTap: () => _pick(true),
                onClear: () => setState(() => _checkIn = null),
              )),
              const SizedBox(width: 12),
              Expanded(child: _TimeField(
                label: 'Giờ ra',
                value: _checkOut,
                onTap: () => _pick(false),
                onClear: () => setState(() => _checkOut = null),
              )),
            ]),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reason,
              maxLines: 4,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'Lý do',
                hintText: 'VD: Quên check-out do họp với khách hàng đến 18h',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v ?? '').trim().length < CorrectionValidator.minReasonLength
                      ? 'Lý do cần ít nhất ${CorrectionValidator.minReasonLength} ký tự'
                      : null,
            ),
            if (_errors.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final e in _errors)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $e', style: const TextStyle(color: Colors.red)),
                ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Gửi đơn'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
    required this.onClear,
  });
  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: value == null
              ? const Icon(Icons.schedule)
              : IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
        ),
        child: Text(value == null
            ? '--:--'
            : '${value!.hour.toString().padLeft(2, '0')}:'
                '${value!.minute.toString().padLeft(2, '0')}'),
      ),
    );
  }
}
