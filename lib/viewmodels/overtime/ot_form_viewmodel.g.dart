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
    extends $AsyncNotifierProvider<OtFormViewModel, OtFormState> {
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
}

String _$otFormViewModelHash() => r'1a4ca89d0bcd8e81a8e2e34821b9672edb20d0f3';

abstract class _$OtFormViewModel extends $AsyncNotifier<OtFormState> {
  FutureOr<OtFormState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OtFormState>, OtFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OtFormState>, OtFormState>,
              AsyncValue<OtFormState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
