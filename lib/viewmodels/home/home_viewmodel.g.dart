// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel màn Home Dashboard.
/// Gom hồ sơ (TV1) + chấm công hôm nay và tổng giờ tháng (TV2) + số phép
/// còn (TV4) thành một [HomeDashboard]. Trả null khi chưa đăng nhập.
///
/// autoDispose: rời Home là giải phóng, quay lại sẽ tải dữ liệu mới.

@ProviderFor(HomeViewModel)
final homeViewModelProvider = HomeViewModelProvider._();

/// ViewModel màn Home Dashboard.
/// Gom hồ sơ (TV1) + chấm công hôm nay và tổng giờ tháng (TV2) + số phép
/// còn (TV4) thành một [HomeDashboard]. Trả null khi chưa đăng nhập.
///
/// autoDispose: rời Home là giải phóng, quay lại sẽ tải dữ liệu mới.
final class HomeViewModelProvider
    extends $AsyncNotifierProvider<HomeViewModel, HomeDashboard?> {
  /// ViewModel màn Home Dashboard.
  /// Gom hồ sơ (TV1) + chấm công hôm nay và tổng giờ tháng (TV2) + số phép
  /// còn (TV4) thành một [HomeDashboard]. Trả null khi chưa đăng nhập.
  ///
  /// autoDispose: rời Home là giải phóng, quay lại sẽ tải dữ liệu mới.
  HomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();
}

String _$homeViewModelHash() => r'cf140147158d7ae10a1faba5684d2645f35482ef';

/// ViewModel màn Home Dashboard.
/// Gom hồ sơ (TV1) + chấm công hôm nay và tổng giờ tháng (TV2) + số phép
/// còn (TV4) thành một [HomeDashboard]. Trả null khi chưa đăng nhập.
///
/// autoDispose: rời Home là giải phóng, quay lại sẽ tải dữ liệu mới.

abstract class _$HomeViewModel extends $AsyncNotifier<HomeDashboard?> {
  FutureOr<HomeDashboard?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeDashboard?>, HomeDashboard?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeDashboard?>, HomeDashboard?>,
              AsyncValue<HomeDashboard?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
