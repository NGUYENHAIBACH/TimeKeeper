// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ot_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(otDataSource)
final otDataSourceProvider = OtDataSourceProvider._();

final class OtDataSourceProvider
    extends $FunctionalProvider<OtDataSource, OtDataSource, OtDataSource>
    with $Provider<OtDataSource> {
  OtDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otDataSourceHash();

  @$internal
  @override
  $ProviderElement<OtDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OtDataSource create(Ref ref) {
    return otDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtDataSource>(value),
    );
  }
}

String _$otDataSourceHash() => r'8e9ef84de8e60fc32e606c246ab1950a40f252d9';
