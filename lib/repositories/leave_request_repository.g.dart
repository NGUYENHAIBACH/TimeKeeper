// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider LeaveRequestRepository (keepAlive).

@ProviderFor(leaveRequestRepository)
final leaveRequestRepositoryProvider = LeaveRequestRepositoryProvider._();

/// Provider LeaveRequestRepository (keepAlive).

final class LeaveRequestRepositoryProvider
    extends
        $FunctionalProvider<
          LeaveRequestRepository,
          LeaveRequestRepository,
          LeaveRequestRepository
        >
    with $Provider<LeaveRequestRepository> {
  /// Provider LeaveRequestRepository (keepAlive).
  LeaveRequestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveRequestRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveRequestRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaveRequestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LeaveRequestRepository create(Ref ref) {
    return leaveRequestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveRequestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveRequestRepository>(value),
    );
  }
}

String _$leaveRequestRepositoryHash() =>
    r'07fe88d639e299eb0c2e4402e139dccbd3ba5437';
