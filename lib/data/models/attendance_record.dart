import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/date_utils.dart';

part 'attendance_record.freezed.dart';

/// Giá trị cột `status` của `attendance_records` trên DB.
/// (Khác với `AttendanceStatus` dùng để tô màu lịch, được tính trong app.)
enum AttendanceRecordStatus { present, late, absent, leave, holiday }

/// Bản ghi chấm công: 1 dòng / nhân viên / ngày. Map với `attendance_records`.
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const AttendanceRecord._();

  const factory AttendanceRecord({
    required String id,

    /// `profiles.id` của nhân viên.
    required String employeeId,

    /// Ngày làm việc (không có giờ).
    required DateTime workDate,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    double? checkInLat,
    double? checkInLng,
    double? checkOutLat,
    double? checkOutLng,
    String? officeId,
    @Default(0) int lateMinutes,
    @Default(0) int earlyLeaveMinutes,

    /// Số giờ làm (tính khi check-out).
    @Default(0) double workHours,
    @Default(AttendanceRecordStatus.present) AttendanceRecordStatus status,
    @Default(false) bool isMockedLocation,
    String? note,

    /// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
    @Default(true) bool synced,
  }) = _AttendanceRecord;

  /// Đã check-in chưa.
  bool get hasCheckedIn => checkInAt != null;

  /// Đã check-out chưa.
  bool get hasCheckedOut => checkOutAt != null;

  /// Thời gian làm việc, null nếu chưa đủ giờ vào/ra.
  Duration? get workedDuration {
    if (checkInAt == null || checkOutAt == null) return null;
    return checkOutAt!.difference(checkInAt!);
  }

  /// Đọc một dòng từ Supabase hoặc SQLite. Dòng từ Supabase không có cột
  /// `synced` nên mặc định là đã đồng bộ.
  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    double? num_(Object? v) => (v as num?)?.toDouble();
    return AttendanceRecord(
      id: map['id'] as String,
      employeeId: map['employee_id'] as String,
      workDate: AppDate.parseKey(map['work_date'] as String),
      checkInAt: AppDate.fromDb(map['check_in_at']),
      checkOutAt: AppDate.fromDb(map['check_out_at']),
      checkInLat: num_(map['check_in_lat']),
      checkInLng: num_(map['check_in_lng']),
      checkOutLat: num_(map['check_out_lat']),
      checkOutLng: num_(map['check_out_lng']),
      officeId: map['office_id'] as String?,
      lateMinutes: (map['late_minutes'] as num?)?.toInt() ?? 0,
      earlyLeaveMinutes: (map['early_leave_minutes'] as num?)?.toInt() ?? 0,
      workHours: num_(map['work_hours']) ?? 0,
      status: AttendanceRecordStatus.values.byName(
        map['status'] as String? ?? 'present',
      ),
      isMockedLocation: _bool(map['is_mocked_location']),
      note: map['note'] as String?,
      synced: map['synced'] == null ? true : map['synced'] == 1,
    );
  }

  /// Dòng để ghi lên Supabase (không có `synced`, `created_at`, `updated_at`).
  Map<String, dynamic> toRemote() => {
        'id': id,
        'employee_id': employeeId,
        'work_date': AppDate.key(workDate),
        'check_in_at': AppDate.toDb(checkInAt),
        'check_out_at': AppDate.toDb(checkOutAt),
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'office_id': officeId,
        'late_minutes': lateMinutes,
        'early_leave_minutes': earlyLeaveMinutes,
        'work_hours': double.parse(workHours.toStringAsFixed(2)),
        'status': status.name,
        'is_mocked_location': isMockedLocation,
        'note': note,
      };

  /// Dòng để ghi vào SQLite (bool -> 0/1, thêm `synced`).
  Map<String, dynamic> toLocal() => {
        ...toRemote(),
        'is_mocked_location': isMockedLocation ? 1 : 0,
        'synced': synced ? 1 : 0,
      };
}

bool _bool(Object? v) => v is bool ? v : v == 1;
