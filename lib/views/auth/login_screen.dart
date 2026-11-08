import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/validators.dart';
import 'package:timekeeper/core/widgets/app_button.dart';
import 'package:timekeeper/core/widgets/app_text_field.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/viewmodels/auth/auth_viewmodel.dart';

/// Màn đăng nhập: email/mật khẩu + Google.
/// View chỉ gọi `AuthViewModel`; thành công thì router tự chuyển Home.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authViewModelProvider.notifier)
        .signIn(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    // Hiện SnackBar khi ViewModel báo lỗi.
    ref.listen(authViewModelProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorView.friendlyMessage(next.error!))),
        );
      }
    });
    final loading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 32),
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
                    controller: _password,
                    prefixIcon: Icons.lock_outline,
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        Validators.required(value, field: 'Mật khẩu'),
                    enabled: !loading,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: loading
                          ? null
                          : () => context.push(AppRoutes.forgotPassword),
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ),
                  AppButton(
                    label: 'Đăng nhập',
                    onPressed: _submit,
                    loading: loading,
                  ),
                  const SizedBox(height: 16),
                  const _OrDivider(),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Đăng nhập với Google',
                    icon: Icons.g_mobiledata,
                    outlined: true,
                    loading: loading,
                    onPressed: () => ref
                        .read(authViewModelProvider.notifier)
                        .signInWithGoogle(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có tài khoản?'),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () => context.push(AppRoutes.register),
                        child: const Text('Đăng ký'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo + tên app ở đầu màn.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(Icons.schedule, size: 64, color: scheme.primary),
        const SizedBox(height: 8),
        Text('TimeKeeper', style: Theme.of(context).textTheme.headlineMedium),
        Text(
          'Chấm công · Tăng ca · Nghỉ phép',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Đường kẻ "hoặc" giữa hai cách đăng nhập.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('hoặc'),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
