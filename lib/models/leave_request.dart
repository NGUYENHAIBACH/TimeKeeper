// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:timekeeper/models/leave_type.dart';

part 'leave_request.freezed.dart';
part 'leave_request.g.dart';

/// Trạng thái đơn, khớp cột `status` (dùng chung cho mọi loại đơn).
enum LeaveStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('cancelled')
  cancelled;

  /// Nhãn tiếng Việt hiển thị trên UI.
  String get label => switch (this) {
        LeaveStatus.pending => 'Chờ duyệt',
        LeaveStatus.approved => 'Đã duyệt',
        LeaveStatus.rejected => 'Từ chối',
        LeaveStatus.cancelled => 'Đã hủy',
      };

  /// Giá trị lưu trong DB.
  String get dbValue => name;
}

/// Nghỉ nửa ngày, khớp cột `half_day`.
enum HalfDay {
  @JsonValue('none')
  none,
  @JsonValue('morning')
  morning,
  @JsonValue('afternoon')
  afternoon;

  /// Nhãn tiếng Việt.
  String get label => switch (this) {
        HalfDay.none => 'Cả ngày',
        HalfDay.morning => 'Buổi sáng',
        HalfDay.afternoon => 'Buổi chiều',
      };

  /// Giá trị lưu trong DB.
  String get dbValue => name;
}

/// Đơn xin nghỉ (bảng `leave_requests`).
@freezed
abstract class LeaveRequest with _$LeaveRequest {
  const LeaveRequest._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LeaveRequest({
    required String id,
    required String employeeId,
    required String leaveTypeId,
    required DateTime startDate,
    required DateTime endDate,
    @Default(HalfDay.none) HalfDay halfDay,

    /// Số ngày nghỉ thực (đã trừ cuối tuần, ngày lễ; nửa ngày = 0.5).
    required double totalDays,
    required String reason,
    String? attachmentUrl,
    @Default(LeaveStatus.pending) LeaveStatus status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectReason,
    DateTime? createdAt,

    /// Loại phép (join `leave_types(*)`).
    @JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType,

    /// Tên người nghỉ (join `profiles`), chỉ có ở lịch nghỉ team.
    @JsonKey(includeToJson: false) String? employeeName,
  }) = _LeaveRequest;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);

  /// Đơn còn chờ duyệt thì người gửi được hủy.
  bool get canCancel => status == LeaveStatus.pending;

  /// Đơn có phủ ngày [day] không (so theo ngày, bỏ giờ).
  bool covers(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(startDate.year, startDate.month, startDate.day);
    final e = DateTime(endDate.year, endDate.month, endDate.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }
}
