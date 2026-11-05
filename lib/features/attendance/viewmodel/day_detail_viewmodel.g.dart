// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).

@ProviderFor(DayDetailViewModel)
final dayDetailViewModelProvider = DayDetailViewModelFamily._();

/// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).
final class DayDetailViewModelProvider
    extends $AsyncNotifierProvider<DayDetailViewModel, DayDetailState> {
  /// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).
  DayDetailViewModelProvider._({
    required DayDetailViewModelFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'dayDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dayDetailViewModelHash();

  @override
  String toString() {
    return r'dayDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DayDetailViewModel create() => DayDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is DayDetailViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dayDetailViewModelHash() =>
    r'bac59125d56e5330aa0eb2c9c26dd583179302e0';

/// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).

final class DayDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          DayDetailViewModel,
          AsyncValue<DayDetailState>,
          DayDetailState,
          FutureOr<DayDetailState>,
          DateTime
        > {
  DayDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'dayDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).

  DayDetailViewModelProvider call(DateTime day) =>
      DayDetailViewModelProvider._(argument: day, from: this);

  @override
  String toString() => r'dayDetailViewModelProvider';
}

/// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).

abstract class _$DayDetailViewModel extends $AsyncNotifier<DayDetailState> {
  late final _$args = ref.$arg as DateTime;
  DateTime get day => _$args;

  FutureOr<DayDetailState> build(DateTime day);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DayDetailState>, DayDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DayDetailState>, DayDetailState>,
              AsyncValue<DayDetailState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
