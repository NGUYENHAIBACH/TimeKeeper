// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(router)
final routerProvider = RouterProvider._();

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

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
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
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'b1211bd373a27951f9b35b1b0314ebec8e35c7c6';
