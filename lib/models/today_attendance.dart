// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_attendance.freezed.dart';
part 'today_attendance.g.dart';

/// Bản ghi chấm công của một ngày (bảng `attendance_records`).
/// TV1 chỉ dùng để hiển thị trên Dashboard; TV2 mở rộng thêm field khi cần.
@freezed
abstract class TodayAttendance with _$TodayAttendance {
  const TodayAttendance._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TodayAttendance({
    required String id,
    required DateTime workDate,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    @Default('present') String status,
    @Default(0) int lateMinutes,
    @Default(0) double workHours,
  }) = _TodayAttendance;

  factory TodayAttendance.fromJson(Map<String, dynamic> json) =>
      _$TodayAttendanceFromJson(json);

  /// Đã check-in nhưng chưa check-out.
  bool get isWorking => checkInAt != null && checkOutAt == null;

  /// Đã hoàn thành cả check-in và check-out.
  bool get isDone => checkInAt != null && checkOutAt != null;
}
