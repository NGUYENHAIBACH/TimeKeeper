// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'holiday.freezed.dart';
part 'holiday.g.dart';

/// Ngày lễ (bảng `holidays`). Không tính vào số ngày nghỉ phép.
@freezed
abstract class Holiday with _$Holiday {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Holiday({
    required String id,
    required DateTime holidayDate,
    required String name,
  }) = _Holiday;

  factory Holiday.fromJson(Map<String, dynamic> json) => _$HolidayFromJson(json);
}
