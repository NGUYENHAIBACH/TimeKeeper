// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_inbox_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel của màn Hộp duyệt đơn.

@ProviderFor(ApprovalInboxViewModel)
final approvalInboxViewModelProvider = ApprovalInboxViewModelProvider._();

/// ViewModel của màn Hộp duyệt đơn.
final class ApprovalInboxViewModelProvider
    extends
        $AsyncNotifierProvider<
          ApprovalInboxViewModel,
          List<Map<String, dynamic>>
        > {
  /// ViewModel của màn Hộp duyệt đơn.
  ApprovalInboxViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalInboxViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvalInboxViewModelHash();

  @$internal
  @override
  ApprovalInboxViewModel create() => ApprovalInboxViewModel();
}

String _$approvalInboxViewModelHash() =>
    r'74c60b06e69a6f3ab18db6b1cc0ba9fa64120b56';

/// ViewModel của màn Hộp duyệt đơn.

abstract class _$ApprovalInboxViewModel
    extends $AsyncNotifier<List<Map<String, dynamic>>> {
  FutureOr<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              List<Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                List<Map<String, dynamic>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
