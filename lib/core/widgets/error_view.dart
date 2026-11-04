import 'package:flutter/material.dart';

/// Màn báo lỗi có nút thử lại, dùng cho nhánh `error` của AsyncValue.when.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  /// Lỗi nhận được (Exception, String...). Sẽ hiển thị bằng `toString()`.
  final Object error;

  /// Hàm gọi khi bấm "Thử lại". Null thì ẩn nút.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: scheme.error),
            const SizedBox(height: 12),
            Text(
              friendlyMessage(error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Rút gọn thông báo lỗi cho người dùng. Bỏ tiền tố "Exception: ".
  static String friendlyMessage(Object error) {
    final text = error.toString();
    return text.startsWith('Exception: ') ? text.substring(11) : text;
  }
}
