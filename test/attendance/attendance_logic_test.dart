import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/core/utils/correction_validator.dart';
import 'package:timekeeper/core/utils/geo_fence.dart';
import 'package:timekeeper/data/models/attendance_correction.dart';
import 'package:timekeeper/data/models/attendance_record.dart';
import 'package:flutter_test/flutter_test.dart';

AttendanceRecord rec(DateTime day, {DateTime? inAt, DateTime? outAt}) =>
    AttendanceRecord(
      id: 'x',
      employeeId: 'u',
      workDate: day,
      checkInAt: inAt,
      checkOutAt: outAt,
    );

void main() {
  const calc = AttendanceStatusCalculator();
  // Thứ Hai 02/11/2026
  final monday = DateTime(2026, 11, 2);
  DateTime at(int h, int m) => DateTime(2026, 11, 2, h, m);
  final later = DateTime(2026, 11, 10, 9);

  group('AttendanceStatusCalculator', () {
    test('vào trước 08:05, ra 17:00 là đúng giờ', () {
      final r = rec(monday, inAt: at(8, 5), outAt: at(17, 0));
      expect(calc.statusFor(day: monday, record: r, now: later),
          AttendanceStatus.onTime);
    });

    test('vào 08:06 là đi muộn, muộn 6 phút', () {
      final r = rec(monday, inAt: at(8, 6), outAt: at(17, 0));
      expect(calc.statusFor(day: monday, record: r, now: later),
          AttendanceStatus.late);
      expect(calc.lateMinutes(r), 6);
    });

    test('ra sau 17:30 là có tăng ca', () {
      final r = rec(monday, inAt: at(7, 55), outAt: at(17, 31));
      expect(calc.statusFor(day: monday, record: r, now: later),
          AttendanceStatus.overtime);
    });

    test('ngày cũ không check-out là thiếu check-out', () {
      final r = rec(monday, inAt: at(8, 0));
      expect(calc.statusFor(day: monday, record: r, now: later),
          AttendanceStatus.missingCheckOut);
    });

    test('hôm nay chưa check-out là đang làm', () {
      final r = rec(monday, inAt: at(8, 0));
      expect(calc.statusFor(day: monday, record: r, now: at(10, 0)),
          AttendanceStatus.inProgress);
    });

    test('ngày thường không có bản ghi là vắng, cuối tuần là ngày nghỉ', () {
      expect(calc.statusFor(day: monday, record: null, now: later),
          AttendanceStatus.absent);
      expect(
          calc.statusFor(day: DateTime(2026, 11, 7), record: null, now: later),
          AttendanceStatus.dayOff);
    });

    test('hôm nay chưa hết ca thì chưa tính vắng', () {
      expect(calc.statusFor(day: monday, record: null, now: at(9, 0)),
          AttendanceStatus.upcoming);
    });
  });

  group('GeoFence', () {
    test('cùng một điểm cách 0 m', () {
      expect(GeoFence.distanceMeters(21.0, 105.0, 21.0, 105.0), 0);
    });

    test('lệch 0.001 độ vĩ khoảng 111 m, ngoài bán kính 100 m', () {
      final d = GeoFence.distanceMeters(21.0, 105.0, 21.001, 105.0);
      expect(d, closeTo(111, 1));
      expect(GeoFence.isInside(distanceMeters: d, radiusMeters: 100), isFalse);
    });
  });

  group('CorrectionValidator', () {
    test('đơn hợp lệ không có lỗi', () {
      final errors = CorrectionValidator.validate(
        workDate: monday,
        checkIn: at(8, 0),
        checkOut: at(17, 0),
        reason: 'Quên check-out do họp muộn',
        now: later,
      );
      expect(errors, isEmpty);
    });

    test('thiếu giờ, lý do ngắn, giờ ra trước giờ vào đều báo lỗi', () {
      expect(
        CorrectionValidator.validate(
            workDate: monday, checkIn: null, checkOut: null, reason: 'abc', now: later),
        hasLength(2),
      );
      expect(
        CorrectionValidator.validate(
          workDate: monday,
          checkIn: at(17, 0),
          checkOut: at(8, 0),
          reason: 'Lý do đủ dài ở đây',
          now: later,
        ),
        contains('Giờ ra phải sau giờ vào.'),
      );
    });

    test('không cho gửi thêm khi đã có đơn đang chờ', () {
      final pending = AttendanceCorrection(
        id: 'c',
        employeeId: 'u',
        workDate: monday,
        reason: 'abc',
        createdAt: later,
      );
      final errors = CorrectionValidator.validate(
        workDate: monday,
        checkIn: at(8, 0),
        checkOut: null,
        reason: 'Lý do đủ dài ở đây',
        now: later,
        existing: [pending],
      );
      expect(errors, contains('Ngày này đã có đơn đang chờ duyệt.'));
    });
  });
}
