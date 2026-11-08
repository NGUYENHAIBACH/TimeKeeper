import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/ot_request.dart';
import 'package:timekeeper/viewmodels/overtime/ot_report_summary.dart';

void main() {
  group('OtReportSummary', () {
    test('chỉ cộng giờ của đơn đã duyệt trong đúng năm', () {
      final summary = OtReportSummary.fromRequests([
        _request(
          id: '1',
          date: DateTime(2026, 1, 10),
          status: 'approved',
          hours: 2,
          paidHours: 3,
        ),
        _request(
          id: '2',
          date: DateTime(2026, 1, 12),
          status: 'pending',
          hours: 3,
          paidHours: 6,
        ),
        _request(
          id: '3',
          date: DateTime(2026, 2, 5),
          status: 'approved',
          hours: 4,
          paidHours: 8,
        ),
        _request(
          id: '4',
          date: DateTime(2025, 12, 5),
          status: 'approved',
          hours: 10,
          paidHours: 15,
        ),
      ], year: 2026);

      expect(summary.approvedCount, 2);
      expect(summary.pendingCount, 1);
      expect(summary.actualHours, 6);
      expect(summary.paidHours, 11);
      expect(summary.monthlyHours[0], 2);
      expect(summary.monthlyHours[1], 4);
      expect(summary.monthlyHours.skip(2), everyElement(0));
    });

    test('ước tính tiền bằng giờ quy đổi nhân lương giờ', () {
      final summary = OtReportSummary.fromRequests([
        _request(
          id: '1',
          date: DateTime(2026, 1, 10),
          status: 'approved',
          hours: 2,
          paidHours: 3,
        ),
      ], year: 2026);

      expect(summary.estimatePay(50000), 150000);
      expect(summary.estimatePay(0), 0);
    });
  });
}

OtRequest _request({
  required String id,
  required DateTime date,
  required String status,
  required double hours,
  required double paidHours,
}) {
  return OtRequest(
    id: id,
    employeeId: 'employee-1',
    otDate: date,
    startTime: '18:00:00',
    endTime: '20:00:00',
    hours: hours,
    otType: 'weekday',
    multiplier: 1.5,
    paidHours: paidHours,
    reason: 'Test',
    status: status,
    createdAt: date,
  );
}
