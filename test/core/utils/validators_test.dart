// Unit test cho Validators (yêu cầu môn: tối thiểu 1 Unit Test).
// Chạy: flutter test test/core/utils/validators_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('trống -> báo lỗi', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('sai định dạng -> báo lỗi', () {
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('abc@'), isNotNull);
      expect(Validators.email('abc@gmail'), isNotNull);
    });

    test('đúng định dạng -> null', () {
      expect(Validators.email('nguyenvana@gmail.com'), isNull);
      expect(Validators.email('  a.b+c@fpt.edu.vn  '), isNull);
    });
  });

  group('Validators.password', () {
    test('ngắn hơn 8 ký tự -> báo lỗi', () {
      expect(Validators.password('abc123'), isNotNull);
    });

    test('chỉ chữ hoặc chỉ số -> báo lỗi', () {
      expect(Validators.password('abcdefgh'), isNotNull);
      expect(Validators.password('12345678'), isNotNull);
    });

    test('đủ 8 ký tự, có chữ và số -> null', () {
      expect(Validators.password('abcd1234'), isNull);
      expect(Validators.password('Password1'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('không khớp -> báo lỗi, khớp -> null', () {
      final check = Validators.confirmPassword('abcd1234');
      expect(check('abcd1235'), isNotNull);
      expect(check(''), isNotNull);
      expect(check('abcd1234'), isNull);
    });
  });

  group('Validators.phone', () {
    test('trống được phép, sai định dạng báo lỗi, đúng thì null', () {
      expect(Validators.phone(''), isNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.phone('0912345678'), isNull);
      expect(Validators.phone('+84912345678'), isNull);
    });
  });
}
