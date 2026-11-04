// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// Vai trò người dùng, khớp với cột `role` trong bảng `profiles`.
enum UserRole {
  @JsonValue('employee')
  employee,
  @JsonValue('manager')
  manager,
  @JsonValue('admin')
  admin,
}

/// Hồ sơ nhân viên, ánh xạ 1-1 với bảng `profiles` trên Supabase.
/// Tên cột snake_case được chuyển tự động nhờ `fieldRename`.
@freezed
abstract class Profile with _$Profile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Profile({
    /// uuid của Supabase. Các bảng nghiệp vụ dùng id này làm `employee_id`.
    required String id,

    /// uid của Firebase Auth, cầu nối giữa Firebase và Supabase.
    required String firebaseUid,
    required String email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    @Default(UserRole.employee) UserRole role,
    String? departmentId,
    String? managerId,
    String? shiftId,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
