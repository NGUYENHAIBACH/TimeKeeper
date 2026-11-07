// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `profiles.id` của người đang đăng nhập, dùng làm `employee_id`.

@ProviderFor(currentEmployeeId)
final currentEmployeeIdProvider = CurrentEmployeeIdProvider._();

/// `profiles.id` của người đang đăng nhập, dùng làm `employee_id`.

final class CurrentEmployeeIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// `profiles.id` của người đang đăng nhập, dùng làm `employee_id`.
  CurrentEmployeeIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEmployeeIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEmployeeIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return currentEmployeeId(ref);
  }
}

String _$currentEmployeeIdHash() => r'9da87bc38be599d44357c5e5f32e0a5894ab096d';

/// Ca làm của người đang đăng nhập (`profiles.shift_id` -> `shifts`).
/// Chưa được gán ca thì dùng ca hành chính.

@ProviderFor(currentShift)
final currentShiftProvider = CurrentShiftProvider._();

/// Ca làm của người đang đăng nhập (`profiles.shift_id` -> `shifts`).
/// Chưa được gán ca thì dùng ca hành chính.

final class CurrentShiftProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkShift>,
          WorkShift,
          FutureOr<WorkShift>
        >
    with $FutureModifier<WorkShift>, $FutureProvider<WorkShift> {
  /// Ca làm của người đang đăng nhập (`profiles.shift_id` -> `shifts`).
  /// Chưa được gán ca thì dùng ca hành chính.
  CurrentShiftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentShiftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentShiftHash();

  @$internal
  @override
  $FutureProviderElement<WorkShift> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WorkShift> create(Ref ref) {
    return currentShift(ref);
  }
}

String _$currentShiftHash() => r'ac24ec949d40d91aece84c09173a5e1734503160';

/// Bộ tính trạng thái ngày công theo ca hiện tại.

@ProviderFor(attendanceStatusCalculator)
final attendanceStatusCalculatorProvider =
    AttendanceStatusCalculatorProvider._();

/// Bộ tính trạng thái ngày công theo ca hiện tại.

final class AttendanceStatusCalculatorProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendanceStatusCalculator>,
          AttendanceStatusCalculator,
          FutureOr<AttendanceStatusCalculator>
        >
    with
        $FutureModifier<AttendanceStatusCalculator>,
        $FutureProvider<AttendanceStatusCalculator> {
  /// Bộ tính trạng thái ngày công theo ca hiện tại.
  AttendanceStatusCalculatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceStatusCalculatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceStatusCalculatorHash();

  @$internal
  @override
  $FutureProviderElement<AttendanceStatusCalculator> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendanceStatusCalculator> create(Ref ref) {
    return attendanceStatusCalculator(ref);
  }
}

String _$attendanceStatusCalculatorHash() =>
    r'4249ef3b559eae049cb037c366029d9d4ee1333f';

/// Có bắt xác thực vân tay khi chấm công không (Settings của TV1).

@ProviderFor(attendanceBiometricEnabled)
final attendanceBiometricEnabledProvider =
    AttendanceBiometricEnabledProvider._();

/// Có bắt xác thực vân tay khi chấm công không (Settings của TV1).

final class AttendanceBiometricEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Có bắt xác thực vân tay khi chấm công không (Settings của TV1).
  AttendanceBiometricEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceBiometricEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceBiometricEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return attendanceBiometricEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$attendanceBiometricEnabledHash() =>
    r'f7d3badf5ac4e119179ad807cf6e99ce16b4bcef';
