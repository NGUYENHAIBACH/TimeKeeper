// Unit test phần logic thuần của repository Dashboard và tiện ích ngày giờ.

import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/monthly_summary.dart';
import 'package:timekeeper/repositories/leave_repository.dart';

void main() {
  group('MonthlySummary.fromRecords', () {
    test('cộng giờ, đếm ngày công và ngày trễ', () {
      final records = [
        AttendanceRecord.fromMap(const {
          'id': '1',
          'employee_id': 'e1',
          'work_date': '2026-11-02',
          'check_in_at': '2026-11-02T01:00:00Z',
          'check_out_at': '2026-11-02T10:00:00Z',
          'work_hours': 8,
          'late_minutes': 0,
          'status': 'present',
        }),
        AttendanceRecord.fromMap(const {
          'id': '2',
          'employee_id': 'e1',
          'work_date': '2026-11-03',
          'check_in_at': '2026-11-03T01:20:00Z',
          'check_out_at': '2026-11-03T10:00:00Z',
          'work_hours': 7.5,
          'late_minutes': 15,
          'status': 'late',
        }),
        // Ngày vắng: không check-in, không tính ngày công.
        AttendanceRecord.fromMap(const {
          'id': '3',
          'employee_id': 'e1',
          'work_date': '2026-11-04',
          'status': 'absent',
        }),
      ];

      final s = MonthlySummary.fromRecords(records);

      expect(s.totalHours, 15.5);
      expect(s.workDays, 2);
      expect(s.lateDays, 1);
    });

    test('danh sách rỗng -> tất cả bằng 0', () {
      final s = MonthlySummary.fromRecords(const []);
      expect(s.totalHours, 0);
      expect(s.workDays, 0);
      expect(s.lateDays, 0);
    });
  });

  group('SupabaseLeaveRepository.pickAnnual', () {
    test('chọn đúng dòng phép năm trong nhiều loại phép', () {
      final b = SupabaseLeaveRepository.pickAnnual([
        {'total_days': 30, 'used_days': 1, 'leave_types': {'code': 'sick'}},
        {'total_days': 12, 'used_days': 3.5, 'leave_types': {'code': 'annual'}},
      ]);
      expect(b.totalDays, 12);
      expect(b.usedDays, 3.5);
      expect(b.remainingDays, 8.5);
    });

    test('không có phép năm -> 0', () {
      final b = SupabaseLeaveRepository.pickAnnual([
        {'total_days': 30, 'used_days': 0, 'leave_types': {'code': 'sick'}},
      ]);
      expect(b.remainingDays, 0);
    });
  });

  group('Profile.fromJson', () {
    test('map đúng cột snake_case và role', () {
      final p = Profile.fromJson(const {
        'id': 'p1',
        'firebase_uid': 'uid1',
        'email': 'a@b.vn',
        'full_name': 'A',
        'phone': null,
        'avatar_url': null,
        'role': 'manager',
        'department_id': 'd1',
        'manager_id': null,
        'shift_id': null,
        'created_at': '2026-11-05T00:00:00Z',
        'updated_at': '2026-11-05T00:00:00Z',
      });
      expect(p.firebaseUid, 'uid1');
      expect(p.fullName, 'A');
      expect(p.role, UserRole.manager);
      expect(p.departmentId, 'd1');
    });
  });

  group('AppDateUtils', () {
    test('toDateString thêm số 0 đầu', () {
      expect(AppDateUtils.toDateString(DateTime(2026, 1, 5)), '2026-01-05');
    });

    test('ngày đầu và cuối tháng (kể cả tháng 2, tháng 12)', () {
      expect(AppDateUtils.firstDayOfMonth(DateTime(2026, 11, 20)), DateTime(2026, 11));
      expect(AppDateUtils.lastDayOfMonth(DateTime(2026, 2, 10)), DateTime(2026, 2, 28));
      expect(AppDateUtils.lastDayOfMonth(DateTime(2026, 12, 1)), DateTime(2026, 12, 31));
    });

    test('parse / format HH:mm', () {
      expect(AppDateUtils.parseHourMinute('07:45'), (7, 45));
      expect(AppDateUtils.parseHourMinute('25:00'), isNull);
      expect(AppDateUtils.parseHourMinute('abc'), isNull);
      expect(AppDateUtils.parseHourMinute(null), isNull);
      expect(AppDateUtils.formatHourMinute(7, 5), '07:05');
    });
  });
}
