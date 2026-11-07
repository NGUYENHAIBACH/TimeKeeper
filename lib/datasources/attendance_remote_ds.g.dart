// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_remote_ds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DataSource Supabase cho chấm công.

@ProviderFor(attendanceRemoteDataSource)
final attendanceRemoteDataSourceProvider =
    AttendanceRemoteDataSourceProvider._();

/// DataSource Supabase cho chấm công.

final class AttendanceRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AttendanceRemoteDataSource,
          AttendanceRemoteDataSource,
          AttendanceRemoteDataSource
        >
    with $Provider<AttendanceRemoteDataSource> {
  /// DataSource Supabase cho chấm công.
  AttendanceRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AttendanceRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceRemoteDataSource create(Ref ref) {
    return attendanceRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceRemoteDataSource>(value),
    );
  }
}

String _$attendanceRemoteDataSourceHash() =>
    r'ac6a6a1f64c4fd66b0ccf39981ec2ec95b2185b4';
