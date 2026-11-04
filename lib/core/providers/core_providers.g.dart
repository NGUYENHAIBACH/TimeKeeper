// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Các provider "hạ tầng" dùng chung cho toàn app.
/// Tất cả đều keepAlive vì chỉ tạo một lần và sống suốt vòng đời app.
/// View KHÔNG được watch trực tiếp các provider này; chỉ DataSource /
/// Repository mới được dùng.
/// Instance Firebase Auth. Mock được trong test bằng overrideWithValue.

@ProviderFor(firebaseAuth)
final firebaseAuthProvider = FirebaseAuthProvider._();

/// Các provider "hạ tầng" dùng chung cho toàn app.
/// Tất cả đều keepAlive vì chỉ tạo một lần và sống suốt vòng đời app.
/// View KHÔNG được watch trực tiếp các provider này; chỉ DataSource /
/// Repository mới được dùng.
/// Instance Firebase Auth. Mock được trong test bằng overrideWithValue.

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  /// Các provider "hạ tầng" dùng chung cho toàn app.
  /// Tất cả đều keepAlive vì chỉ tạo một lần và sống suốt vòng đời app.
  /// View KHÔNG được watch trực tiếp các provider này; chỉ DataSource /
  /// Repository mới được dùng.
  /// Instance Firebase Auth. Mock được trong test bằng overrideWithValue.
  FirebaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'8c3e9d11b27110ca96130356b5ef4d5d34a5ffc2';

/// Client Supabase (đã initialize trong main()).

@ProviderFor(supabase)
final supabaseProvider = SupabaseProvider._();

/// Client Supabase (đã initialize trong main()).

final class SupabaseProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  /// Client Supabase (đã initialize trong main()).
  SupabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseHash() => r'7750c766113ae9b14a18705c73c53e2e92e2ddbd';

/// SharedPreferences. Giá trị thật được override trong main():
/// `sharedPrefsProvider.overrideWithValue(prefs)`.
/// Nếu quên override sẽ ném lỗi ngay khi dùng, dễ phát hiện.

@ProviderFor(sharedPrefs)
final sharedPrefsProvider = SharedPrefsProvider._();

/// SharedPreferences. Giá trị thật được override trong main():
/// `sharedPrefsProvider.overrideWithValue(prefs)`.
/// Nếu quên override sẽ ném lỗi ngay khi dùng, dễ phát hiện.

final class SharedPrefsProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// SharedPreferences. Giá trị thật được override trong main():
  /// `sharedPrefsProvider.overrideWithValue(prefs)`.
  /// Nếu quên override sẽ ném lỗi ngay khi dùng, dễ phát hiện.
  SharedPrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPrefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPrefsHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPrefsHash() => r'4bcfaf39a7a62670692910bfc80ab74aef8754c8';
