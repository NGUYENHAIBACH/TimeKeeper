import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/attendance_status.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/attendance_correction.dart';
import '../../../data/models/attendance_record.dart';
import '../../../data/repositories/attendance_repository.dart';
import 'attendance_context.dart';

part 'attendance_calendar_viewmodel.freezed.dart';
part 'attendance_calendar_viewmodel.g.dart';

/// Dữ liệu màn Lịch công tháng.
@freezed
abstract class CalendarState with _$CalendarState {
  const CalendarState._();

  const factory CalendarState({
    /// Ngày 1 của tháng đang xem.
    required DateTime month,

    /// Bản ghi theo ngày, key = `yyyy-MM-dd`.
    required Map<String, AttendanceRecord> records,

    /// Trạng thái theo ngày (không có ngày chưa tới), key = `yyyy-MM-dd`.
    required Map<String, AttendanceStatus> statuses,

    /// Các ngày có đơn bù công đang chờ duyệt.
    required Set<String> pendingCorrectionDays,
    required Duration totalWorked,
    required int totalLateMinutes,
  }) = _CalendarState;

  /// Trạng thái của ngày [day].
  AttendanceStatus statusOf(DateTime day) =>
      statuses[AppDate.key(day)] ?? AttendanceStatus.upcoming;

  /// Ngày [day] có đơn bù công đang chờ duyệt không.
  bool hasPendingCorrection(DateTime day) =>
      pendingCorrectionDays.contains(AppDate.key(day));

  /// Số ngày theo từng trạng thái, dùng cho phần tổng kết.
  Map<AttendanceStatus, int> get counts {
    final result = <AttendanceStatus, int>{};
    for (final s in statuses.values) {
      result[s] = (result[s] ?? 0) + 1;
    }
    return result;
  }
}

/// Tháng đang xem trên lịch (ngày 1 của tháng).
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  /// Chuyển sang tháng chứa [month].
  void set(DateTime month) => state = DateTime(month.year, month.month);
}

/// Lọc lịch: chỉ tô màu các ngày có trạng thái này (null = tất cả).
@riverpod
class CalendarFilter extends _$CalendarFilter {
  @override
  AttendanceStatus? build() => null;

  /// Bấm lại trạng thái đang chọn thì bỏ lọc.
  void toggle(AttendanceStatus status) =>
      state = state == status ? null : status;
}

/// ViewModel màn Lịch công tháng: tô màu từng ngày, lọc theo trạng thái,
/// tổng giờ làm và phút đi muộn trong tháng.
@riverpod
class AttendanceCalendarViewModel extends _$AttendanceCalendarViewModel {
  @override
  Future<CalendarState> build() async {
    final month = ref.watch(selectedMonthProvider);
    final employeeId = ref.watch(currentEmployeeIdProvider);
    final calc = ref.watch(attendanceStatusCalculatorProvider);
    final repo = await ref.watch(attendanceRepositoryProvider.future);

    final records = await repo.getRecordsInMonth(employeeId, month);
    final corrections = await repo.getCorrectionsInMonth(employeeId, month);

    final byDay = {for (final r in records) AppDate.key(r.workDate): r};
    final now = DateTime.now();
    final statuses = <String, AttendanceStatus>{};
    var worked = Duration.zero;
    var lateMinutes = 0;

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    for (var d = 1; d <= daysInMonth; d++) {
      final day = DateTime(month.year, month.month, d);
      final key = AppDate.key(day);
      final record = byDay[key];
      final status = calc.statusFor(day: day, record: record, now: now);
      if (status != AttendanceStatus.upcoming) statuses[key] = status;
      if (record != null) {
        worked += record.workedDuration ?? Duration.zero;
        if (calc.isLate(record)) lateMinutes += calc.lateMinutes(record);
      }
    }

    return CalendarState(
      month: month,
      records: byDay,
      statuses: statuses,
      pendingCorrectionDays: corrections
          .where((c) => c.status == CorrectionStatus.pending)
          .map((c) => AppDate.key(c.workDate))
          .toSet(),
      totalWorked: worked,
      totalLateMinutes: lateMinutes,
    );
  }

  /// Đổi tháng đang xem. `build()` tự chạy lại vì đang watch tháng.
  void changeMonth(DateTime month) =>
      ref.read(selectedMonthProvider.notifier).set(month);

  /// Lọc lịch theo trạng thái [status].
  void toggleFilter(AttendanceStatus status) =>
      ref.read(calendarFilterProvider.notifier).toggle(status);
}
