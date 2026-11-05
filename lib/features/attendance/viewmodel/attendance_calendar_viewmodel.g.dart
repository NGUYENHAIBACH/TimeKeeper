// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_calendar_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tháng đang xem trên lịch (ngày 1 của tháng).

@ProviderFor(SelectedMonth)
final selectedMonthProvider = SelectedMonthProvider._();

/// Tháng đang xem trên lịch (ngày 1 của tháng).
final class SelectedMonthProvider
    extends $NotifierProvider<SelectedMonth, DateTime> {
  /// Tháng đang xem trên lịch (ngày 1 của tháng).
  SelectedMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMonthHash();

  @$internal
  @override
  SelectedMonth create() => SelectedMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedMonthHash() => r'8dea8d35aa6ce3a93d9e5da40c80630dcadefbad';

/// Tháng đang xem trên lịch (ngày 1 của tháng).

abstract class _$SelectedMonth extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Lọc lịch: chỉ tô màu các ngày có trạng thái này (null = tất cả).

@ProviderFor(CalendarFilter)
final calendarFilterProvider = CalendarFilterProvider._();

/// Lọc lịch: chỉ tô màu các ngày có trạng thái này (null = tất cả).
final class CalendarFilterProvider
    extends $NotifierProvider<CalendarFilter, AttendanceStatus?> {
  /// Lọc lịch: chỉ tô màu các ngày có trạng thái này (null = tất cả).
  CalendarFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarFilterHash();

  @$internal
  @override
  CalendarFilter create() => CalendarFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceStatus?>(value),
    );
  }
}

String _$calendarFilterHash() => r'b6fdefb725a2dec335678fefa78a74919f16e703';

/// Lọc lịch: chỉ tô màu các ngày có trạng thái này (null = tất cả).

abstract class _$CalendarFilter extends $Notifier<AttendanceStatus?> {
  AttendanceStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AttendanceStatus?, AttendanceStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AttendanceStatus?, AttendanceStatus?>,
              AttendanceStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// ViewModel màn Lịch công tháng: tô màu từng ngày, lọc theo trạng thái,
/// tổng giờ làm và phút đi muộn trong tháng.

@ProviderFor(AttendanceCalendarViewModel)
final attendanceCalendarViewModelProvider =
    AttendanceCalendarViewModelProvider._();

/// ViewModel màn Lịch công tháng: tô màu từng ngày, lọc theo trạng thái,
/// tổng giờ làm và phút đi muộn trong tháng.
final class AttendanceCalendarViewModelProvider
    extends $AsyncNotifierProvider<AttendanceCalendarViewModel, CalendarState> {
  /// ViewModel màn Lịch công tháng: tô màu từng ngày, lọc theo trạng thái,
  /// tổng giờ làm và phút đi muộn trong tháng.
  AttendanceCalendarViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceCalendarViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceCalendarViewModelHash();

  @$internal
  @override
  AttendanceCalendarViewModel create() => AttendanceCalendarViewModel();
}

String _$attendanceCalendarViewModelHash() =>
    r'ee79ca0ad5010889e1f05d9f164680fae5d94674';

/// ViewModel màn Lịch công tháng: tô màu từng ngày, lọc theo trạng thái,
/// tổng giờ làm và phút đi muộn trong tháng.

abstract class _$AttendanceCalendarViewModel
    extends $AsyncNotifier<CalendarState> {
  FutureOr<CalendarState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CalendarState>, CalendarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CalendarState>, CalendarState>,
              AsyncValue<CalendarState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
