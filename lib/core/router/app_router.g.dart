// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning
String _$routerHash() => r'0a1712428271f6a5fd097f13e662385813ed5d65';

/// GoRouter của toàn app. keepAlive vì chỉ tạo một lần.
///
/// Redirect dựa trên `authState`:
/// - Firebase chưa khôi phục xong phiên  -> ở Splash
/// - Chưa đăng nhập mà vào route private  -> Login
/// - Đã đăng nhập mà vào Login/Register   -> Home
///
/// Chỉ có MỘT GoRouter suốt vòng đời app. Khi `authState` đổi ta không tạo
/// router mới (sẽ mất ngăn xếp màn hình) mà báo router chạy lại `redirect`
/// thông qua `refreshListenable`.
///
/// Mỗi thành viên thay `PlaceholderScreen` của route mình bằng screen thật.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = Provider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint, type=warning
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, unnecessary_const, compiler_sos
