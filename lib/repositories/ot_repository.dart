import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/datasources/ot_datasource.dart';
import 'package:timekeeper/models/ot_request.dart';

part 'ot_repository.g.dart';

class OtRepository {
  OtRepository(this._dataSource);

  final OtDataSource _dataSource;

  Future<List<DateTime>> getHolidays() {
    return _dataSource.getHolidays();
  }

  Future<void> createRequest({
    required String employeeId,
    required DateTime start,
    required DateTime end,
    required double hours,
    required String otType,
    required double multiplier,
    required String reason,
  }) {
    return _dataSource.createRequest(
      employeeId: employeeId,
      start: start,
      end: end,
      hours: hours,
      otType: otType,
      multiplier: multiplier,
      reason: reason,
    );
  }

  Future<List<OtRequest>> getMyRequests(String employeeId) async {
    final rows = await _dataSource.getRequestsByEmployee(employeeId);
    return rows.map(OtRequest.fromJson).toList();
  }

  Future<bool> cancelRequest({
    required String requestId,
    required String employeeId,
  }) {
    return _dataSource.cancelRequest(
      requestId: requestId,
      employeeId: employeeId,
    );
  }
}

@Riverpod(keepAlive: true)
OtRepository otRepository(Ref ref) {
  return OtRepository(ref.watch(otDataSourceProvider));
}
