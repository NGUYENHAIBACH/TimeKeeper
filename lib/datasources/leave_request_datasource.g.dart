// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider LeaveRequestDataSource (keepAlive).

@ProviderFor(leaveRequestDataSource)
final leaveRequestDataSourceProvider = LeaveRequestDataSourceProvider._();

/// Provider LeaveRequestDataSource (keepAlive).

final class LeaveRequestDataSourceProvider
    extends
        $FunctionalProvider<
          LeaveRequestDataSource,
          LeaveRequestDataSource,
          LeaveRequestDataSource
        >
    with $Provider<LeaveRequestDataSource> {
  /// Provider LeaveRequestDataSource (keepAlive).
  LeaveRequestDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveRequestDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveRequestDataSourceHash();

  @$internal
  @override
  $ProviderElement<LeaveRequestDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LeaveRequestDataSource create(Ref ref) {
    return leaveRequestDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveRequestDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveRequestDataSource>(value),
    );
  }
}

String _$leaveRequestDataSourceHash() =>
    r'0f80e63c009c86ce1800300e892c38a460c6e072';
