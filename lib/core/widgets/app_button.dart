import 'package:flutter/material.dart';

/// Nút chính của app. Khi [loading] = true thì khóa nút và hiện vòng xoay,
/// dùng cho các hành động gọi mạng (đăng nhập, gửi đơn...).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.outlined = false,
  });

  final String label;

  /// Null = disabled.
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  /// true = kiểu viền (hành động phụ), false = kiểu đặc (hành động chính).
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
              Text(label),
            ],
          );
    final callback = loading ? null : onPressed;
    if (outlined) {
      return OutlinedButton(
        onPressed: callback,
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        child: child,
      );
    }
    return FilledButton(onPressed: callback, child: child);
  }
}
