// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_center_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel của màn Trung tâm thông báo.

@ProviderFor(NotificationCenterViewModel)
final notificationCenterViewModelProvider =
    NotificationCenterViewModelProvider._();

/// ViewModel của màn Trung tâm thông báo.
final class NotificationCenterViewModelProvider
    extends
        $AsyncNotifierProvider<
          NotificationCenterViewModel,
          List<Map<String, dynamic>>
        > {
  /// ViewModel của màn Trung tâm thông báo.
  NotificationCenterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCenterViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCenterViewModelHash();

  @$internal
  @override
  NotificationCenterViewModel create() => NotificationCenterViewModel();
}

String _$notificationCenterViewModelHash() =>
    r'fdbcc513e5a52115ee8ac27afc39a3956206a2cd';

/// ViewModel của màn Trung tâm thông báo.

abstract class _$NotificationCenterViewModel
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
