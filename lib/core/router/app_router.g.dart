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

String _$routerHash() => r'03a676989c09ab72c125c5c71b73c348ec9ee5c4';
