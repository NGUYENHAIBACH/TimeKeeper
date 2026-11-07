// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ot_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OtFormViewModel)
final otFormViewModelProvider = OtFormViewModelProvider._();

final class OtFormViewModelProvider
    extends $NotifierProvider<OtFormViewModel, OtFormState> {
  OtFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otFormViewModelHash();

  @$internal
  @override
  OtFormViewModel create() => OtFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtFormState>(value),
    );
  }
}

String _$otFormViewModelHash() => r'bd2ad1c5b1edbc5f41139286c6f962726820d7e6';

abstract class _$OtFormViewModel extends $Notifier<OtFormState> {
  OtFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OtFormState, OtFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OtFormState, OtFormState>,
              OtFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
