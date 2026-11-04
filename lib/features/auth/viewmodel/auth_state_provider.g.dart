// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream trạng thái đăng nhập Firebase. `null` = chưa đăng nhập.
/// keepAlive vì router dùng để redirect; mọi module khác dùng để lấy uid.
///
/// Dùng: `ref.watch(authStateProvider)` trả về `AsyncValue<User?>`.
/// Đang loading nghĩa là Firebase chưa khôi phục xong phiên (màn Splash).

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Stream trạng thái đăng nhập Firebase. `null` = chưa đăng nhập.
/// keepAlive vì router dùng để redirect; mọi module khác dùng để lấy uid.
///
/// Dùng: `ref.watch(authStateProvider)` trả về `AsyncValue<User?>`.
/// Đang loading nghĩa là Firebase chưa khôi phục xong phiên (màn Splash).

final class AuthStateProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  /// Stream trạng thái đăng nhập Firebase. `null` = chưa đăng nhập.
  /// keepAlive vì router dùng để redirect; mọi module khác dùng để lấy uid.
  ///
  /// Dùng: `ref.watch(authStateProvider)` trả về `AsyncValue<User?>`.
  /// Đang loading nghĩa là Firebase chưa khôi phục xong phiên (màn Splash).
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'bb1f08243a83d88f3fa41e7632f0637b369f833b';
