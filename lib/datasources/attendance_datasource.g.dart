// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider AttendanceDataSource (keepAlive).

@ProviderFor(attendanceDataSource)
final attendanceDataSourceProvider = AttendanceDataSourceProvider._();

/// Provider AttendanceDataSource (keepAlive).

final class AttendanceDataSourceProvider
    extends
        $FunctionalProvider<
          AttendanceDataSource,
          AttendanceDataSource,
          AttendanceDataSource
        >
    with $Provider<AttendanceDataSource> {
  /// Provider AttendanceDataSource (keepAlive).
  AttendanceDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceDataSourceHash();

  @$internal
  @override
  $ProviderElement<AttendanceDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceDataSource create(Ref ref) {
    return attendanceDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceDataSource>(value),
    );
  }
}

String _$attendanceDataSourceHash() =>
    r'f58a515a486fb697bd6b504288f21633419ae8f6';
