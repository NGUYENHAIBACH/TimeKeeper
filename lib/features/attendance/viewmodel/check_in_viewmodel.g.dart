// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel màn Check-in / Check-out bằng GPS (geofence) + vân tay.

@ProviderFor(CheckInViewModel)
final checkInViewModelProvider = CheckInViewModelProvider._();

/// ViewModel màn Check-in / Check-out bằng GPS (geofence) + vân tay.
final class CheckInViewModelProvider
    extends $AsyncNotifierProvider<CheckInViewModel, CheckInState> {
  /// ViewModel màn Check-in / Check-out bằng GPS (geofence) + vân tay.
  CheckInViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkInViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkInViewModelHash();

  @$internal
  @override
  CheckInViewModel create() => CheckInViewModel();
}

String _$checkInViewModelHash() => r'57757f45508f85588e73f4b0788dc35c6f619f6e';

/// ViewModel màn Check-in / Check-out bằng GPS (geofence) + vân tay.

abstract class _$CheckInViewModel extends $AsyncNotifier<CheckInState> {
  FutureOr<CheckInState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CheckInState>, CheckInState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckInState>, CheckInState>,
              AsyncValue<CheckInState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
