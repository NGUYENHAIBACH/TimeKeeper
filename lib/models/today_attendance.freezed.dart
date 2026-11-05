// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodayAttendance {

 String get id; DateTime get workDate; DateTime? get checkInAt; DateTime? get checkOutAt; String get status; int get lateMinutes; double get workHours;
/// Create a copy of TodayAttendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayAttendanceCopyWith<TodayAttendance> get copyWith => _$TodayAttendanceCopyWithImpl<TodayAttendance>(this as TodayAttendance, _$identity);

  /// Serializes this TodayAttendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TodayAttendance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayAttendance&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.checkInAt, _this.checkInAt) || other.checkInAt == _this.checkInAt)&&(identical(other.checkOutAt, _this.checkOutAt) || other.checkOutAt == _this.checkOutAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.lateMinutes, _this.lateMinutes) || other.lateMinutes == _this.lateMinutes)&&(identical(other.workHours, _this.workHours) || other.workHours == _this.workHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TodayAttendance;
  return Object.hash(runtimeType,_this.id,_this.workDate,_this.checkInAt,_this.checkOutAt,_this.status,_this.lateMinutes,_this.workHours);
}

@override
String toString() {
  final _this = this as TodayAttendance;
  return 'TodayAttendance(id: ${_this.id}, workDate: ${_this.workDate}, checkInAt: ${_this.checkInAt}, checkOutAt: ${_this.checkOutAt}, status: ${_this.status}, lateMinutes: ${_this.lateMinutes}, workHours: ${_this.workHours})';
}


}

/// @nodoc
abstract mixin class $TodayAttendanceCopyWith<$Res>  {
  factory $TodayAttendanceCopyWith(TodayAttendance value, $Res Function(TodayAttendance) _then) = _$TodayAttendanceCopyWithImpl;
@useResult
$Res call({
 String id, DateTime workDate, DateTime? checkInAt, DateTime? checkOutAt, String status, int lateMinutes, double workHours
});




}
/// @nodoc
class _$TodayAttendanceCopyWithImpl<$Res>
    implements $TodayAttendanceCopyWith<$Res> {
  _$TodayAttendanceCopyWithImpl(this._self, this._then);

  final TodayAttendance _self;
  final $Res Function(TodayAttendance) _then;

/// Create a copy of TodayAttendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workDate = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? status = null,Object? lateMinutes = null,Object? workHours = null,}) {
  return _then(TodayAttendance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,workHours: null == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayAttendance].
extension TodayAttendancePatterns on TodayAttendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayAttendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayAttendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayAttendance value)  $default,){
final _that = this;
switch (_that) {
case _TodayAttendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayAttendance value)?  $default,){
final _that = this;
switch (_that) {
case _TodayAttendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  String status,  int lateMinutes,  double workHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayAttendance() when $default != null:
return $default(_that.id,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.status,_that.lateMinutes,_that.workHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  String status,  int lateMinutes,  double workHours)  $default,) {final _that = this;
switch (_that) {
case _TodayAttendance():
return $default(_that.id,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.status,_that.lateMinutes,_that.workHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime workDate,  DateTime? checkInAt,  DateTime? checkOutAt,  String status,  int lateMinutes,  double workHours)?  $default,) {final _that = this;
switch (_that) {
case _TodayAttendance() when $default != null:
return $default(_that.id,_that.workDate,_that.checkInAt,_that.checkOutAt,_that.status,_that.lateMinutes,_that.workHours);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TodayAttendance extends TodayAttendance {
  const _TodayAttendance({required this.id, required this.workDate, this.checkInAt, this.checkOutAt, this.status = 'present', this.lateMinutes = 0, this.workHours = 0}): super._();
  factory _TodayAttendance.fromJson(Map<String, dynamic> json) => _$TodayAttendanceFromJson(json);

@override final  String id;
@override final  DateTime workDate;
@override final  DateTime? checkInAt;
@override final  DateTime? checkOutAt;
@override@JsonKey() final  String status;
@override@JsonKey() final  int lateMinutes;
@override@JsonKey() final  double workHours;

/// Create a copy of TodayAttendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayAttendanceCopyWith<_TodayAttendance> get copyWith => __$TodayAttendanceCopyWithImpl<_TodayAttendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayAttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayAttendance&&(identical(other.id, id) || other.id == id)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.lateMinutes, lateMinutes) || other.lateMinutes == lateMinutes)&&(identical(other.workHours, workHours) || other.workHours == workHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,workDate,checkInAt,checkOutAt,status,lateMinutes,workHours);
}

@override
String toString() {
    return 'TodayAttendance(id: $id, workDate: $workDate, checkInAt: $checkInAt, checkOutAt: $checkOutAt, status: $status, lateMinutes: $lateMinutes, workHours: $workHours)';
}


}

/// @nodoc
abstract mixin class _$TodayAttendanceCopyWith<$Res> implements $TodayAttendanceCopyWith<$Res> {
  factory _$TodayAttendanceCopyWith(_TodayAttendance value, $Res Function(_TodayAttendance) _then) = __$TodayAttendanceCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime workDate, DateTime? checkInAt, DateTime? checkOutAt, String status, int lateMinutes, double workHours
});




}
/// @nodoc
class __$TodayAttendanceCopyWithImpl<$Res>
    implements _$TodayAttendanceCopyWith<$Res> {
  __$TodayAttendanceCopyWithImpl(this._self, this._then);

  final _TodayAttendance _self;
  final $Res Function(_TodayAttendance) _then;

/// Create a copy of TodayAttendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workDate = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? status = null,Object? lateMinutes = null,Object? workHours = null,}) {
  return _then(_TodayAttendance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,workHours: null == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
