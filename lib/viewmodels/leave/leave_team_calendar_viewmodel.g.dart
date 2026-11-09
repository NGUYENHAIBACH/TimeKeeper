// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_team_calendar_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel màn Lịch nghỉ của team: xem đồng nghiệp cùng phòng ban
/// nghỉ ngày nào trong tháng.

@ProviderFor(LeaveTeamCalendarViewModel)
final leaveTeamCalendarViewModelProvider =
    LeaveTeamCalendarViewModelProvider._();

/// ViewModel màn Lịch nghỉ của team: xem đồng nghiệp cùng phòng ban
/// nghỉ ngày nào trong tháng.
final class LeaveTeamCalendarViewModelProvider
    extends $AsyncNotifierProvider<LeaveTeamCalendarViewModel, TeamLeaveData> {
  /// ViewModel màn Lịch nghỉ của team: xem đồng nghiệp cùng phòng ban
  /// nghỉ ngày nào trong tháng.
  LeaveTeamCalendarViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveTeamCalendarViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveTeamCalendarViewModelHash();

  @$internal
  @override
  LeaveTeamCalendarViewModel create() => LeaveTeamCalendarViewModel();
}

String _$leaveTeamCalendarViewModelHash() =>
    r'ac4c7e4716730ba3023f25ad4951cdaad10edec1';

/// ViewModel màn Lịch nghỉ của team: xem đồng nghiệp cùng phòng ban
/// nghỉ ngày nào trong tháng.

abstract class _$LeaveTeamCalendarViewModel
    extends $AsyncNotifier<TeamLeaveData> {
  FutureOr<TeamLeaveData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TeamLeaveData>, TeamLeaveData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TeamLeaveData>, TeamLeaveData>,
              AsyncValue<TeamLeaveData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
