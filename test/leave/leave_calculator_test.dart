import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/models/leave_request.dart';

import 'leave_fakes.dart';

void main() {
  // 09/11/2026 là thứ Hai, 14-15/11/2026 là cuối tuần.
  final mon = DateTime(2026, 11, 9);
  final fri = DateTime(2026, 11, 13);
  final sat = DateTime(2026, 11, 14);
  final nextMon = DateTime(2026, 11, 16);

  group('countDays', () {
    test('thứ Hai đến thứ Sáu = 5 ngày', () {
      expect(LeaveCalculator.countDays(start: mon, end: fri), 5);
    });

    test('bỏ qua cuối tuần', () {
      expect(LeaveCalculator.countDays(start: fri, end: nextMon), 2);
    });

    test('bỏ qua ngày lễ', () {
      // 02/09/2026 (thứ Tư) là Quốc khánh.
      final days = LeaveCalculator.countDays(
        start: DateTime(2026, 8, 31),
        end: DateTime(2026, 9, 4),
        holidays: [DateTime(2026, 9, 2)],
      );
      expect(days, 4);
    });

    test('nửa ngày = 0.5 nếu là ngày làm việc', () {
      expect(LeaveCalculator.countDays(start: mon, end: mon, halfDay: HalfDay.morning), 0.5);
      expect(LeaveCalculator.countDays(start: sat, end: sat, halfDay: HalfDay.afternoon), 0);
    });

    test('nửa ngày nhưng chọn nhiều ngày thì không hợp lệ (0)', () {
      expect(LeaveCalculator.countDays(start: mon, end: fri, halfDay: HalfDay.morning), 0);
    });

    test('ngày kết thúc trước ngày bắt đầu = 0', () {
      expect(LeaveCalculator.countDays(start: fri, end: mon), 0);
    });

    test('bỏ qua phần giờ', () {
      expect(
        LeaveCalculator.countDays(start: DateTime(2026, 11, 9, 23), end: DateTime(2026, 11, 10, 1)),
        2,
      );
    });
  });

  group('availableDays', () {
    test('trừ số ngày của đơn đang chờ', () {
      final pending = [request('1', start: mon, days: 2), request('2', start: fri, days: 0.5)];
      expect(LeaveCalculator.availableDays(remainingDays: 10, pendingRequests: pending), 7.5);
    });

    test('không âm', () {
      final pending = [request('1', start: mon, days: 5)];
      expect(LeaveCalculator.availableDays(remainingDays: 3, pendingRequests: pending), 0);
    });
  });

  group('validate', () {
    String? v({
      DateTime? start,
      DateTime? end,
      HalfDay half = HalfDay.none,
      double days = 1,
      double? available = 10,
      bool requiresDoc = false,
      bool hasFile = false,
      List<LeaveRequest> existing = const [],
    }) =>
        LeaveCalculator.validate(
          start: start ?? mon,
          end: end ?? start ?? mon,
          halfDay: half,
          days: days,
          available: available,
          requiresDocument: requiresDoc,
          hasAttachment: hasFile,
          existing: existing,
        );

    test('hợp lệ trả null', () => expect(v(), isNull));

    test('ngày kết thúc trước ngày bắt đầu', () {
      expect(v(start: fri, end: mon), contains('Ngày kết thúc'));
    });

    test('không có ngày làm việc', () {
      expect(v(start: sat, days: 0), contains('không có ngày làm việc'));
    });

    test('vượt số dư', () {
      expect(v(days: 3, available: 2), 'Vượt số dư phép: cần 3 ngày, chỉ còn 2 ngày');
    });

    test('phép không lương (available = null) không giới hạn', () {
      expect(v(days: 40, available: null), isNull);
    });

    test('bắt buộc đính kèm', () {
      expect(v(requiresDoc: true), contains('đính kèm'));
      expect(v(requiresDoc: true, hasFile: true), isNull);
    });

    test('trùng với đơn đang chờ / đã duyệt', () {
      final existing = [request('1', start: mon, end: fri, status: LeaveStatus.approved)];
      expect(v(start: DateTime(2026, 11, 11), existing: existing), contains('trùng'));
    });

    test('đơn đã hủy / từ chối không tính trùng', () {
      final existing = [
        request('1', start: mon, status: LeaveStatus.cancelled),
        request('2', start: mon, status: LeaveStatus.rejected),
      ];
      expect(v(existing: existing), isNull);
    });

    test('hai đơn nửa ngày khác buổi cùng ngày không trùng', () {
      final existing = [request('1', start: mon, halfDay: HalfDay.morning, days: 0.5)];
      expect(v(half: HalfDay.afternoon, days: 0.5, existing: existing), isNull);
      expect(v(half: HalfDay.morning, days: 0.5, existing: existing), contains('trùng'));
    });
  });

  test('formatDays', () {
    expect(LeaveCalculator.formatDays(2), '2');
    expect(LeaveCalculator.formatDays(1.5), '1.5');
  });
}
