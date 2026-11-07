// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider LeaveDataSource (keepAlive).

@ProviderFor(leaveDataSource)
final leaveDataSourceProvider = LeaveDataSourceProvider._();

/// Provider LeaveDataSource (keepAlive).

final class LeaveDataSourceProvider
    extends
        $FunctionalProvider<LeaveDataSource, LeaveDataSource, LeaveDataSource>
    with $Provider<LeaveDataSource> {
  /// Provider LeaveDataSource (keepAlive).
  LeaveDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveDataSourceHash();

  @$internal
  @override
  $ProviderElement<LeaveDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveDataSource create(Ref ref) {
    return leaveDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveDataSource>(value),
    );
  }
}

String _$leaveDataSourceHash() => r'62bcf13bfbda27f40fee14008505b38ac8a76aa6';
