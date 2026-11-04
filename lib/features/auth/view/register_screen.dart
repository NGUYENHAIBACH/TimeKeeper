import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_view.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Màn đăng ký tài khoản email/mật khẩu.
/// Validate: email đúng định dạng, mật khẩu >= 8 ký tự có chữ và số,
/// xác nhận mật khẩu phải khớp. Thành công thì router tự vào Home.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authViewModelProvider.notifier)
        .register(_email.text, _password.text, _fullName.text);
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
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Họ và tên',
                controller: _fullName,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, field: 'Họ và tên'),
                enabled: !loading,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email',
                controller: _email,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                enabled: !loading,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Mật khẩu',
                hint: 'Ít nhất 8 ký tự, có chữ và số',
                controller: _password,
                prefixIcon: Icons.lock_outline,
                obscure: true,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
                enabled: !loading,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nhập lại mật khẩu',
                controller: _confirm,
                prefixIcon: Icons.lock_outline,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (v) => Validators.confirmPassword(_password.text)(v),
                enabled: !loading,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Tạo tài khoản', onPressed: _submit, loading: loading),
            ],
          ),
        ),
      ),
    );
  }
}
