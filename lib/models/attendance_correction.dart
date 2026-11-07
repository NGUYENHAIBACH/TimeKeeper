import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timekeeper/core/utils/date_utils.dart';

part 'attendance_correction.freezed.dart';

/// Trạng thái đơn, dùng chung quy ước cả nhóm.
enum CorrectionStatus {
  pending('Đang chờ duyệt'),
  approved('Đã duyệt'),
  rejected('Từ chối'),
  cancelled('Đã hủy');

  const CorrectionStatus(this.label);

  /// Nhãn tiếng Việt để hiển thị.
  final String label;
}

/// Đơn bù công (quên check-in/out). Map với bảng `attendance_corrections`.
/// TV5 duyệt đơn này trong Hộp duyệt đơn.
@freezed
abstract class AttendanceCorrection with _$AttendanceCorrection {
  const AttendanceCorrection._();

  const factory AttendanceCorrection({
    required String id,

    /// `profiles.id` của người gửi.
    required String employeeId,
    required DateTime workDate,

    /// Bản ghi chấm công của ngày đó (nếu có).
    String? attendanceId,
    DateTime? requestedCheckIn,
    DateTime? requestedCheckOut,
    required String reason,
    @Default(CorrectionStatus.pending) CorrectionStatus status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectReason,
    required DateTime createdAt,

    /// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
    @Default(true) bool synced,
  }) = _AttendanceCorrection;

  /// Đọc một dòng từ Supabase hoặc SQLite.
  factory AttendanceCorrection.fromMap(Map<String, dynamic> map) =>
      AttendanceCorrection(
        id: map['id'] as String,
        employeeId: map['employee_id'] as String,
        workDate: AppDate.parseKey(map['work_date'] as String),
        attendanceId: map['attendance_id'] as String?,
        requestedCheckIn: AppDate.fromDb(map['requested_check_in']),
        requestedCheckOut: AppDate.fromDb(map['requested_check_out']),
        reason: map['reason'] as String,
        status: CorrectionStatus.values.byName(map['status'] as String),
        approvedBy: map['approved_by'] as String?,
        approvedAt: AppDate.fromDb(map['approved_at']),
        rejectReason: map['reject_reason'] as String?,
        createdAt: AppDate.fromDb(map['created_at'])!,
        synced: map['synced'] == null ? true : map['synced'] == 1,
      );

  /// Dòng để ghi lên Supabase.
  Map<String, dynamic> toRemote() => {
        'id': id,
        'employee_id': employeeId,
        'work_date': AppDate.key(workDate),
        'attendance_id': attendanceId,
        'requested_check_in': AppDate.toDb(requestedCheckIn),
        'requested_check_out': AppDate.toDb(requestedCheckOut),
        'reason': reason,
        'status': status.name,
        'approved_by': approvedBy,
        'approved_at': AppDate.toDb(approvedAt),
        'reject_reason': rejectReason,
        'created_at': AppDate.toDb(createdAt),
      };

  /// Dòng để ghi vào SQLite (thêm `synced`).
  Map<String, dynamic> toLocal() => {...toRemote(), 'synced': synced ? 1 : 0};
}
