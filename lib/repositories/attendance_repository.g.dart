// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository chấm công dùng cho cả app.

@ProviderFor(attendanceRepository)
final attendanceRepositoryProvider = AttendanceRepositoryProvider._();

/// Repository chấm công dùng cho cả app.

final class AttendanceRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendanceRepository>,
          AttendanceRepository,
          FutureOr<AttendanceRepository>
        >
    with
        $FutureModifier<AttendanceRepository>,
        $FutureProvider<AttendanceRepository> {
  /// Repository chấm công dùng cho cả app.
  AttendanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AttendanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendanceRepository> create(Ref ref) {
    return attendanceRepository(ref);
  }
}

String _$attendanceRepositoryHash() =>
    r'cc42ac042745b47401a91bf288a601b32105a5b5';
