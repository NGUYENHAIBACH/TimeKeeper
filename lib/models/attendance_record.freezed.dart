// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceRecord {

 String get id;/// `profiles.id` của nhân viên.
 String get employeeId;/// Ngày làm việc (không có giờ).
 DateTime get workDate; DateTime? get checkInAt; DateTime? get checkOutAt; double? get checkInLat; double? get checkInLng; double? get checkOutLat; double? get checkOutLng; String? get officeId; int get lateMinutes; int get earlyLeaveMinutes;/// Số giờ làm (tính khi check-out).
 double get workHours; AttendanceRecordStatus get status; bool get isMockedLocation; String? get note;/// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
 bool get synced;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AttendanceRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.employeeId, _this.employeeId) || other.employeeId == _this.employeeId)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.checkInAt, _this.checkInAt) || other.checkInAt == _this.checkInAt)&&(identical(other.checkOutAt, _this.checkOutAt) || other.checkOutAt == _this.checkOutAt)&&(identical(other.checkInLat, _this.checkInLat) || other.checkInLat == _this.checkInLat)&&(identical(other.checkInLng, _this.checkInLng) || other.checkInLng == _this.checkInLng)&&(identical(other.checkOutLat, _this.checkOutLat) || other.checkOutLat == _this.checkOutLat)&&(identical(other.checkOutLng, _this.checkOutLng) || other.checkOutLng == _this.checkOutLng)&&(identical(other.officeId, _this.officeId) || other.officeId == _this.officeId)&&(identical(other.lateMinutes, _this.lateMinutes) || other.lateMinutes == _this.lateMinutes)&&(identical(other.earlyLeaveMinutes, _this.earlyLeaveMinutes) || other.earlyLeaveMinutes == _this.earlyLeaveMinutes)&&(identical(other.workHours, _this.workHours) || other.workHours == _this.workHours)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isMockedLocation, _this.isMockedLocation) || other.isMockedLocation == _this.isMockedLocation)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.synced, _this.synced) || other.synced == _this.synced));
}


@override
int get hashCode {
  final _this = this as AttendanceRecord;
  return Object.hash(runtimeType,_this.id,_this.employeeId,_this.workDate,_this.checkInAt,_this.checkOutAt,_this.checkInLat,_this.checkInLng,_this.checkOutLat,_this.checkOutLng,_this.officeId,_this.lateMinutes,_this.earlyLeaveMinutes,_this.workHours,_this.status,_this.isMockedLocation,_this.note,_this.synced);
}

@override
String toString() {
  final _this = this as AttendanceRecord;
  return 'AttendanceRecord(id: ${_this.id}, employeeId: ${_this.employeeId}, workDate: ${_this.workDate}, checkInAt: ${_this.checkInAt}, checkOutAt: ${_this.checkOutAt}, checkInLat: ${_this.checkInLat}, checkInLng: ${_this.checkInLng}, checkOutLat: ${_this.checkOutLat}, checkOutLng: ${_this.checkOutLng}, officeId: ${_this.officeId}, lateMinutes: ${_this.lateMinutes}, earlyLeaveMinutes: ${_this.earlyLeaveMinutes}, workHours: ${_this.workHours}, status: ${_this.status}, isMockedLocation: ${_this.isMockedLocation}, note: ${_this.note}, synced: ${_this.synced})';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, DateTime workDate, DateTime? checkInAt, DateTime? checkOutAt, double? checkInLat, double? checkInLng, double? checkOutLat, double? checkOutLng, String? officeId, int lateMinutes, int earlyLeaveMinutes, double workHours, AttendanceRecordStatus status, bool isMockedLocation, String? note, bool synced
});




}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? workDate = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? checkInLat = freezed,Object? checkInLng = freezed,Object? checkOutLat = freezed,Object? checkOutLng = freezed,Object? officeId = freezed,Object? lateMinutes = null,Object? earlyLeaveMinutes = null,Object? workHours = null,Object? status = null,Object? isMockedLocation = null,Object? note = freezed,Object? synced = null,}) {
  return _then(AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInLat: freezed == checkInLat ? _self.checkInLat : checkInLat // ignore: cast_nullable_to_non_nullable
as double?,checkInLng: freezed == checkInLng ? _self.checkInLng : checkInLng // ignore: cast_nullable_to_non_nullable
as double?,checkOutLat: freezed == checkOutLat ? _self.checkOutLat : checkOutLat // ignore: cast_nullable_to_non_nullable
as double?,checkOutLng: freezed == checkOutLng ? _self.checkOutLng : checkOutLng // ignore: cast_nullable_to_non_nullable
as double?,officeId: freezed == officeId ? _self.officeId : officeId // ignore: cast_nullable_to_non_nullable
as String?,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,earlyLeaveMinutes: null == earlyLeaveMinutes ? _self.earlyLeaveMinutes : earlyLeaveMinutes // ignore: cast_nullable_to_non_nullable
as int,workHours: null == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceRecordStatus,isMockedLocation: null == isMockedLocation ? _self.isMockedLocation : isMockedLocation // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  double? checkInLat,  double? checkInLng,  double? checkOutLat,  double? checkOutLng,  String? officeId,  int lateMinutes,  int earlyLeaveMinutes,  double workHours,  AttendanceRecordStatus status,  bool isMockedLocation,  String? note,  bool synced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.checkInLat,_that.checkInLng,_that.checkOutLat,_that.checkOutLng,_that.officeId,_that.lateMinutes,_that.earlyLeaveMinutes,_that.workHours,_that.status,_that.isMockedLocation,_that.note,_that.synced);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  double? checkInLat,  double? checkInLng,  double? checkOutLat,  double? checkOutLng,  String? officeId,  int lateMinutes,  int earlyLeaveMinutes,  double workHours,  AttendanceRecordStatus status,  bool isMockedLocation,  String? note,  bool synced)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.id,_that.employeeId,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.checkInLat,_that.checkInLng,_that.checkOutLat,_that.checkOutLng,_that.officeId,_that.lateMinutes,_that.earlyLeaveMinutes,_that.workHours,_that.status,_that.isMockedLocation,_that.note,_that.synced);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  double? checkInLat,  double? checkInLng,  double? checkOutLat,  double? checkOutLng,  String? officeId,  int lateMinutes,  int earlyLeaveMinutes,  double workHours,  AttendanceRecordStatus status,  bool isMockedLocation,  String? note,  bool synced)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.checkInLat,_that.checkInLng,_that.checkOutLat,_that.checkOutLng,_that.officeId,_that.lateMinutes,_that.earlyLeaveMinutes,_that.workHours,_that.status,_that.isMockedLocation,_that.note,_that.synced);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceRecord extends AttendanceRecord {
  const _AttendanceRecord({required this.id, required this.employeeId, required this.workDate, this.checkInAt, this.checkOutAt, this.checkInLat, this.checkInLng, this.checkOutLat, this.checkOutLng, this.officeId, this.lateMinutes = 0, this.earlyLeaveMinutes = 0, this.workHours = 0, this.status = AttendanceRecordStatus.present, this.isMockedLocation = false, this.note, this.synced = true}): super._();
  

@override final  String id;
/// `profiles.id` của nhân viên.
@override final  String employeeId;
/// Ngày làm việc (không có giờ).
@override final  DateTime workDate;
@override final  DateTime? checkInAt;
@override final  DateTime? checkOutAt;
@override final  double? checkInLat;
@override final  double? checkInLng;
@override final  double? checkOutLat;
@override final  double? checkOutLng;
@override final  String? officeId;
@override@JsonKey() final  int lateMinutes;
@override@JsonKey() final  int earlyLeaveMinutes;
/// Số giờ làm (tính khi check-out).
@override@JsonKey() final  double workHours;
@override@JsonKey() final  AttendanceRecordStatus status;
@override@JsonKey() final  bool isMockedLocation;
@override final  String? note;
/// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
@override@JsonKey() final  bool synced;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.checkInLat, checkInLat) || other.checkInLat == checkInLat)&&(identical(other.checkInLng, checkInLng) || other.checkInLng == checkInLng)&&(identical(other.checkOutLat, checkOutLat) || other.checkOutLat == checkOutLat)&&(identical(other.checkOutLng, checkOutLng) || other.checkOutLng == checkOutLng)&&(identical(other.officeId, officeId) || other.officeId == officeId)&&(identical(other.lateMinutes, lateMinutes) || other.lateMinutes == lateMinutes)&&(identical(other.earlyLeaveMinutes, earlyLeaveMinutes) || other.earlyLeaveMinutes == earlyLeaveMinutes)&&(identical(other.workHours, workHours) || other.workHours == workHours)&&(identical(other.status, status) || other.status == status)&&(identical(other.isMockedLocation, isMockedLocation) || other.isMockedLocation == isMockedLocation)&&(identical(other.note, note) || other.note == note)&&(identical(other.synced, synced) || other.synced == synced));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,employeeId,workDate,checkInAt,checkOutAt,checkInLat,checkInLng,checkOutLat,checkOutLng,officeId,lateMinutes,earlyLeaveMinutes,workHours,status,isMockedLocation,note,synced);
}

@override
String toString() {
    return 'AttendanceRecord(id: $id, employeeId: $employeeId, workDate: $workDate, checkInAt: $checkInAt, checkOutAt: $checkOutAt, checkInLat: $checkInLat, checkInLng: $checkInLng, checkOutLat: $checkOutLat, checkOutLng: $checkOutLng, officeId: $officeId, lateMinutes: $lateMinutes, earlyLeaveMinutes: $earlyLeaveMinutes, workHours: $workHours, status: $status, isMockedLocation: $isMockedLocation, note: $note, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, DateTime workDate, DateTime? checkInAt, DateTime? checkOutAt, double? checkInLat, double? checkInLng, double? checkOutLat, double? checkOutLng, String? officeId, int lateMinutes, int earlyLeaveMinutes, double workHours, AttendanceRecordStatus status, bool isMockedLocation, String? note, bool synced
});




}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? workDate = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? checkInLat = freezed,Object? checkInLng = freezed,Object? checkOutLat = freezed,Object? checkOutLng = freezed,Object? officeId = freezed,Object? lateMinutes = null,Object? earlyLeaveMinutes = null,Object? workHours = null,Object? status = null,Object? isMockedLocation = null,Object? note = freezed,Object? synced = null,}) {
  return _then(_AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInLat: freezed == checkInLat ? _self.checkInLat : checkInLat // ignore: cast_nullable_to_non_nullable
as double?,checkInLng: freezed == checkInLng ? _self.checkInLng : checkInLng // ignore: cast_nullable_to_non_nullable
as double?,checkOutLat: freezed == checkOutLat ? _self.checkOutLat : checkOutLat // ignore: cast_nullable_to_non_nullable
as double?,checkOutLng: freezed == checkOutLng ? _self.checkOutLng : checkOutLng // ignore: cast_nullable_to_non_nullable
as double?,officeId: freezed == officeId ? _self.officeId : officeId // ignore: cast_nullable_to_non_nullable
as String?,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,earlyLeaveMinutes: null == earlyLeaveMinutes ? _self.earlyLeaveMinutes : earlyLeaveMinutes // ignore: cast_nullable_to_non_nullable
as int,workHours: null == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceRecordStatus,isMockedLocation: null == isMockedLocation ? _self.isMockedLocation : isMockedLocation // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
