import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/office_location.dart';
import 'package:timekeeper/models/work_shift.dart';

void main() {
  group('AttendanceRecord map', () {
    final record = AttendanceRecord(
      id: 'r1',
      employeeId: 'e1',
      workDate: DateTime(2026, 11, 2),
      checkInAt: DateTime(2026, 11, 2, 8, 3),
      checkOutAt: DateTime(2026, 11, 2, 17, 10),
      checkInLat: 10.84,
      checkInLng: 106.8,
      lateMinutes: 3,
      workHours: 9.1166,
      synced: false,
    );

    test('toRemote dùng tên cột Supabase, giờ ở dạng UTC, không có synced', () {
      final m = record.toRemote();
      expect(m['employee_id'], 'e1');
      expect(m['work_date'], '2026-11-02');
      expect(m['check_in_at'], endsWith('Z'));
      expect(m['work_hours'], 9.12);
      expect(m['status'], 'present');
      expect(m.containsKey('synced'), isFalse);
    });

    test('đọc lại từ SQLite giữ nguyên giờ địa phương và cờ synced', () {
      final back = AttendanceRecord.fromMap(record.toLocal());
      expect(back.checkInAt, record.checkInAt);
      expect(back.checkOutAt, record.checkOutAt);
      expect(back.synced, isFalse);
      expect(back.isMockedLocation, isFalse);
    });

    test('dòng từ Supabase (giờ +00:00, không có synced) coi như đã đồng bộ', () {
      final r = AttendanceRecord.fromMap({
        'id': 'r2',
        'employee_id': 'e1',
        'work_date': '2026-11-02',
        'check_in_at': '2026-11-02T01:00:00+00:00',
        'late_minutes': 0,
        'work_hours': 0,
        'status': 'late',
        'is_mocked_location': false,
      });
      expect(r.synced, isTrue);
      expect(r.status, AttendanceRecordStatus.late);
      expect(r.checkInAt!.isAtSameMomentAs(DateTime.utc(2026, 11, 2, 1)), isTrue);
    });
  });

  test('AttendanceCorrection đọc lại đúng trạng thái và giờ', () {
    final c = AttendanceCorrection(
      id: 'c1',
      employeeId: 'e1',
      workDate: DateTime(2026, 11, 2),
      requestedCheckOut: DateTime(2026, 11, 2, 17, 30),
      reason: 'Quên check-out do họp muộn',
      status: CorrectionStatus.rejected,
      rejectReason: 'Không đúng',
      createdAt: DateTime(2026, 11, 3, 9),
    );
    final back = AttendanceCorrection.fromMap(c.toLocal());
    expect(back, c);
  });

  test('OfficeLocation đọc is_active dạng 0/1 của SQLite', () {
    const o = OfficeLocation(id: 'o', name: 'VP', latitude: 1, longitude: 2, radiusMeters: 150);
    final back = OfficeLocation.fromMap(o.toLocal());
    expect(back, o);
  });

  test('WorkShift đọc dòng shifts của Supabase (giờ HH:mm:ss) và đọc lại từ SQLite', () {
    final s = WorkShift.fromMap({
      'id': 's1',
      'name': 'Ca chieu',
      'start_time': '14:00:00',
      'end_time': '22:00:00',
      'grace_minutes': 10,
    });
    expect((s.startHour, s.startMinute, s.endHour, s.lateGraceMinutes), (14, 0, 22, 10));
    final back = WorkShift.fromMap(s.toLocal());
    expect((back.id, back.startHour, back.endHour, back.lateGraceMinutes), ('s1', 14, 22, 10));
    // Vào 14:08 với ca chiều (cho trễ 10 phút) thì không tính muộn.
    final calc = AttendanceStatusCalculator(shift: s);
    expect(calc.isLateAt(DateTime(2026, 11, 2, 14, 8)), isFalse);
    expect(calc.lateMinutesAt(DateTime(2026, 11, 2, 14, 30)), 30);
  });

  group('AttendanceStatusCalculator - phút muộn / về sớm', () {
    const calc = AttendanceStatusCalculator();
    test('vào 08:20 muộn 20 phút, ra 16:45 về sớm 15 phút', () {
      expect(calc.lateMinutesAt(DateTime(2026, 11, 2, 8, 20)), 20);
      expect(calc.isLateAt(DateTime(2026, 11, 2, 8, 20)), isTrue);
      expect(calc.isLateAt(DateTime(2026, 11, 2, 8, 5)), isFalse);
      expect(calc.earlyLeaveMinutesAt(DateTime(2026, 11, 2, 16, 45)), 15);
      expect(calc.earlyLeaveMinutesAt(DateTime(2026, 11, 2, 17, 30)), 0);
    });
  });
}
