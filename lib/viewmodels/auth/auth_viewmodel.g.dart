// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.

@ProviderFor(AuthViewModel)
final authViewModelProvider = AuthViewModelProvider._();

/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.
final class AuthViewModelProvider
    extends $AsyncNotifierProvider<AuthViewModel, void> {
  /// ViewModel cho Login / Register / Quên mật khẩu.
  /// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
  /// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
  /// và router tự redirect sang Home.
  AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();
}

String _$authViewModelHash() => r'c04b066bc27099f15ae6543fe1961b5e9f2a874f';

/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.

abstract class _$AuthViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
