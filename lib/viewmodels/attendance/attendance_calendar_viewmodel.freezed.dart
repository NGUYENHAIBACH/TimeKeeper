// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_calendar_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalendarState {

/// Ngày 1 của tháng đang xem.
 DateTime get month;/// Bản ghi theo ngày, key = `yyyy-MM-dd`.
 Map<String, AttendanceRecord> get records;/// Trạng thái theo ngày (không có ngày chưa tới), key = `yyyy-MM-dd`.
 Map<String, AttendanceStatus> get statuses;/// Các ngày có đơn bù công đang chờ duyệt.
 Set<String> get pendingCorrectionDays; Duration get totalWorked; int get totalLateMinutes;
/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarStateCopyWith<CalendarState> get copyWith => _$CalendarStateCopyWithImpl<CalendarState>(this as CalendarState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CalendarState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarState&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.records, _this.records)&&const DeepCollectionEquality().equals(other.statuses, _this.statuses)&&const DeepCollectionEquality().equals(other.pendingCorrectionDays, _this.pendingCorrectionDays)&&(identical(other.totalWorked, _this.totalWorked) || other.totalWorked == _this.totalWorked)&&(identical(other.totalLateMinutes, _this.totalLateMinutes) || other.totalLateMinutes == _this.totalLateMinutes));
}


@override
int get hashCode {
  final _this = this as CalendarState;
  return Object.hash(runtimeType,_this.month,const DeepCollectionEquality().hash(_this.records),const DeepCollectionEquality().hash(_this.statuses),const DeepCollectionEquality().hash(_this.pendingCorrectionDays),_this.totalWorked,_this.totalLateMinutes);
}

@override
String toString() {
  final _this = this as CalendarState;
  return 'CalendarState(month: ${_this.month}, records: ${_this.records}, statuses: ${_this.statuses}, pendingCorrectionDays: ${_this.pendingCorrectionDays}, totalWorked: ${_this.totalWorked}, totalLateMinutes: ${_this.totalLateMinutes})';
}


}

/// @nodoc
abstract mixin class $CalendarStateCopyWith<$Res>  {
  factory $CalendarStateCopyWith(CalendarState value, $Res Function(CalendarState) _then) = _$CalendarStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, Map<String, AttendanceRecord> records, Map<String, AttendanceStatus> statuses, Set<String> pendingCorrectionDays, Duration totalWorked, int totalLateMinutes
});




}
/// @nodoc
class _$CalendarStateCopyWithImpl<$Res>
    implements $CalendarStateCopyWith<$Res> {
  _$CalendarStateCopyWithImpl(this._self, this._then);

  final CalendarState _self;
  final $Res Function(CalendarState) _then;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? records = null,Object? statuses = null,Object? pendingCorrectionDays = null,Object? totalWorked = null,Object? totalLateMinutes = null,}) {
  return _then(CalendarState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as Map<String, AttendanceRecord>,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, AttendanceStatus>,pendingCorrectionDays: null == pendingCorrectionDays ? _self.pendingCorrectionDays : pendingCorrectionDays // ignore: cast_nullable_to_non_nullable
as Set<String>,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,totalLateMinutes: null == totalLateMinutes ? _self.totalLateMinutes : totalLateMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarState].
extension CalendarStatePatterns on CalendarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarState value)  $default,){
final _that = this;
switch (_that) {
case _CalendarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarState value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  Map<String, AttendanceRecord> records,  Map<String, AttendanceStatus> statuses,  Set<String> pendingCorrectionDays,  Duration totalWorked,  int totalLateMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
return $default(_that.month,_that.records,_that.statuses,_that.pendingCorrectionDays,_that.totalWorked,_that.totalLateMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  Map<String, AttendanceRecord> records,  Map<String, AttendanceStatus> statuses,  Set<String> pendingCorrectionDays,  Duration totalWorked,  int totalLateMinutes)  $default,) {final _that = this;
switch (_that) {
case _CalendarState():
return $default(_that.month,_that.records,_that.statuses,_that.pendingCorrectionDays,_that.totalWorked,_that.totalLateMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  Map<String, AttendanceRecord> records,  Map<String, AttendanceStatus> statuses,  Set<String> pendingCorrectionDays,  Duration totalWorked,  int totalLateMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
return $default(_that.month,_that.records,_that.statuses,_that.pendingCorrectionDays,_that.totalWorked,_that.totalLateMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _CalendarState extends CalendarState {
  const _CalendarState({required this.month, required  Map<String, AttendanceRecord> records, required  Map<String, AttendanceStatus> statuses, required  Set<String> pendingCorrectionDays, required this.totalWorked, required this.totalLateMinutes}): _records = records,_statuses = statuses,_pendingCorrectionDays = pendingCorrectionDays,super._();
  

/// Ngày 1 của tháng đang xem.
@override final  DateTime month;
/// Bản ghi theo ngày, key = `yyyy-MM-dd`.
 final  Map<String, AttendanceRecord> _records;
/// Bản ghi theo ngày, key = `yyyy-MM-dd`.
@override Map<String, AttendanceRecord> get records {
  if (_records is EqualUnmodifiableMapView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_records);
}

/// Trạng thái theo ngày (không có ngày chưa tới), key = `yyyy-MM-dd`.
 final  Map<String, AttendanceStatus> _statuses;
/// Trạng thái theo ngày (không có ngày chưa tới), key = `yyyy-MM-dd`.
@override Map<String, AttendanceStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

/// Các ngày có đơn bù công đang chờ duyệt.
 final  Set<String> _pendingCorrectionDays;
/// Các ngày có đơn bù công đang chờ duyệt.
@override Set<String> get pendingCorrectionDays {
  if (_pendingCorrectionDays is EqualUnmodifiableSetView) return _pendingCorrectionDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingCorrectionDays);
}

@override final  Duration totalWorked;
@override final  int totalLateMinutes;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarStateCopyWith<_CalendarState> get copyWith => __$CalendarStateCopyWithImpl<_CalendarState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarState&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.records, _records)&&const DeepCollectionEquality().equals(other.statuses, _statuses)&&const DeepCollectionEquality().equals(other.pendingCorrectionDays, _pendingCorrectionDays)&&(identical(other.totalWorked, totalWorked) || other.totalWorked == totalWorked)&&(identical(other.totalLateMinutes, totalLateMinutes) || other.totalLateMinutes == totalLateMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_records),const DeepCollectionEquality().hash(_statuses),const DeepCollectionEquality().hash(_pendingCorrectionDays),totalWorked,totalLateMinutes);
}

@override
String toString() {
    return 'CalendarState(month: $month, records: $records, statuses: $statuses, pendingCorrectionDays: $pendingCorrectionDays, totalWorked: $totalWorked, totalLateMinutes: $totalLateMinutes)';
}


}

/// @nodoc
abstract mixin class _$CalendarStateCopyWith<$Res> implements $CalendarStateCopyWith<$Res> {
  factory _$CalendarStateCopyWith(_CalendarState value, $Res Function(_CalendarState) _then) = __$CalendarStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, Map<String, AttendanceRecord> records, Map<String, AttendanceStatus> statuses, Set<String> pendingCorrectionDays, Duration totalWorked, int totalLateMinutes
});




}
/// @nodoc
class __$CalendarStateCopyWithImpl<$Res>
    implements _$CalendarStateCopyWith<$Res> {
  __$CalendarStateCopyWithImpl(this._self, this._then);

  final _CalendarState _self;
  final $Res Function(_CalendarState) _then;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? records = null,Object? statuses = null,Object? pendingCorrectionDays = null,Object? totalWorked = null,Object? totalLateMinutes = null,}) {
  return _then(_CalendarState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as Map<String, AttendanceRecord>,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, AttendanceStatus>,pendingCorrectionDays: null == pendingCorrectionDays ? _self._pendingCorrectionDays : pendingCorrectionDays // ignore: cast_nullable_to_non_nullable
as Set<String>,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,totalLateMinutes: null == totalLateMinutes ? _self.totalLateMinutes : totalLateMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
