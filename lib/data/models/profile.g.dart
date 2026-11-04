// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  firebaseUid: json['firebase_uid'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.employee,
  departmentId: json['department_id'] as String?,
  managerId: json['manager_id'] as String?,
  shiftId: json['shift_id'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'firebase_uid': instance.firebaseUid,
  'email': instance.email,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'role': _$UserRoleEnumMap[instance.role]!,
  'department_id': instance.departmentId,
  'manager_id': instance.managerId,
  'shift_id': instance.shiftId,
};

const _$UserRoleEnumMap = {
  UserRole.employee: 'employee',
  UserRole.manager: 'manager',
  UserRole.admin: 'admin',
};
