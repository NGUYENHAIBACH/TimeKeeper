// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Holiday _$HolidayFromJson(Map<String, dynamic> json) => _Holiday(
  id: json['id'] as String,
  holidayDate: DateTime.parse(json['holiday_date'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$HolidayToJson(_Holiday instance) => <String, dynamic>{
  'id': instance.id,
  'holiday_date': instance.holidayDate.toIso8601String(),
  'name': instance.name,
};
