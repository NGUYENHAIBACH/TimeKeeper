// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_correction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceCorrection {

 String get id;/// `profiles.id` của người gửi.
 String get employeeId; DateTime get workDate;/// Bản ghi chấm công của ngày đó (nếu có).
 String? get attendanceId; DateTime? get requestedCheckIn; DateTime? get requestedCheckOut; String get reason; CorrectionStatus get status; String? get approvedBy; DateTime? get approvedAt; String? get rejectReason; DateTime get createdAt;/// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
 bool get synced;
/// Create a copy of AttendanceCorrection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceCorrectionCopyWith<AttendanceCorrection> get copyWith => _$AttendanceCorrectionCopyWithImpl<AttendanceCorrection>(this as AttendanceCorrection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AttendanceCorrection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceCorrection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.employeeId, _this.employeeId) || other.employeeId == _this.employeeId)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.attendanceId, _this.attendanceId) || other.attendanceId == _this.attendanceId)&&(identical(other.requestedCheckIn, _this.requestedCheckIn) || other.requestedCheckIn == _this.requestedCheckIn)&&(identical(other.requestedCheckOut, _this.requestedCheckOut) || other.requestedCheckOut == _this.requestedCheckOut)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.approvedBy, _this.approvedBy) || other.approvedBy == _this.approvedBy)&&(identical(other.approvedAt, _this.approvedAt) || other.approvedAt == _this.approvedAt)&&(identical(other.rejectReason, _this.rejectReason) || other.rejectReason == _this.rejectReason)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.synced, _this.synced) || other.synced == _this.synced));
}


@override
int get hashCode {
  final _this = this as AttendanceCorrection;
  return Object.hash(runtimeType,_this.id,_this.employeeId,_this.workDate,_this.attendanceId,_this.requestedCheckIn,_this.requestedCheckOut,_this.reason,_this.status,_this.approvedBy,_this.approvedAt,_this.rejectReason,_this.createdAt,_this.synced);
}

@override
String toString() {
  final _this = this as AttendanceCorrection;
  return 'AttendanceCorrection(id: ${_this.id}, employeeId: ${_this.employeeId}, workDate: ${_this.workDate}, attendanceId: ${_this.attendanceId}, requestedCheckIn: ${_this.requestedCheckIn}, requestedCheckOut: ${_this.requestedCheckOut}, reason: ${_this.reason}, status: ${_this.status}, approvedBy: ${_this.approvedBy}, approvedAt: ${_this.approvedAt}, rejectReason: ${_this.rejectReason}, createdAt: ${_this.createdAt}, synced: ${_this.synced})';
}


}

/// @nodoc
abstract mixin class $AttendanceCorrectionCopyWith<$Res>  {
  factory $AttendanceCorrectionCopyWith(AttendanceCorrection value, $Res Function(AttendanceCorrection) _then) = _$AttendanceCorrectionCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, DateTime workDate, String? attendanceId, DateTime? requestedCheckIn, DateTime? requestedCheckOut, String reason, CorrectionStatus status, String? approvedBy, DateTime? approvedAt, String? rejectReason, DateTime createdAt, bool synced
});




}
/// @nodoc
class _$AttendanceCorrectionCopyWithImpl<$Res>
    implements $AttendanceCorrectionCopyWith<$Res> {
  _$AttendanceCorrectionCopyWithImpl(this._self, this._then);

  final AttendanceCorrection _self;
  final $Res Function(AttendanceCorrection) _then;

/// Create a copy of AttendanceCorrection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? workDate = null,Object? attendanceId = freezed,Object? requestedCheckIn = freezed,Object? requestedCheckOut = freezed,Object? reason = null,Object? status = null,Object? approvedBy = freezed,Object? approvedAt = freezed,Object? rejectReason = freezed,Object? createdAt = null,Object? synced = null,}) {
  return _then(AttendanceCorrection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,attendanceId: freezed == attendanceId ? _self.attendanceId : attendanceId // ignore: cast_nullable_to_non_nullable
as String?,requestedCheckIn: freezed == requestedCheckIn ? _self.requestedCheckIn : requestedCheckIn // ignore: cast_nullable_to_non_nullable
as DateTime?,requestedCheckOut: freezed == requestedCheckOut ? _self.requestedCheckOut : requestedCheckOut // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CorrectionStatus,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceCorrection].
extension AttendanceCorrectionPatterns on AttendanceCorrection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceCorrection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceCorrection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceCorrection value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceCorrection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceCorrection value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceCorrection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  DateTime workDate,  String? attendanceId,  DateTime? requestedCheckIn,  DateTime? requestedCheckOut,  String reason,  CorrectionStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime createdAt,  bool synced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceCorrection() when $default != null:
return $default(_that.id,_that.employeeId,_that.workDate,_that.attendanceId,_that.requestedCheckIn,_that.requestedCheckOut,_that.reason,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.synced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  DateTime workDate,  String? attendanceId,  DateTime? requestedCheckIn,  DateTime? requestedCheckOut,  String reason,  CorrectionStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime createdAt,  bool synced)  $default,) {final _that = this;
switch (_that) {
case _AttendanceCorrection():
return $default(_that.id,_that.employeeId,_that.workDate,_that.attendanceId,_that.requestedCheckIn,_that.requestedCheckOut,_that.reason,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.synced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  DateTime workDate,  String? attendanceId,  DateTime? requestedCheckIn,  DateTime? requestedCheckOut,  String reason,  CorrectionStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime createdAt,  bool synced)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceCorrection() when $default != null:
return $default(_that.id,_that.employeeId,_that.workDate,_that.attendanceId,_that.requestedCheckIn,_that.requestedCheckOut,_that.reason,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.synced);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceCorrection extends AttendanceCorrection {
  const _AttendanceCorrection({required this.id, required this.employeeId, required this.workDate, this.attendanceId, this.requestedCheckIn, this.requestedCheckOut, required this.reason, this.status = CorrectionStatus.pending, this.approvedBy, this.approvedAt, this.rejectReason, required this.createdAt, this.synced = true}): super._();
  

@override final  String id;
/// `profiles.id` của người gửi.
@override final  String employeeId;
@override final  DateTime workDate;
/// Bản ghi chấm công của ngày đó (nếu có).
@override final  String? attendanceId;
@override final  DateTime? requestedCheckIn;
@override final  DateTime? requestedCheckOut;
@override final  String reason;
@override@JsonKey() final  CorrectionStatus status;
@override final  String? approvedBy;
@override final  DateTime? approvedAt;
@override final  String? rejectReason;
@override final  DateTime createdAt;
/// Chỉ có ở SQLite: false = chưa đẩy lên Supabase.
@override@JsonKey() final  bool synced;

/// Create a copy of AttendanceCorrection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceCorrectionCopyWith<_AttendanceCorrection> get copyWith => __$AttendanceCorrectionCopyWithImpl<_AttendanceCorrection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceCorrection&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.attendanceId, attendanceId) || other.attendanceId == attendanceId)&&(identical(other.requestedCheckIn, requestedCheckIn) || other.requestedCheckIn == requestedCheckIn)&&(identical(other.requestedCheckOut, requestedCheckOut) || other.requestedCheckOut == requestedCheckOut)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.synced, synced) || other.synced == synced));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,employeeId,workDate,attendanceId,requestedCheckIn,requestedCheckOut,reason,status,approvedBy,approvedAt,rejectReason,createdAt,synced);
}

@override
String toString() {
    return 'AttendanceCorrection(id: $id, employeeId: $employeeId, workDate: $workDate, attendanceId: $attendanceId, requestedCheckIn: $requestedCheckIn, requestedCheckOut: $requestedCheckOut, reason: $reason, status: $status, approvedBy: $approvedBy, approvedAt: $approvedAt, rejectReason: $rejectReason, createdAt: $createdAt, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$AttendanceCorrectionCopyWith<$Res> implements $AttendanceCorrectionCopyWith<$Res> {
  factory _$AttendanceCorrectionCopyWith(_AttendanceCorrection value, $Res Function(_AttendanceCorrection) _then) = __$AttendanceCorrectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, DateTime workDate, String? attendanceId, DateTime? requestedCheckIn, DateTime? requestedCheckOut, String reason, CorrectionStatus status, String? approvedBy, DateTime? approvedAt, String? rejectReason, DateTime createdAt, bool synced
});




}
/// @nodoc
class __$AttendanceCorrectionCopyWithImpl<$Res>
    implements _$AttendanceCorrectionCopyWith<$Res> {
  __$AttendanceCorrectionCopyWithImpl(this._self, this._then);

  final _AttendanceCorrection _self;
  final $Res Function(_AttendanceCorrection) _then;

/// Create a copy of AttendanceCorrection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? workDate = null,Object? attendanceId = freezed,Object? requestedCheckIn = freezed,Object? requestedCheckOut = freezed,Object? reason = null,Object? status = null,Object? approvedBy = freezed,Object? approvedAt = freezed,Object? rejectReason = freezed,Object? createdAt = null,Object? synced = null,}) {
  return _then(_AttendanceCorrection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,attendanceId: freezed == attendanceId ? _self.attendanceId : attendanceId // ignore: cast_nullable_to_non_nullable
as String?,requestedCheckIn: freezed == requestedCheckIn ? _self.requestedCheckIn : requestedCheckIn // ignore: cast_nullable_to_non_nullable
as DateTime?,requestedCheckOut: freezed == requestedCheckOut ? _self.requestedCheckOut : requestedCheckOut // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CorrectionStatus,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
