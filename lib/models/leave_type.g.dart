// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveType _$LeaveTypeFromJson(Map<String, dynamic> json) => _LeaveType(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  defaultDays: (json['default_days'] as num?)?.toDouble() ?? 0,
  isPaid: json['is_paid'] as bool? ?? true,
  requiresDocument: json['requires_document'] as bool? ?? false,
);

Map<String, dynamic> _$LeaveTypeToJson(_LeaveType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'default_days': instance.defaultDays,
      'is_paid': instance.isPaid,
      'requires_document': instance.requiresDocument,
    };
