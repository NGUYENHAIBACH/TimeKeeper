// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_reminder_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Giữ lịch nhắc khớp với giờ trong Settings: tự đặt lại khi người dùng đổi
/// giờ, bật/tắt nhắc, đăng nhập hoặc đăng xuất. Đăng xuất thì tắt hết nhắc.
/// `MyApp` watch provider này để nó chạy suốt vòng đời app.

@ProviderFor(attendanceReminderSync)
final attendanceReminderSyncProvider = AttendanceReminderSyncProvider._();

/// Giữ lịch nhắc khớp với giờ trong Settings: tự đặt lại khi người dùng đổi
/// giờ, bật/tắt nhắc, đăng nhập hoặc đăng xuất. Đăng xuất thì tắt hết nhắc.
/// `MyApp` watch provider này để nó chạy suốt vòng đời app.

final class AttendanceReminderSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Giữ lịch nhắc khớp với giờ trong Settings: tự đặt lại khi người dùng đổi
  /// giờ, bật/tắt nhắc, đăng nhập hoặc đăng xuất. Đăng xuất thì tắt hết nhắc.
  /// `MyApp` watch provider này để nó chạy suốt vòng đời app.
  AttendanceReminderSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceReminderSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceReminderSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return attendanceReminderSync(ref);
  }
}

String _$attendanceReminderSyncHash() =>
    r'839877fc0be445cd67897a42b559497d3b3c5549';
