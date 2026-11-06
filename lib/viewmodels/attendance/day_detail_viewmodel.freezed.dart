// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_detail_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayDetailState {

 DateTime get day; AttendanceRecord? get record; AttendanceStatus get status; WorkShift get shift; int get lateMinutes;/// Đơn bù công của ngày, mới nhất trước.
 List<AttendanceCorrection> get corrections;
/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayDetailStateCopyWith<DayDetailState> get copyWith => _$DayDetailStateCopyWithImpl<DayDetailState>(this as DayDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayDetailState&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.record, _this.record) || other.record == _this.record)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.lateMinutes, _this.lateMinutes) || other.lateMinutes == _this.lateMinutes)&&const DeepCollectionEquality().equals(other.corrections, _this.corrections));
}


@override
int get hashCode {
  final _this = this as DayDetailState;
  return Object.hash(runtimeType,_this.day,_this.record,_this.status,_this.shift,_this.lateMinutes,const DeepCollectionEquality().hash(_this.corrections));
}

@override
String toString() {
  final _this = this as DayDetailState;
  return 'DayDetailState(day: ${_this.day}, record: ${_this.record}, status: ${_this.status}, shift: ${_this.shift}, lateMinutes: ${_this.lateMinutes}, corrections: ${_this.corrections})';
}


}

/// @nodoc
abstract mixin class $DayDetailStateCopyWith<$Res>  {
  factory $DayDetailStateCopyWith(DayDetailState value, $Res Function(DayDetailState) _then) = _$DayDetailStateCopyWithImpl;
@useResult
$Res call({
 DateTime day, AttendanceRecord? record, AttendanceStatus status, WorkShift shift, int lateMinutes, List<AttendanceCorrection> corrections
});


$AttendanceRecordCopyWith<$Res>? get record;

}
/// @nodoc
class _$DayDetailStateCopyWithImpl<$Res>
    implements $DayDetailStateCopyWith<$Res> {
  _$DayDetailStateCopyWithImpl(this._self, this._then);

  final DayDetailState _self;
  final $Res Function(DayDetailState) _then;

/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? record = freezed,Object? status = null,Object? shift = null,Object? lateMinutes = null,Object? corrections = null,}) {
  return _then(DayDetailState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as WorkShift,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,corrections: null == corrections ? _self.corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<AttendanceCorrection>,
  ));
}
/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}


/// Adds pattern-matching-related methods to [DayDetailState].
extension DayDetailStatePatterns on DayDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayDetailState value)  $default,){
final _that = this;
switch (_that) {
case _DayDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _DayDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  AttendanceRecord? record,  AttendanceStatus status,  WorkShift shift,  int lateMinutes,  List<AttendanceCorrection> corrections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayDetailState() when $default != null:
return $default(_that.day,_that.record,_that.status,_that.shift,_that.lateMinutes,_that.corrections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  AttendanceRecord? record,  AttendanceStatus status,  WorkShift shift,  int lateMinutes,  List<AttendanceCorrection> corrections)  $default,) {final _that = this;
switch (_that) {
case _DayDetailState():
return $default(_that.day,_that.record,_that.status,_that.shift,_that.lateMinutes,_that.corrections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  AttendanceRecord? record,  AttendanceStatus status,  WorkShift shift,  int lateMinutes,  List<AttendanceCorrection> corrections)?  $default,) {final _that = this;
switch (_that) {
case _DayDetailState() when $default != null:
return $default(_that.day,_that.record,_that.status,_that.shift,_that.lateMinutes,_that.corrections);case _:
  return null;

}
}

}

/// @nodoc


class _DayDetailState extends DayDetailState {
  const _DayDetailState({required this.day, required this.record, required this.status, required this.shift, required this.lateMinutes, required  List<AttendanceCorrection> corrections}): _corrections = corrections,super._();
  

@override final  DateTime day;
@override final  AttendanceRecord? record;
@override final  AttendanceStatus status;
@override final  WorkShift shift;
@override final  int lateMinutes;
/// Đơn bù công của ngày, mới nhất trước.
 final  List<AttendanceCorrection> _corrections;
/// Đơn bù công của ngày, mới nhất trước.
@override List<AttendanceCorrection> get corrections {
  if (_corrections is EqualUnmodifiableListView) return _corrections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_corrections);
}


/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayDetailStateCopyWith<_DayDetailState> get copyWith => __$DayDetailStateCopyWithImpl<_DayDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayDetailState&&(identical(other.day, day) || other.day == day)&&(identical(other.record, record) || other.record == record)&&(identical(other.status, status) || other.status == status)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.lateMinutes, lateMinutes) || other.lateMinutes == lateMinutes)&&const DeepCollectionEquality().equals(other.corrections, _corrections));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,record,status,shift,lateMinutes,const DeepCollectionEquality().hash(_corrections));
}

@override
String toString() {
    return 'DayDetailState(day: $day, record: $record, status: $status, shift: $shift, lateMinutes: $lateMinutes, corrections: $corrections)';
}


}

/// @nodoc
abstract mixin class _$DayDetailStateCopyWith<$Res> implements $DayDetailStateCopyWith<$Res> {
  factory _$DayDetailStateCopyWith(_DayDetailState value, $Res Function(_DayDetailState) _then) = __$DayDetailStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, AttendanceRecord? record, AttendanceStatus status, WorkShift shift, int lateMinutes, List<AttendanceCorrection> corrections
});


@override $AttendanceRecordCopyWith<$Res>? get record;

}
/// @nodoc
class __$DayDetailStateCopyWithImpl<$Res>
    implements _$DayDetailStateCopyWith<$Res> {
  __$DayDetailStateCopyWithImpl(this._self, this._then);

  final _DayDetailState _self;
  final $Res Function(_DayDetailState) _then;

/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? record = freezed,Object? status = null,Object? shift = null,Object? lateMinutes = null,Object? corrections = null,}) {
  return _then(_DayDetailState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as WorkShift,lateMinutes: null == lateMinutes ? _self.lateMinutes : lateMinutes // ignore: cast_nullable_to_non_nullable
as int,corrections: null == corrections ? _self._corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<AttendanceCorrection>,
  ));
}

/// Create a copy of DayDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

// dart format on
