// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel cấu hình app (theme, ngôn ngữ, giờ nhắc, vân tay).
/// keepAlive vì `MyApp` watch nó để đổi theme, và TV4 đọc giờ nhắc.
/// Đọc/ghi SharedPreferences đồng bộ nên state là [AppSettings] thường,
/// không cần AsyncValue.

@ProviderFor(SettingsViewModel)
final settingsViewModelProvider = SettingsViewModelProvider._();

/// ViewModel cấu hình app (theme, ngôn ngữ, giờ nhắc, vân tay).
/// keepAlive vì `MyApp` watch nó để đổi theme, và TV4 đọc giờ nhắc.
/// Đọc/ghi SharedPreferences đồng bộ nên state là [AppSettings] thường,
/// không cần AsyncValue.
final class SettingsViewModelProvider
    extends $NotifierProvider<SettingsViewModel, AppSettings> {
  /// ViewModel cấu hình app (theme, ngôn ngữ, giờ nhắc, vân tay).
  /// keepAlive vì `MyApp` watch nó để đổi theme, và TV4 đọc giờ nhắc.
  /// Đọc/ghi SharedPreferences đồng bộ nên state là [AppSettings] thường,
  /// không cần AsyncValue.
  SettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsViewModelHash();

  @$internal
  @override
  SettingsViewModel create() => SettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$settingsViewModelHash() => r'9d709a1d08fff01e631885a65c535949f888222b';

/// ViewModel cấu hình app (theme, ngôn ngữ, giờ nhắc, vân tay).
/// keepAlive vì `MyApp` watch nó để đổi theme, và TV4 đọc giờ nhắc.
/// Đọc/ghi SharedPreferences đồng bộ nên state là [AppSettings] thường,
/// không cần AsyncValue.

abstract class _$SettingsViewModel extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
