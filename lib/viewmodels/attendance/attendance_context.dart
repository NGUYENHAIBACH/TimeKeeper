import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/models/work_shift.dart';
import 'package:timekeeper/repositories/attendance_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/settings_viewmodel.dart';

part 'attendance_context.g.dart';

/// Hồ sơ người đang đăng nhập (từ `profileViewModelProvider` của TV1).
/// Ném [StateError] nếu chưa đăng nhập hoặc chưa có dòng `profiles`.
Future<Profile> _requireProfile(Ref ref) async {
  final profile = await ref.watch(profileViewModelProvider.future);
  if (profile == null) {
    throw StateError('Chưa có hồ sơ nhân viên. Hãy đăng nhập lại.');
  }
  return profile;
}

/// `profiles.id` của người đang đăng nhập, dùng làm `employee_id`.
@riverpod
Future<String> currentEmployeeId(Ref ref) async => (await _requireProfile(ref)).id;

/// Ca làm của người đang đăng nhập (`profiles.shift_id` -> `shifts`).
/// Chưa được gán ca thì dùng ca hành chính.
@riverpod
Future<WorkShift> currentShift(Ref ref) async {
  final profile = await _requireProfile(ref);
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return repo.getShift(profile.shiftId);
}

/// Bộ tính trạng thái ngày công theo ca hiện tại.
@riverpod
Future<AttendanceStatusCalculator> attendanceStatusCalculator(Ref ref) async =>
    AttendanceStatusCalculator(shift: await ref.watch(currentShiftProvider.future));

/// Có bắt xác thực vân tay khi chấm công không (Settings của TV1).
@riverpod
bool attendanceBiometricEnabled(Ref ref) =>
    ref.watch(settingsViewModelProvider).biometricEnabled;
