// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveRequest _$LeaveRequestFromJson(Map<String, dynamic> json) =>
    _LeaveRequest(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      leaveTypeId: json['leave_type_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      halfDay:
          $enumDecodeNullable(_$HalfDayEnumMap, json['half_day']) ??
          HalfDay.none,
      totalDays: (json['total_days'] as num).toDouble(),
      reason: json['reason'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      status:
          $enumDecodeNullable(_$LeaveStatusEnumMap, json['status']) ??
          LeaveStatus.pending,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      rejectReason: json['reject_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      leaveType: json['leave_types'] == null
          ? null
          : LeaveType.fromJson(json['leave_types'] as Map<String, dynamic>),
      employeeName: json['employee_name'] as String?,
    );

Map<String, dynamic> _$LeaveRequestToJson(_LeaveRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'leave_type_id': instance.leaveTypeId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'half_day': _$HalfDayEnumMap[instance.halfDay]!,
      'total_days': instance.totalDays,
      'reason': instance.reason,
      'attachment_url': instance.attachmentUrl,
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'reject_reason': instance.rejectReason,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$HalfDayEnumMap = {
  HalfDay.none: 'none',
  HalfDay.morning: 'morning',
  HalfDay.afternoon: 'afternoon',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
  LeaveStatus.cancelled: 'cancelled',
};
