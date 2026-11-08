// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_reminder_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service đặt thông báo nhắc check-in / check-out hằng ngày.

@ProviderFor(attendanceReminderService)
final attendanceReminderServiceProvider = AttendanceReminderServiceProvider._();

/// Service đặt thông báo nhắc check-in / check-out hằng ngày.

final class AttendanceReminderServiceProvider
    extends
        $FunctionalProvider<
          AttendanceReminderService,
          AttendanceReminderService,
          AttendanceReminderService
        >
    with $Provider<AttendanceReminderService> {
  /// Service đặt thông báo nhắc check-in / check-out hằng ngày.
  AttendanceReminderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceReminderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceReminderServiceHash();

  @$internal
  @override
  $ProviderElement<AttendanceReminderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceReminderService create(Ref ref) {
    return attendanceReminderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceReminderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceReminderService>(value),
    );
  }
}

String _$attendanceReminderServiceHash() =>
    r'ce184d01a7193539cf0d28ce3375066111d5a32c';
