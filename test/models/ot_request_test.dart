import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/ot_request.dart';

void main() {
  group('OtRequest.fromJson', () {
    test('ánh xạ đúng dữ liệu từ Supabase', () {
      final request = OtRequest.fromJson({
        'id': 'request-1',
        'employee_id': 'employee-1',
        'ot_date': '2026-11-15',
        'start_time': '18:00:00',
        'end_time': '20:30:00',
        'hours': 2.5,
        'ot_type': 'weekend',
        'multiplier': 2,
        'paid_hours': 5,
        'reason': 'Hoàn thành sprint',
        'status': 'pending',
        'approved_by': null,
        'approved_at': null,
        'reject_reason': null,
        'created_at': '2026-11-08T04:52:26.531495+00:00',
      });

      expect(request.otDate, DateTime(2026, 11, 15));
      expect(request.hours, 2.5);
      expect(request.multiplier, 2);
      expect(request.paidHours, 5);
      expect(request.timeRange, '18:00 - 20:30');
    });
  });
}
