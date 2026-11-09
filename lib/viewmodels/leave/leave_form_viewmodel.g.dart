// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel tải dữ liệu cho Form xin nghỉ (loading / error / data).

@ProviderFor(LeaveFormViewModel)
final leaveFormViewModelProvider = LeaveFormViewModelProvider._();

/// ViewModel tải dữ liệu cho Form xin nghỉ (loading / error / data).
final class LeaveFormViewModelProvider
    extends $AsyncNotifierProvider<LeaveFormViewModel, LeaveFormData> {
  /// ViewModel tải dữ liệu cho Form xin nghỉ (loading / error / data).
  LeaveFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveFormViewModelHash();

  @$internal
  @override
  LeaveFormViewModel create() => LeaveFormViewModel();
}

String _$leaveFormViewModelHash() =>
    r'8c4fa3175e8bc6efb9c231395a2b4dbbdac2bbff';

/// ViewModel tải dữ liệu cho Form xin nghỉ (loading / error / data).

abstract class _$LeaveFormViewModel extends $AsyncNotifier<LeaveFormData> {
  FutureOr<LeaveFormData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LeaveFormData>, LeaveFormData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LeaveFormData>, LeaveFormData>,
              AsyncValue<LeaveFormData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// ViewModel gửi đơn. State `AsyncValue<LeaveRequest?>`: null = chưa gửi,
/// có giá trị = vừa gửi thành công, error = gửi lỗi.

@ProviderFor(LeaveSubmitViewModel)
final leaveSubmitViewModelProvider = LeaveSubmitViewModelProvider._();

/// ViewModel gửi đơn. State `AsyncValue<LeaveRequest?>`: null = chưa gửi,
/// có giá trị = vừa gửi thành công, error = gửi lỗi.
final class LeaveSubmitViewModelProvider
    extends $AsyncNotifierProvider<LeaveSubmitViewModel, LeaveRequest?> {
  /// ViewModel gửi đơn. State `AsyncValue<LeaveRequest?>`: null = chưa gửi,
  /// có giá trị = vừa gửi thành công, error = gửi lỗi.
  LeaveSubmitViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveSubmitViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveSubmitViewModelHash();

  @$internal
  @override
  LeaveSubmitViewModel create() => LeaveSubmitViewModel();
}

String _$leaveSubmitViewModelHash() =>
    r'c59c700fae17aa08b963f9138f88e71cbd919074';

/// ViewModel gửi đơn. State `AsyncValue<LeaveRequest?>`: null = chưa gửi,
/// có giá trị = vừa gửi thành công, error = gửi lỗi.

abstract class _$LeaveSubmitViewModel extends $AsyncNotifier<LeaveRequest?> {
  FutureOr<LeaveRequest?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LeaveRequest?>, LeaveRequest?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LeaveRequest?>, LeaveRequest?>,
              AsyncValue<LeaveRequest?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
