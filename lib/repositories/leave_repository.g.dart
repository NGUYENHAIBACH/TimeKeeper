// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider trả về interface, test override bằng bản mock.

@ProviderFor(leaveRepository)
final leaveRepositoryProvider = LeaveRepositoryProvider._();

/// Provider trả về interface, test override bằng bản mock.

final class LeaveRepositoryProvider
    extends
        $FunctionalProvider<LeaveRepository, LeaveRepository, LeaveRepository>
    with $Provider<LeaveRepository> {
  /// Provider trả về interface, test override bằng bản mock.
  LeaveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveRepository create(Ref ref) {
    return leaveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveRepository>(value),
    );
  }
}

String _$leaveRepositoryHash() => r'a50c78b705086c9fa9d307f16f6c6f3924c130e0';
