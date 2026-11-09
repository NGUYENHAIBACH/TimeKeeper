// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_dashboard_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel của màn Team Dashboard và xuất báo cáo.

@ProviderFor(TeamDashboardViewModel)
final teamDashboardViewModelProvider = TeamDashboardViewModelProvider._();

/// ViewModel của màn Team Dashboard và xuất báo cáo.
final class TeamDashboardViewModelProvider
    extends
        $AsyncNotifierProvider<
          TeamDashboardViewModel,
          List<Map<String, dynamic>>
        > {
  /// ViewModel của màn Team Dashboard và xuất báo cáo.
  TeamDashboardViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamDashboardViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamDashboardViewModelHash();

  @$internal
  @override
  TeamDashboardViewModel create() => TeamDashboardViewModel();
}

String _$teamDashboardViewModelHash() =>
    r'8d66c1be277e63e6983b43de94846faced4c4838';

/// ViewModel của màn Team Dashboard và xuất báo cáo.

abstract class _$TeamDashboardViewModel
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
