// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodayAttendance _$TodayAttendanceFromJson(Map<String, dynamic> json) =>
    _TodayAttendance(
      id: json['id'] as String,
      workDate: DateTime.parse(json['work_date'] as String),
      checkInAt: json['check_in_at'] == null
          ? null
          : DateTime.parse(json['check_in_at'] as String),
      checkOutAt: json['check_out_at'] == null
          ? null
          : DateTime.parse(json['check_out_at'] as String),
      status: json['status'] as String? ?? 'present',
      lateMinutes: (json['late_minutes'] as num?)?.toInt() ?? 0,
      workHours: (json['work_hours'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$TodayAttendanceToJson(_TodayAttendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'work_date': instance.workDate.toIso8601String(),
      'check_in_at': instance.checkInAt?.toIso8601String(),
      'check_out_at': instance.checkOutAt?.toIso8601String(),
      'status': instance.status,
      'late_minutes': instance.lateMinutes,
      'work_hours': instance.workHours,
    };
