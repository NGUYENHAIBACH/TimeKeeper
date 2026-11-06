import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/services/biometric_service.dart';
import 'package:timekeeper/core/services/location_service.dart';
import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/core/utils/geo_fence.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/office_location.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/viewmodels/attendance/action_result.dart';
import 'package:timekeeper/viewmodels/attendance/attendance_calendar_viewmodel.dart';
import 'package:timekeeper/viewmodels/attendance/attendance_context.dart';

part 'check_in_viewmodel.freezed.dart';
part 'check_in_viewmodel.g.dart';

/// Dữ liệu màn Check-in / Check-out.
@freezed
abstract class CheckInState with _$CheckInState {
  const CheckInState._();

  const factory CheckInState({
    required OfficeLocation? office,

    /// Bản ghi hôm nay (null = chưa check-in).
    required AttendanceRecord? today,
    required AttendanceStatus todayStatus,
    GeoPoint? position,

    /// Khoảng cách tới văn phòng (mét).
    double? distanceMeters,
    String? locationError,
    @Default(false) bool isLocating,
    @Default(false) bool isSubmitting,
  }) = _CheckInState;

  /// Đang đứng trong bán kính văn phòng.
  bool get isInsideOffice =>
      office != null &&
      distanceMeters != null &&
      GeoFence.isInside(
        distanceMeters: distanceMeters!,
        radiusMeters: office!.radiusMeters.toDouble(),
      );

  /// Hôm nay chưa check-in.
  bool get canCheckIn => today == null || !today!.hasCheckedIn;

  /// Đã check-in, chưa check-out.
  bool get canCheckOut =>
      today != null && today!.hasCheckedIn && !today!.hasCheckedOut;

  /// Đã xong cả check-in và check-out.
  bool get isDone => today?.hasCheckedOut ?? false;
}

/// ViewModel màn Check-in / Check-out bằng GPS (geofence) + vân tay.
@riverpod
class CheckInViewModel extends _$CheckInViewModel {
  @override
  Future<CheckInState> build() async {
    final repo = await ref.watch(attendanceRepositoryProvider.future);
    final employeeId = await ref.watch(currentEmployeeIdProvider.future);
    final calc = await ref.watch(attendanceStatusCalculatorProvider.future);
    final now = DateTime.now();
    final office = await repo.getOffice();
    final today = await repo.getRecord(employeeId, now);
    return CheckInState(
      office: office,
      today: today,
      todayStatus: calc.statusFor(day: now, record: today, now: now),
    );
  }

  /// Lấy lại vị trí GPS và tính khoảng cách tới văn phòng.
  Future<void> refreshLocation() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(isLocating: true, locationError: null));
    try {
      final pos = await ref.read(locationServiceProvider).getCurrentPosition();
      if (!ref.mounted) return;
      state = AsyncData(_withPosition(state.requireValue, pos).copyWith(isLocating: false));
    } on LocationException catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.requireValue.copyWith(isLocating: false, locationError: e.message),
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(state.requireValue.copyWith(
        isLocating: false,
        locationError: 'Không lấy được vị trí: $e',
      ));
    }
  }

  /// Check-in: kiểm tra GPS thật, trong bán kính, vân tay rồi lưu.
  Future<ActionResult> checkIn() => _punch(isCheckIn: true);

  /// Check-out: các bước như check-in.
  Future<ActionResult> checkOut() => _punch(isCheckIn: false);

  Future<ActionResult> _punch({required bool isCheckIn}) async {
    final current = state.value;
    if (current == null || current.isSubmitting) {
      return const ActionResult.failure('Đang xử lý, vui lòng đợi.');
    }
    if (current.office == null) {
      return const ActionResult.failure('Chưa cấu hình văn phòng.');
    }
    state = AsyncData(current.copyWith(isSubmitting: true));

    try {
      // 1. Vị trí mới nhất, phải là GPS thật và trong bán kính văn phòng.
      final locationService = ref.read(locationServiceProvider);
      final pos = await locationService.getCurrentPosition();
      if (!ref.mounted) return const ActionResult.failure('Đã rời màn hình.');
      final s = _withPosition(state.requireValue, pos);
      state = AsyncData(s);
      if (await locationService.isMocked()) {
        return _fail('Phát hiện vị trí giả lập. Hãy tắt app fake GPS.');
      }
      if (!s.isInsideOffice) {
        return _fail(
          'Bạn đang cách văn phòng ${s.distanceMeters!.round()} m '
          '(cho phép ${s.office!.radiusMeters} m).',
        );
      }

      // 2. Xác thực vân tay (nếu người dùng bật trong Settings).
      if (ref.read(attendanceBiometricEnabledProvider)) {
        final result = await ref.read(biometricServiceProvider).authenticate(
              isCheckIn ? 'Xác thực để check-in' : 'Xác thực để check-out',
            );
        final error = switch (result) {
          BiometricResult.success => null,
          BiometricResult.cancelled => 'Bạn đã hủy xác thực.',
          BiometricResult.lockedOut => 'Sai quá nhiều lần, vân tay bị khóa tạm thời.',
          BiometricResult.notAvailable => 'Máy chưa cài vân tay hoặc mã khóa màn hình.',
          BiometricResult.failed => 'Xác thực không thành công.',
        };
        if (error != null) return _fail(error);
      }

      // 3. Lưu (SQLite trước, rồi đẩy lên Supabase).
      if (!ref.mounted) return const ActionResult.failure('Đã rời màn hình.');
      final repo = await ref.read(attendanceRepositoryProvider.future);
      final employeeId = await ref.read(currentEmployeeIdProvider.future);
      final calc = await ref.read(attendanceStatusCalculatorProvider.future);
      final now = DateTime.now();
      final record = isCheckIn
          ? await repo.checkIn(
              employeeId: employeeId,
              at: now,
              latitude: pos.latitude,
              longitude: pos.longitude,
              officeId: s.office!.id,
              lateMinutes: calc.lateMinutesAt(now),
              isLate: calc.isLateAt(now),
            )
          : await repo.checkOut(
              employeeId: employeeId,
              at: now,
              latitude: pos.latitude,
              longitude: pos.longitude,
              earlyLeaveMinutes: calc.earlyLeaveMinutesAt(now),
            );

      if (!ref.mounted) return const ActionResult.success('Đã lưu chấm công');
      state = AsyncData(state.requireValue.copyWith(
        today: record,
        todayStatus: calc.statusFor(day: now, record: record, now: now),
        isSubmitting: false,
      ));
      // Lịch công cần tô màu lại ngày hôm nay.
      ref.invalidate(attendanceCalendarViewModelProvider);
      final action = isCheckIn ? 'Check-in' : 'Check-out';
      return ActionResult.success(
        record.synced
            ? '$action thành công'
            : '$action đã lưu trên máy, sẽ đồng bộ khi có mạng',
      );
    } on LocationException catch (e) {
      return _fail(e.message);
    } on StateError catch (e) {
      return _fail(e.message);
    } catch (e) {
      return _fail('Có lỗi xảy ra: $e');
    }
  }

  /// Chỉ dùng khi test (bản debug): đặt văn phòng ngay tại vị trí hiện tại.
  /// Ghi thẳng lên Supabase nên chỉ dùng với project dev.
  Future<ActionResult> moveOfficeHere() async {
    try {
      final pos = await ref.read(locationServiceProvider).getCurrentPosition();
      final repo = await ref.read(attendanceRepositoryProvider.future);
      if (!ref.mounted) return const ActionResult.failure('Đã rời màn hình.');
      final office = state.requireValue.office!
          .copyWith(latitude: pos.latitude, longitude: pos.longitude);
      await repo.saveOffice(office);
      if (!ref.mounted) return const ActionResult.success('Đã lưu văn phòng');
      state = AsyncData(
        _withPosition(state.requireValue.copyWith(office: office), pos),
      );
      return const ActionResult.success('Đã đặt văn phòng tại vị trí hiện tại');
    } catch (e) {
      return ActionResult.failure('$e');
    }
  }

  CheckInState _withPosition(CheckInState s, GeoPoint pos) {
    final office = s.office;
    final distance = office == null
        ? null
        : GeoFence.distanceMeters(
            pos.latitude,
            pos.longitude,
            office.latitude,
            office.longitude,
          );
    return s.copyWith(position: pos, distanceMeters: distance, locationError: null);
  }

  ActionResult _fail(String message) {
    if (ref.mounted) {
      final s = state.value;
      if (s != null) state = AsyncData(s.copyWith(isSubmitting: false));
    }
    return ActionResult.failure(message);
  }
}
