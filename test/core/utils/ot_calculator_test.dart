// Unit test cho logic tinh OT cua TV3.
// Chay: flutter test test/core/utils/ot_calculator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/utils/ot_calculator.dart';

void main() {
  group('OtCalculator.multiplierFor', () {
    test('ngay thuong co he so 150%', () {
      expect(OtCalculator.multiplierFor(DateTime(2026, 11, 6)), 1.5);
    });

    test('cuoi tuan co he so 200%', () {
      expect(OtCalculator.multiplierFor(DateTime(2026, 11, 7)), 2.0);
      expect(OtCalculator.multiplierFor(DateTime(2026, 11, 8)), 2.0);
    });

    test('ngay le co he so 300% ke ca khi trung cuoi tuan', () {
      final holiday = DateTime(2026, 11, 7);

      expect(OtCalculator.multiplierFor(holiday, holidays: [holiday]), 3.0);
    });
  });

  group('OtCalculator', () {
    test('tinh gio OT theo so phut thuc te', () {
      final start = DateTime(2026, 11, 6, 18);
      final end = DateTime(2026, 11, 6, 20, 30);

      expect(OtCalculator.hoursBetween(start, end), 2.5);
      expect(OtCalculator.paidHours(start: start, end: end), 3.75);
    });

    test('bao loi khi gio ket thuc khong sau gio bat dau', () {
      final start = DateTime(2026, 11, 6, 20);
      final end = DateTime(2026, 11, 6, 18);

      expect(() => OtCalculator.hoursBetween(start, end), throwsArgumentError);
    });
  });
}
