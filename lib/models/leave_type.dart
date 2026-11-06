// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_type.freezed.dart';
part 'leave_type.g.dart';

/// Loại nghỉ phép, ánh xạ bảng `leave_types` (annual, sick, unpaid...).
@freezed
abstract class LeaveType with _$LeaveType {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LeaveType({
    required String id,

    /// Mã loại phép: 'annual', 'sick', 'unpaid'...
    required String code,
    required String name,

    /// Số ngày được cấp mỗi năm.
    @Default(0) double defaultDays,
    @Default(true) bool isPaid,

    /// true = bắt buộc đính kèm giấy tờ (vd giấy khám bệnh).
    @Default(false) bool requiresDocument,
  }) = _LeaveType;

  factory LeaveType.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeFromJson(json);
}
