// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: type=lint, type=warning
String _$authViewModelHash() => r'c04b066bc27099f15ae6543fe1961b5e9f2a874f';

/// ViewModel cho Login / Register / Quên mật khẩu.
/// State là `AsyncValue<void>`: chỉ cần biết đang xử lý, lỗi, hay xong.
/// Sau khi đăng nhập thành công KHÔNG điều hướng ở đây; `authState` đổi
/// và router tự redirect sang Home.
///
/// Copied from [AuthViewModel].
@ProviderFor(AuthViewModel)
final authViewModelProvider =
    AutoDisposeAsyncNotifierProvider<AuthViewModel, void>.internal(
      AuthViewModel.new,
      name: r'authViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint, type=warning
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, unnecessary_const, compiler_sos
