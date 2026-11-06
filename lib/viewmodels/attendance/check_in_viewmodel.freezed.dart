// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckInState {

 OfficeLocation? get office;/// Bản ghi hôm nay (null = chưa check-in).
 AttendanceRecord? get today; AttendanceStatus get todayStatus; GeoPoint? get position;/// Khoảng cách tới văn phòng (mét).
 double? get distanceMeters; String? get locationError; bool get isLocating; bool get isSubmitting;
/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInStateCopyWith<CheckInState> get copyWith => _$CheckInStateCopyWithImpl<CheckInState>(this as CheckInState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckInState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInState&&(identical(other.office, _this.office) || other.office == _this.office)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.todayStatus, _this.todayStatus) || other.todayStatus == _this.todayStatus)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.locationError, _this.locationError) || other.locationError == _this.locationError)&&(identical(other.isLocating, _this.isLocating) || other.isLocating == _this.isLocating)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting));
}


@override
int get hashCode {
  final _this = this as CheckInState;
  return Object.hash(runtimeType,_this.office,_this.today,_this.todayStatus,_this.position,_this.distanceMeters,_this.locationError,_this.isLocating,_this.isSubmitting);
}

@override
String toString() {
  final _this = this as CheckInState;
  return 'CheckInState(office: ${_this.office}, today: ${_this.today}, todayStatus: ${_this.todayStatus}, position: ${_this.position}, distanceMeters: ${_this.distanceMeters}, locationError: ${_this.locationError}, isLocating: ${_this.isLocating}, isSubmitting: ${_this.isSubmitting})';
}


}

/// @nodoc
abstract mixin class $CheckInStateCopyWith<$Res>  {
  factory $CheckInStateCopyWith(CheckInState value, $Res Function(CheckInState) _then) = _$CheckInStateCopyWithImpl;
@useResult
$Res call({
 OfficeLocation? office, AttendanceRecord? today, AttendanceStatus todayStatus, GeoPoint? position, double? distanceMeters, String? locationError, bool isLocating, bool isSubmitting
});


$OfficeLocationCopyWith<$Res>? get office;$AttendanceRecordCopyWith<$Res>? get today;

}
/// @nodoc
class _$CheckInStateCopyWithImpl<$Res>
    implements $CheckInStateCopyWith<$Res> {
  _$CheckInStateCopyWithImpl(this._self, this._then);

  final CheckInState _self;
  final $Res Function(CheckInState) _then;

/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? office = freezed,Object? today = freezed,Object? todayStatus = null,Object? position = freezed,Object? distanceMeters = freezed,Object? locationError = freezed,Object? isLocating = null,Object? isSubmitting = null,}) {
  return _then(CheckInState(
office: freezed == office ? _self.office : office // ignore: cast_nullable_to_non_nullable
as OfficeLocation?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,todayStatus: null == todayStatus ? _self.todayStatus : todayStatus // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPoint?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,locationError: freezed == locationError ? _self.locationError : locationError // ignore: cast_nullable_to_non_nullable
as String?,isLocating: null == isLocating ? _self.isLocating : isLocating // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfficeLocationCopyWith<$Res>? get office {
    if (_self.office == null) {
    return null;
  }

  return $OfficeLocationCopyWith<$Res>(_self.office!, (value) {
    return _then(_self.copyWith(office: value));
  });
}/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckInState].
extension CheckInStatePatterns on CheckInState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInState value)  $default,){
final _that = this;
switch (_that) {
case _CheckInState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OfficeLocation? office,  AttendanceRecord? today,  AttendanceStatus todayStatus,  GeoPoint? position,  double? distanceMeters,  String? locationError,  bool isLocating,  bool isSubmitting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInState() when $default != null:
return $default(_that.office,_that.today,_that.todayStatus,_that.position,_that.distanceMeters,_that.locationError,_that.isLocating,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OfficeLocation? office,  AttendanceRecord? today,  AttendanceStatus todayStatus,  GeoPoint? position,  double? distanceMeters,  String? locationError,  bool isLocating,  bool isSubmitting)  $default,) {final _that = this;
switch (_that) {
case _CheckInState():
return $default(_that.office,_that.today,_that.todayStatus,_that.position,_that.distanceMeters,_that.locationError,_that.isLocating,_that.isSubmitting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OfficeLocation? office,  AttendanceRecord? today,  AttendanceStatus todayStatus,  GeoPoint? position,  double? distanceMeters,  String? locationError,  bool isLocating,  bool isSubmitting)?  $default,) {final _that = this;
switch (_that) {
case _CheckInState() when $default != null:
return $default(_that.office,_that.today,_that.todayStatus,_that.position,_that.distanceMeters,_that.locationError,_that.isLocating,_that.isSubmitting);case _:
  return null;

}
}

}

/// @nodoc


class _CheckInState extends CheckInState {
  const _CheckInState({required this.office, required this.today, required this.todayStatus, this.position, this.distanceMeters, this.locationError, this.isLocating = false, this.isSubmitting = false}): super._();
  

@override final  OfficeLocation? office;
/// Bản ghi hôm nay (null = chưa check-in).
@override final  AttendanceRecord? today;
@override final  AttendanceStatus todayStatus;
@override final  GeoPoint? position;
/// Khoảng cách tới văn phòng (mét).
@override final  double? distanceMeters;
@override final  String? locationError;
@override@JsonKey() final  bool isLocating;
@override@JsonKey() final  bool isSubmitting;

/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInStateCopyWith<_CheckInState> get copyWith => __$CheckInStateCopyWithImpl<_CheckInState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInState&&(identical(other.office, office) || other.office == office)&&(identical(other.today, today) || other.today == today)&&(identical(other.todayStatus, todayStatus) || other.todayStatus == todayStatus)&&(identical(other.position, position) || other.position == position)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.locationError, locationError) || other.locationError == locationError)&&(identical(other.isLocating, isLocating) || other.isLocating == isLocating)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode {
    return Object.hash(runtimeType,office,today,todayStatus,position,distanceMeters,locationError,isLocating,isSubmitting);
}

@override
String toString() {
    return 'CheckInState(office: $office, today: $today, todayStatus: $todayStatus, position: $position, distanceMeters: $distanceMeters, locationError: $locationError, isLocating: $isLocating, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class _$CheckInStateCopyWith<$Res> implements $CheckInStateCopyWith<$Res> {
  factory _$CheckInStateCopyWith(_CheckInState value, $Res Function(_CheckInState) _then) = __$CheckInStateCopyWithImpl;
@override @useResult
$Res call({
 OfficeLocation? office, AttendanceRecord? today, AttendanceStatus todayStatus, GeoPoint? position, double? distanceMeters, String? locationError, bool isLocating, bool isSubmitting
});


@override $OfficeLocationCopyWith<$Res>? get office;@override $AttendanceRecordCopyWith<$Res>? get today;

}
/// @nodoc
class __$CheckInStateCopyWithImpl<$Res>
    implements _$CheckInStateCopyWith<$Res> {
  __$CheckInStateCopyWithImpl(this._self, this._then);

  final _CheckInState _self;
  final $Res Function(_CheckInState) _then;

/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? office = freezed,Object? today = freezed,Object? todayStatus = null,Object? position = freezed,Object? distanceMeters = freezed,Object? locationError = freezed,Object? isLocating = null,Object? isSubmitting = null,}) {
  return _then(_CheckInState(
office: freezed == office ? _self.office : office // ignore: cast_nullable_to_non_nullable
as OfficeLocation?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,todayStatus: null == todayStatus ? _self.todayStatus : todayStatus // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPoint?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,locationError: freezed == locationError ? _self.locationError : locationError // ignore: cast_nullable_to_non_nullable
as String?,isLocating: null == isLocating ? _self.isLocating : isLocating // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfficeLocationCopyWith<$Res>? get office {
    if (_self.office == null) {
    return null;
  }

  return $OfficeLocationCopyWith<$Res>(_self.office!, (value) {
    return _then(_self.copyWith(office: value));
  });
}/// Create a copy of CheckInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

// dart format on
