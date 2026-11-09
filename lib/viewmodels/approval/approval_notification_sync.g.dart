// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_notification_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Starts/stops notification infrastructure with the authenticated profile.

@ProviderFor(approvalNotificationSync)
final approvalNotificationSyncProvider = ApprovalNotificationSyncProvider._();

/// Starts/stops notification infrastructure with the authenticated profile.

final class ApprovalNotificationSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Starts/stops notification infrastructure with the authenticated profile.
  ApprovalNotificationSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalNotificationSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvalNotificationSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return approvalNotificationSync(ref);
  }
}

String _$approvalNotificationSyncHash() =>
    r'6355ed58225273a06f6b87ddefab4ede1029d9f4';

@ProviderFor(approvalNotificationOpenEvents)
final approvalNotificationOpenEventsProvider =
    ApprovalNotificationOpenEventsProvider._();

final class ApprovalNotificationOpenEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          Stream<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $StreamProvider<Map<String, dynamic>> {
  ApprovalNotificationOpenEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalNotificationOpenEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvalNotificationOpenEventsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, dynamic>> create(Ref ref) {
    return approvalNotificationOpenEvents(ref);
  }
}

String _$approvalNotificationOpenEventsHash() =>
    r'50ce3c063993478d04565aa650b85199e169454d';

@ProviderFor(approvalNotificationRealtimeEvents)
final approvalNotificationRealtimeEventsProvider =
    ApprovalNotificationRealtimeEventsProvider._();

final class ApprovalNotificationRealtimeEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          Stream<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $StreamProvider<Map<String, dynamic>> {
  ApprovalNotificationRealtimeEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalNotificationRealtimeEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$approvalNotificationRealtimeEventsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, dynamic>> create(Ref ref) {
    return approvalNotificationRealtimeEvents(ref);
  }
}

String _$approvalNotificationRealtimeEventsHash() =>
    r'4e8a8a023eaf47981e8ce5747c2972909f294378';
