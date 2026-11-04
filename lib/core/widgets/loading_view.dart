import 'package:flutter/material.dart';

/// Vòng xoay loading toàn màn, dùng cho nhánh `loading` của AsyncValue.when.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  /// Dòng chữ nhỏ dưới vòng xoay (tùy chọn).
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
