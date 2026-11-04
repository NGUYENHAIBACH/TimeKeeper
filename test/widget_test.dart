// Widget test tạm cho khung project: kiểm tra widget dùng chung render đúng.
// TV4 sẽ bổ sung Widget Test cho màn hình thật theo yêu cầu môn học.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';

void main() {
  testWidgets('LoadingView hiển thị vòng xoay và thông điệp', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoadingView(message: 'Đang tải'))),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Đang tải'), findsOneWidget);
  });

  testWidgets('ErrorView hiển thị lỗi và gọi onRetry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            error: Exception('Mất kết nối'),
            onRetry: () => retried = true,
          ),
        ),
      ),
    );
    expect(find.text('Mất kết nối'), findsOneWidget);
    await tester.tap(find.text('Thử lại'));
    expect(retried, isTrue);
  });
}
