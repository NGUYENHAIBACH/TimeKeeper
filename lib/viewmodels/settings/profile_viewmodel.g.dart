// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hồ sơ của người đang đăng nhập. Mọi module khác lấy `employee_id`,
/// role, phòng ban, ca làm từ đây: `ref.watch(profileViewModelProvider)`.
///
/// keepAlive vì được dùng ở hầu hết màn hình; tự tải lại khi `authState`
/// đổi (đăng nhập / đăng xuất) nhờ `ref.watch`.

@ProviderFor(ProfileViewModel)
final profileViewModelProvider = ProfileViewModelProvider._();

/// Hồ sơ của người đang đăng nhập. Mọi module khác lấy `employee_id`,
/// role, phòng ban, ca làm từ đây: `ref.watch(profileViewModelProvider)`.
///
/// keepAlive vì được dùng ở hầu hết màn hình; tự tải lại khi `authState`
/// đổi (đăng nhập / đăng xuất) nhờ `ref.watch`.
final class ProfileViewModelProvider
    extends $AsyncNotifierProvider<ProfileViewModel, Profile?> {
  /// Hồ sơ của người đang đăng nhập. Mọi module khác lấy `employee_id`,
  /// role, phòng ban, ca làm từ đây: `ref.watch(profileViewModelProvider)`.
  ///
  /// keepAlive vì được dùng ở hầu hết màn hình; tự tải lại khi `authState`
  /// đổi (đăng nhập / đăng xuất) nhờ `ref.watch`.
  ProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileViewModelHash();

  @$internal
  @override
  ProfileViewModel create() => ProfileViewModel();
}

String _$profileViewModelHash() => r'3be46bf74626ef52bfc7719251e9b8b18827f0af';

/// Hồ sơ của người đang đăng nhập. Mọi module khác lấy `employee_id`,
/// role, phòng ban, ca làm từ đây: `ref.watch(profileViewModelProvider)`.
///
/// keepAlive vì được dùng ở hầu hết màn hình; tự tải lại khi `authState`
/// đổi (đăng nhập / đăng xuất) nhờ `ref.watch`.

abstract class _$ProfileViewModel extends $AsyncNotifier<Profile?> {
  FutureOr<Profile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Profile?>, Profile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile?>, Profile?>,
              AsyncValue<Profile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
