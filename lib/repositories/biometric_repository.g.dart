// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider BiometricRepository (keepAlive).

@ProviderFor(biometricRepository)
final biometricRepositoryProvider = BiometricRepositoryProvider._();

/// Provider BiometricRepository (keepAlive).

final class BiometricRepositoryProvider
    extends
        $FunctionalProvider<
          BiometricRepository,
          BiometricRepository,
          BiometricRepository
        >
    with $Provider<BiometricRepository> {
  /// Provider BiometricRepository (keepAlive).
  BiometricRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricRepositoryHash();

  @$internal
  @override
  $ProviderElement<BiometricRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BiometricRepository create(Ref ref) {
    return biometricRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricRepository>(value),
    );
  }
}

String _$biometricRepositoryHash() =>
    r'f7176841a4b07c1ced275e93ca10dc365f0c11a5';
