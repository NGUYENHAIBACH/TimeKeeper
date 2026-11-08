// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ot_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(otRepository)
final otRepositoryProvider = OtRepositoryProvider._();

final class OtRepositoryProvider
    extends $FunctionalProvider<OtRepository, OtRepository, OtRepository>
    with $Provider<OtRepository> {
  OtRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otRepositoryHash();

  @$internal
  @override
  $ProviderElement<OtRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OtRepository create(Ref ref) {
    return otRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtRepository>(value),
    );
  }
}

String _$otRepositoryHash() => r'5579fb83ba3944e9682ca2ccb752646340fdf5f6';
