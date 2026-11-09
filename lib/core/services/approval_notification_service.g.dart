// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(approvalNotificationService)
final approvalNotificationServiceProvider =
    ApprovalNotificationServiceProvider._();

final class ApprovalNotificationServiceProvider
    extends
        $FunctionalProvider<
          ApprovalNotificationService,
          ApprovalNotificationService,
          ApprovalNotificationService
        >
    with $Provider<ApprovalNotificationService> {
  ApprovalNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvalNotificationServiceHash();

  @$internal
  @override
  $ProviderElement<ApprovalNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApprovalNotificationService create(Ref ref) {
    return approvalNotificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApprovalNotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApprovalNotificationService>(value),
    );
  }
}

String _$approvalNotificationServiceHash() =>
    r'cd0e3e0141d6965c76255f6f3da9733aca015ec4';
