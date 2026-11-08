import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/ot_request.dart';
import 'package:timekeeper/viewmodels/overtime/ot_list_viewmodel.dart';

void main() {
  test('lọc đơn theo tháng và trạng thái', () {
    final state = OtListState(
      employeeId: 'employee-1',
      selectedMonth: DateTime(2026, 11),
      selectedStatus: 'approved',
      requests: [
        _request(id: '1', date: DateTime(2026, 11, 1), status: 'approved'),
        _request(id: '2', date: DateTime(2026, 11, 2), status: 'pending'),
        _request(id: '3', date: DateTime(2026, 10, 1), status: 'approved'),
      ],
    );

    expect(state.filteredRequests.map((item) => item.id), ['1']);
  });

  test('bỏ lọc tháng vẫn giữ bộ lọc trạng thái', () {
    final state = OtListState(
      employeeId: 'employee-1',
      selectedMonth: DateTime(2026, 11),
      selectedStatus: 'approved',
      requests: [
        _request(id: '1', date: DateTime(2026, 11, 1), status: 'approved'),
        _request(id: '2', date: DateTime(2026, 10, 1), status: 'approved'),
      ],
    ).copyWith(clearMonth: true);

    expect(state.filteredRequests.length, 2);
  });
}

OtRequest _request({
  required String id,
  required DateTime date,
  required String status,
}) {
  return OtRequest(
    id: id,
    employeeId: 'employee-1',
    otDate: date,
    startTime: '18:00:00',
    endTime: '20:00:00',
    hours: 2,
    otType: 'weekday',
    multiplier: 1.5,
    paidHours: 3,
    reason: 'Test',
    status: status,
    createdAt: date,
  );
}
