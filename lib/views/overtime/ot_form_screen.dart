import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/viewmodels/overtime/ot_form_viewmodel.dart';

class OtFormScreen extends ConsumerStatefulWidget {
  const OtFormScreen({super.key});

  @override
  ConsumerState<OtFormScreen> createState() => _OtFormScreenState();
}

class _OtFormScreenState extends ConsumerState<OtFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int _toMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (selected == null || !mounted) return;

    ref.read(otFormViewModelProvider.notifier).setDate(selected);
  }

  Future<void> _pickStartTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );

    if (selected == null || !mounted) return;

    ref.read(otFormViewModelProvider.notifier).setStartTime(selected);
  }

  Future<void> _pickEndTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );

    if (selected == null || !mounted) return;

    final form = ref.read(otFormViewModelProvider).value;
    if (form == null) return;

    final startTime = form.startTime;

    if (startTime != null && _toMinutes(selected) <= _toMinutes(startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ kết thúc phải sau giờ bắt đầu')),
      );
      return;
    }

    ref.read(otFormViewModelProvider.notifier).setEndTime(selected);
  }

  Future<void> _submit() async {
    final form = ref.read(otFormViewModelProvider).value;
    if (form == null) return;

    // Kiểm tra người dùng đã chọn đủ ngày và giờ chưa.
    if (form.date == null || form.startTime == null || form.endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đầy đủ ngày và giờ OT')),
      );
      return;
    }

    // Giờ kết thúc phải sau giờ bắt đầu.
    if (_toMinutes(form.endTime!) <= _toMinutes(form.startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ kết thúc phải sau giờ bắt đầu')),
      );
      return;
    }

    // Chạy validator của TextFormField lý do.
    if (!_formKey.currentState!.validate()) return;

    try {
      // Gọi ViewModel để gửi đơn xuống Repository và Supabase.
      await ref.read(otFormViewModelProvider.notifier).submit();

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không gửi được đơn OT: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formAsync = ref.watch(otFormViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tăng ca')),
      body: formAsync.when(
        loading: () => const LoadingView(message: 'Đang tải dữ liệu ngày lễ'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () {
            ref.invalidate(otFormViewModelProvider);
          },
        ),
        data: (form) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Ngày tăng ca'),
                  subtitle: Text(
                    form.date == null
                        ? 'Chưa chọn'
                        : '${form.date!.day}/'
                              '${form.date!.month}/'
                              '${form.date!.year}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Giờ bắt đầu'),
                  subtitle: Text(
                    form.startTime?.format(context) ?? 'Chưa chọn',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickStartTime,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Giờ kết thúc'),
                  subtitle: Text(form.endTime?.format(context) ?? 'Chưa chọn'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickEndTime,
                ),

                // UC-OT-02: hiển thị thời lượng OT.
                if (form.hours != null) ...[
                  const Divider(),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.more_time),
                      title: const Text('Thời lượng OT'),
                      trailing: Text(
                        '${form.hours!.toStringAsFixed(2)} giờ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],

                // UC-OT-03: hiển thị loại và hệ số OT.
                if (form.multiplier != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.percent),
                      title: Text(form.otTypeLabel!),
                      subtitle: const Text('Hệ số tăng ca'),
                      trailing: Text(
                        'x${form.multiplier!.toStringAsFixed(1)} '
                        '(${(form.multiplier! * 100).toStringAsFixed(0)}%)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Lý do tăng ca',
                    hintText: 'Ví dụ: Hoàn thành công việc cuối sprint',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: ref
                      .read(otFormViewModelProvider.notifier)
                      .setReason,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập lý do tăng ca';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: form.isSubmitting ? null : _submit,
                  child: form.isSubmitting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Gửi đơn OT'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
