// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_history_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel màn Lịch sử & Số dư phép.

@ProviderFor(LeaveHistoryViewModel)
final leaveHistoryViewModelProvider = LeaveHistoryViewModelProvider._();

/// ViewModel màn Lịch sử & Số dư phép.
final class LeaveHistoryViewModelProvider
    extends $AsyncNotifierProvider<LeaveHistoryViewModel, LeaveHistoryData> {
  /// ViewModel màn Lịch sử & Số dư phép.
  LeaveHistoryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveHistoryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveHistoryViewModelHash();

  @$internal
  @override
  LeaveHistoryViewModel create() => LeaveHistoryViewModel();
}

String _$leaveHistoryViewModelHash() =>
    r'0d29179209f14ad65a2b1fa551a378ac8bebad16';

/// ViewModel màn Lịch sử & Số dư phép.

abstract class _$LeaveHistoryViewModel
    extends $AsyncNotifier<LeaveHistoryData> {
  FutureOr<LeaveHistoryData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LeaveHistoryData>, LeaveHistoryData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LeaveHistoryData>, LeaveHistoryData>,
              AsyncValue<LeaveHistoryData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bộ lọc đang chọn ở màn Lịch sử (trạng thái, loại phép).

@ProviderFor(LeaveHistoryFilter)
final leaveHistoryFilterProvider = LeaveHistoryFilterProvider._();

/// Bộ lọc đang chọn ở màn Lịch sử (trạng thái, loại phép).
final class LeaveHistoryFilterProvider
    extends $NotifierProvider<LeaveHistoryFilter, LeaveFilter> {
  /// Bộ lọc đang chọn ở màn Lịch sử (trạng thái, loại phép).
  LeaveHistoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveHistoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveHistoryFilterHash();

  @$internal
  @override
  LeaveHistoryFilter create() => LeaveHistoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveFilter>(value),
    );
  }
}

String _$leaveHistoryFilterHash() =>
    r'54a3ee70cf48e5831db190e1ea427e09cff38392';

/// Bộ lọc đang chọn ở màn Lịch sử (trạng thái, loại phép).

abstract class _$LeaveHistoryFilter extends $Notifier<LeaveFilter> {
  LeaveFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LeaveFilter, LeaveFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LeaveFilter, LeaveFilter>,
              LeaveFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
