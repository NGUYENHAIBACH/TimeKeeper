import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/datasources/ot_datasource.dart';

part 'ot_repository.g.dart';

class OtRepository {
  OtRepository(this._dataSource);

  final OtDataSource _dataSource;

  Future<List<DateTime>> getHolidays() {
    return _dataSource.getHolidays();
  }
}

@Riverpod(keepAlive: true)
OtRepository otRepository(Ref ref) {
  return OtRepository(ref.watch(otDataSourceProvider));
}