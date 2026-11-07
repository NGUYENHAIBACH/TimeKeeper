import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timekeeper/core/utils/validators.dart';
import 'package:timekeeper/core/widgets/app_button.dart';
import 'package:timekeeper/core/widgets/app_text_field.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

/// Màn Hồ sơ: xem thông tin, sửa họ tên / số điện thoại, đổi ảnh đại diện
/// (upload lên Supabase Storage bucket `avatars`).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileViewModelProvider);

    // Lỗi khi lưu / upload -> SnackBar, form vẫn giữ nguyên.
    ref.listen(profileViewModelProvider, (prev, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorView.friendlyMessage(next.error!))),
        );
      }
    });

    final profile = profileAsync.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ cá nhân')),
      // Đã có dữ liệu thì luôn hiện form (kể cả đang lưu) để không mất chữ
      // người dùng đang gõ; chỉ hiện loading / error toàn màn ở lần tải đầu.
      body: profile != null
          ? _ProfileForm(profile: profile, saving: profileAsync.isLoading)
          : profileAsync.when(
              loading: () => const LoadingView(message: 'Đang tải hồ sơ'),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.read(profileViewModelProvider.notifier).refresh(),
              ),
              data: (_) => const ErrorView(error: 'Không tìm thấy hồ sơ'),
            ),
    );
  }
}

/// Form sửa hồ sơ. Stateful vì giữ controller của ô nhập.
class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.profile, required this.saving});
  final Profile profile;
  final bool saving;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _fullName = TextEditingController(text: widget.profile.fullName ?? '');
  late final _phone = TextEditingController(text: widget.profile.phone ?? '');

  static const _roleLabels = {
    UserRole.employee: 'Nhân viên',
    UserRole.manager: 'Quản lý',
    UserRole.admin: 'Quản trị viên',
  };

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(profileViewModelProvider.notifier).updateInfo(
          fullName: _fullName.text.trim(),
          phone: _phone.text.trim(),
        );
    if (!mounted) return;
    if (!ref.read(profileViewModelProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã lưu hồ sơ')));
    }
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final name = picked.name.toLowerCase();
    final ext = name.endsWith('.png') ? 'png' : 'jpg';
    await ref.read(profileViewModelProvider.notifier).changeAvatar(bytes, ext);
    if (!mounted) return;
    if (!ref.read(profileViewModelProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã cập nhật ảnh đại diện')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final saving = widget.saving;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton.filled(
                      tooltip: 'Đổi ảnh đại diện',
                      icon: const Icon(Icons.camera_alt, size: 18),
                      onPressed: saving ? null : _pickAvatar,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Chip(
                avatar: Icon(Icons.badge_outlined, size: 18, color: scheme.primary),
                label: Text(_roleLabels[profile.role]!),
              ),
            ),
            const SizedBox(height: 24),
            // Email do Firebase quản lý nên chỉ hiển thị, không cho sửa.
            TextFormField(
              initialValue: profile.email,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Họ và tên',
              controller: _fullName,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, field: 'Họ và tên'),
              enabled: !saving,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Số điện thoại',
              hint: '0912345678',
              controller: _phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: Validators.phone,
              enabled: !saving,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Lưu thay đổi',
              icon: Icons.save_outlined,
              onPressed: _save,
              loading: saving,
            ),
          ],
        ),
      ),
    );
  }
}
