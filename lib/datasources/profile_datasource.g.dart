// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider ProfileDataSource (keepAlive).

@ProviderFor(profileDataSource)
final profileDataSourceProvider = ProfileDataSourceProvider._();

/// Provider ProfileDataSource (keepAlive).

final class ProfileDataSourceProvider
    extends
        $FunctionalProvider<
          ProfileDataSource,
          ProfileDataSource,
          ProfileDataSource
        >
    with $Provider<ProfileDataSource> {
  /// Provider ProfileDataSource (keepAlive).
  ProfileDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProfileDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileDataSource create(Ref ref) {
    return profileDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileDataSource>(value),
    );
  }
}

String _$profileDataSourceHash() => r'5dca7cbab39e22d164c8b4dc31438b8318302c29';
