import 'package:flutter/material.dart';

/// Màn hình tạm cho route chưa được thành viên phụ trách triển khai.
/// Khi làm xong screen thật thì thay widget này trong `app_router.dart`.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.owner});

  /// Tiêu đề màn hình.
  final String title;

  /// Thành viên phụ trách, ví dụ 'TV2'.
  final String owner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Màn hình này do $owner phụ trách, chưa triển khai.'),
          ],
        ),
      ),
    );
  }
}
