import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/attendance_status.dart';
import '../../../data/models/work_shift.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';

part 'attendance_context.g.dart';

/// `profiles.id` của nhân viên dev có sẵn trong project Supabase riêng của
/// TV2 (không có trong seed.sql chung).
const devEmployeeId = '00000000-0000-0000-0000-0000000000e1';

/// `profiles.id` của người đang đăng nhập.
///
/// TẠM THỜI trả về [devEmployeeId] vì TV1 chưa làm đăng nhập. Khi có
/// `profileViewModelProvider` thì đổi thân hàm thành id từ đó; các
/// ViewModel chấm công không phải sửa gì.
@riverpod
String currentEmployeeId(Ref ref) => devEmployeeId;

/// Ca làm của người đang đăng nhập.
///
/// TẠM THỜI dùng ca hành chính. Sau này đọc từ `profiles.shift_id` -> `shifts`.
@riverpod
WorkShift currentShift(Ref ref) => WorkShift.standard;

/// Bộ tính trạng thái ngày công theo ca hiện tại.
@riverpod
AttendanceStatusCalculator attendanceStatusCalculator(Ref ref) =>
    AttendanceStatusCalculator(shift: ref.watch(currentShiftProvider));

/// Có bắt xác thực vân tay khi chấm công không (Settings của TV1).
@riverpod
bool attendanceBiometricEnabled(Ref ref) =>
    ref.watch(settingsViewModelProvider).biometricEnabled;
