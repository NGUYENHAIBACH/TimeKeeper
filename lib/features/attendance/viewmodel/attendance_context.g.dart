// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `profiles.id` của người đang đăng nhập.
///
/// TẠM THỜI trả về [devEmployeeId] vì TV1 chưa làm đăng nhập. Khi có
/// `profileViewModelProvider` thì đổi thân hàm thành id từ đó; các
/// ViewModel chấm công không phải sửa gì.

@ProviderFor(currentEmployeeId)
final currentEmployeeIdProvider = CurrentEmployeeIdProvider._();

/// `profiles.id` của người đang đăng nhập.
///
/// TẠM THỜI trả về [devEmployeeId] vì TV1 chưa làm đăng nhập. Khi có
/// `profileViewModelProvider` thì đổi thân hàm thành id từ đó; các
/// ViewModel chấm công không phải sửa gì.

final class CurrentEmployeeIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// `profiles.id` của người đang đăng nhập.
  ///
  /// TẠM THỜI trả về [devEmployeeId] vì TV1 chưa làm đăng nhập. Khi có
  /// `profileViewModelProvider` thì đổi thân hàm thành id từ đó; các
  /// ViewModel chấm công không phải sửa gì.
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentEmployeeId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentEmployeeIdHash() => r'6c1668eb63f39be8330ac257588d1bfa4bf68b0c';

/// Ca làm của người đang đăng nhập.
///
/// TẠM THỜI dùng ca hành chính. Sau này đọc từ `profiles.shift_id` -> `shifts`.

@ProviderFor(currentShift)
final currentShiftProvider = CurrentShiftProvider._();

/// Ca làm của người đang đăng nhập.
///
/// TẠM THỜI dùng ca hành chính. Sau này đọc từ `profiles.shift_id` -> `shifts`.

final class CurrentShiftProvider
    extends $FunctionalProvider<WorkShift, WorkShift, WorkShift>
    with $Provider<WorkShift> {
  /// Ca làm của người đang đăng nhập.
  ///
  /// TẠM THỜI dùng ca hành chính. Sau này đọc từ `profiles.shift_id` -> `shifts`.
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
  $ProviderElement<WorkShift> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkShift create(Ref ref) {
    return currentShift(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkShift value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkShift>(value),
    );
  }
}

String _$currentShiftHash() => r'7c4cbf0775ab71366459745a25e4ffca04096409';

/// Bộ tính trạng thái ngày công theo ca hiện tại.

@ProviderFor(attendanceStatusCalculator)
final attendanceStatusCalculatorProvider =
    AttendanceStatusCalculatorProvider._();

/// Bộ tính trạng thái ngày công theo ca hiện tại.

final class AttendanceStatusCalculatorProvider
    extends
        $FunctionalProvider<
          AttendanceStatusCalculator,
          AttendanceStatusCalculator,
          AttendanceStatusCalculator
        >
    with $Provider<AttendanceStatusCalculator> {
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
  $ProviderElement<AttendanceStatusCalculator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceStatusCalculator create(Ref ref) {
    return attendanceStatusCalculator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceStatusCalculator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceStatusCalculator>(value),
    );
  }
}

String _$attendanceStatusCalculatorHash() =>
    r'c5b98923bf1daf9d3ed9da2aa427e979ddacb6dd';

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
