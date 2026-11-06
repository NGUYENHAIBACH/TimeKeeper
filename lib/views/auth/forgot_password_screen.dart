import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timekeeper/core/utils/validators.dart';
import 'package:timekeeper/core/widgets/app_button.dart';
import 'package:timekeeper/core/widgets/app_text_field.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/viewmodels/auth/auth_viewmodel.dart';

/// Màn quên mật khẩu: nhập email, Firebase gửi link đặt lại.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok =
        await ref.read(authViewModelProvider.notifier).sendResetEmail(_email.text);
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorView.friendlyMessage(next.error!))),
        );
      }
    });
    final loading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? _SentView(email: _email.text)
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nhập email đã đăng ký, chúng tôi sẽ gửi link đặt lại mật khẩu.',
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Email',
                      controller: _email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: Validators.email,
                      enabled: !loading,
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Gửi email', onPressed: _submit, loading: loading),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Thông báo đã gửi email thành công.
class _SentView extends StatelessWidget {
  const _SentView({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.mark_email_read_outlined,
            size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text('Đã gửi email tới $email', textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Kiểm tra hộp thư (kể cả mục Spam) và làm theo hướng dẫn.',
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        AppButton(
          label: 'Quay lại đăng nhập',
          outlined: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
