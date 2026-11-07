import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timekeeper/viewmodels/overtime/ot_form_viewmodel.dart';

class OtFormScreen extends ConsumerStatefulWidget {
  const OtFormScreen({super.key});

  @override
  ConsumerState<OtFormScreen> createState() => _OtFormScreenState();
}

class _OtFormScreenState extends ConsumerState<OtFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (selected != null) {
      ref.read(otFormViewModelProvider.notifier).setDate(selected);
    }
  }

  Future<void> _pickStartTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );

    if (selected != null) {
      ref.read(otFormViewModelProvider.notifier).setStartTime(selected);
    }
  }

  Future<void> _pickEndTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );

    if (selected != null) {
      ref.read(otFormViewModelProvider.notifier).setEndTime(selected);
    }
  }

  void _checkInput() {
    final form = ref.read(otFormViewModelProvider);

    if (form.date == null || form.startTime == null || form.endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đầy đủ ngày và giờ OT')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã nhập đầy đủ thông tin OT')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(otFormViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tăng ca')),
      body: Form(
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
                    : '${form.date!.day}/${form.date!.month}/${form.date!.year}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Giờ bắt đầu'),
              subtitle: Text(form.startTime?.format(context) ?? 'Chưa chọn'),
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
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Lý do tăng ca',
                hintText: 'Ví dụ: Hoàn thành công việc cuối sprint',
                border: OutlineInputBorder(),
              ),
              onChanged: ref.read(otFormViewModelProvider.notifier).setReason,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập lý do tăng ca';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _checkInput,
              child: const Text('Kiểm tra thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}
