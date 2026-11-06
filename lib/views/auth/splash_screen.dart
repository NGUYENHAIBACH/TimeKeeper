import 'package:flutter/material.dart';

/// Màn chờ khi Firebase đang khôi phục phiên đăng nhập.
/// Router tự chuyển sang Home hoặc Login khi `authState` có giá trị,
/// nên màn này không có logic gì ngoài hiển thị.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule, size: 72, color: scheme.primary),
            const SizedBox(height: 16),
            Text('TimeKeeper', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
