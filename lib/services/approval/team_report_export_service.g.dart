// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_report_export_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(teamReportExportService)
final teamReportExportServiceProvider = TeamReportExportServiceProvider._();

final class TeamReportExportServiceProvider
    extends
        $FunctionalProvider<
          TeamReportExportService,
          TeamReportExportService,
          TeamReportExportService
        >
    with $Provider<TeamReportExportService> {
  TeamReportExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamReportExportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamReportExportServiceHash();

  @$internal
  @override
  $ProviderElement<TeamReportExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TeamReportExportService create(Ref ref) {
    return teamReportExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamReportExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamReportExportService>(value),
    );
  }
}

String _$teamReportExportServiceHash() =>
    r'a28d41eb8b4a32c78e3cf6f90fb79c6c962ff8ad';
