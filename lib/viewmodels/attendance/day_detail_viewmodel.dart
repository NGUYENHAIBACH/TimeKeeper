import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/core/utils/correction_validator.dart';
import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/work_shift.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/viewmodels/attendance/action_result.dart';
import 'package:timekeeper/viewmodels/attendance/attendance_calendar_viewmodel.dart';
import 'package:timekeeper/viewmodels/attendance/attendance_context.dart';

part 'day_detail_viewmodel.freezed.dart';
part 'day_detail_viewmodel.g.dart';

/// Dữ liệu màn Chi tiết ngày công.
@freezed
abstract class DayDetailState with _$DayDetailState {
  const DayDetailState._();

  const factory DayDetailState({
    required DateTime day,
    required AttendanceRecord? record,
    required AttendanceStatus status,
    required WorkShift shift,
    required int lateMinutes,

    /// Đơn bù công của ngày, mới nhất trước.
    required List<AttendanceCorrection> corrections,
  }) = _DayDetailState;

  /// Đã có đơn đang chờ duyệt.
  bool get hasPendingCorrection =>
      corrections.any((c) => c.status == CorrectionStatus.pending);

  /// Hiện nút "Gửi đơn": ngày có vấn đề và chưa có đơn đang chờ.
  bool get canRequestCorrection =>
      status.needsCorrection && !hasPendingCorrection;
}

/// ViewModel màn Chi tiết ngày + Đơn bù công. Mỗi ngày một instance (family).
@riverpod
class DayDetailViewModel extends _$DayDetailViewModel {
  @override
  Future<DayDetailState> build(DateTime day) async {
    final employeeId = await ref.watch(currentEmployeeIdProvider.future);
    final calc = await ref.watch(attendanceStatusCalculatorProvider.future);
    final repo = await ref.watch(attendanceRepositoryProvider.future);

    final record = await repo.getRecord(employeeId, day);
    final corrections = await repo.getCorrections(employeeId, day);
    return DayDetailState(
      day: day,
      record: record,
      status: calc.statusFor(day: day, record: record, now: DateTime.now()),
      shift: calc.shift,
      lateMinutes: record == null ? 0 : calc.lateMinutes(record),
      corrections: corrections,
    );
  }

  /// Kiểm tra đơn, trả về danh sách lỗi (rỗng = hợp lệ). Dùng cho form.
  List<String> validate({
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String reason,
  }) {
    return CorrectionValidator.validate(
      workDate: day,
      checkIn: checkIn,
      checkOut: checkOut,
      reason: reason,
      now: DateTime.now(),
      existing: state.value?.corrections ?? const [],
    );
  }

  /// Gửi đơn bù công sau khi kiểm tra hợp lệ.
  Future<ActionResult> submitCorrection({
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String reason,
  }) async {
    final errors = validate(checkIn: checkIn, checkOut: checkOut, reason: reason);
    if (errors.isNotEmpty) return ActionResult.failure(errors.join('\n'));

    try {
      final repo = await ref.read(attendanceRepositoryProvider.future);
      final saved = await repo.submitCorrection(
        employeeId: await ref.read(currentEmployeeIdProvider.future),
        workDate: day,
        checkIn: checkIn,
        checkOut: checkOut,
        reason: reason,
      );
      if (ref.mounted) {
        ref.invalidateSelf();
        // Lịch tháng cần hiện dấu "đang chờ duyệt".
        ref.invalidate(attendanceCalendarViewModelProvider);
      }
      // TV5: gửi thông báo cho quản lý khi có đơn mới.
      return ActionResult.success(
        saved.synced
            ? 'Đã gửi đơn bù công, chờ quản lý duyệt'
            : 'Đã lưu đơn trên máy, sẽ gửi khi có mạng',
      );
    } catch (e) {
      return ActionResult.failure('Gửi đơn thất bại: $e');
    }
  }
}
