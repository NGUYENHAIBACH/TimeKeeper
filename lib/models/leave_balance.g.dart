// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) =>
    _LeaveBalance(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      leaveTypeId: json['leave_type_id'] as String,
      year: (json['year'] as num).toInt(),
      totalDays: (json['total_days'] as num?)?.toDouble() ?? 0,
      usedDays: (json['used_days'] as num?)?.toDouble() ?? 0,
      remainingDays: (json['remaining_days'] as num?)?.toDouble() ?? 0,
      leaveType: json['leave_types'] == null
          ? null
          : LeaveType.fromJson(json['leave_types'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaveBalanceToJson(_LeaveBalance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'leave_type_id': instance.leaveTypeId,
      'year': instance.year,
      'total_days': instance.totalDays,
      'used_days': instance.usedDays,
      'remaining_days': instance.remainingDays,
    };
