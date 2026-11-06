// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_local_ds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mở SQLite chấm công một lần cho cả app.

@ProviderFor(attendanceLocalDataSource)
final attendanceLocalDataSourceProvider = AttendanceLocalDataSourceProvider._();

/// Mở SQLite chấm công một lần cho cả app.

final class AttendanceLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendanceLocalDataSource>,
          AttendanceLocalDataSource,
          FutureOr<AttendanceLocalDataSource>
        >
    with
        $FutureModifier<AttendanceLocalDataSource>,
        $FutureProvider<AttendanceLocalDataSource> {
  /// Mở SQLite chấm công một lần cho cả app.
  AttendanceLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceLocalDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<AttendanceLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendanceLocalDataSource> create(Ref ref) {
    return attendanceLocalDataSource(ref);
  }
}

String _$attendanceLocalDataSourceHash() =>
    r'692d04d01fc5e308b0ffd1726e61fbe9a7086537';
