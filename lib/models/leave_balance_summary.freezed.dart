// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeaveBalanceSummary {

 double get totalDays; double get usedDays;
/// Create a copy of LeaveBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceSummaryCopyWith<LeaveBalanceSummary> get copyWith => _$LeaveBalanceSummaryCopyWithImpl<LeaveBalanceSummary>(this as LeaveBalanceSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LeaveBalanceSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceSummary&&(identical(other.totalDays, _this.totalDays) || other.totalDays == _this.totalDays)&&(identical(other.usedDays, _this.usedDays) || other.usedDays == _this.usedDays));
}


@override
int get hashCode {
  final _this = this as LeaveBalanceSummary;
  return Object.hash(runtimeType,_this.totalDays,_this.usedDays);
}

@override
String toString() {
  final _this = this as LeaveBalanceSummary;
  return 'LeaveBalanceSummary(totalDays: ${_this.totalDays}, usedDays: ${_this.usedDays})';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceSummaryCopyWith<$Res>  {
  factory $LeaveBalanceSummaryCopyWith(LeaveBalanceSummary value, $Res Function(LeaveBalanceSummary) _then) = _$LeaveBalanceSummaryCopyWithImpl;
@useResult
$Res call({
 double totalDays, double usedDays
});




}
/// @nodoc
class _$LeaveBalanceSummaryCopyWithImpl<$Res>
    implements $LeaveBalanceSummaryCopyWith<$Res> {
  _$LeaveBalanceSummaryCopyWithImpl(this._self, this._then);

  final LeaveBalanceSummary _self;
  final $Res Function(LeaveBalanceSummary) _then;

/// Create a copy of LeaveBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalDays = null,Object? usedDays = null,}) {
  return _then(LeaveBalanceSummary(
totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,usedDays: null == usedDays ? _self.usedDays : usedDays // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalanceSummary].
extension LeaveBalanceSummaryPatterns on LeaveBalanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalDays,  double usedDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceSummary() when $default != null:
return $default(_that.totalDays,_that.usedDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalDays,  double usedDays)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceSummary():
return $default(_that.totalDays,_that.usedDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalDays,  double usedDays)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceSummary() when $default != null:
return $default(_that.totalDays,_that.usedDays);case _:
  return null;

}
}

}

/// @nodoc


class _LeaveBalanceSummary extends LeaveBalanceSummary {
  const _LeaveBalanceSummary({this.totalDays = 0, this.usedDays = 0}): super._();
  

@override@JsonKey() final  double totalDays;
@override@JsonKey() final  double usedDays;

/// Create a copy of LeaveBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceSummaryCopyWith<_LeaveBalanceSummary> get copyWith => __$LeaveBalanceSummaryCopyWithImpl<_LeaveBalanceSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceSummary&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.usedDays, usedDays) || other.usedDays == usedDays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalDays,usedDays);
}

@override
String toString() {
    return 'LeaveBalanceSummary(totalDays: $totalDays, usedDays: $usedDays)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceSummaryCopyWith<$Res> implements $LeaveBalanceSummaryCopyWith<$Res> {
  factory _$LeaveBalanceSummaryCopyWith(_LeaveBalanceSummary value, $Res Function(_LeaveBalanceSummary) _then) = __$LeaveBalanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 double totalDays, double usedDays
});




}
/// @nodoc
class __$LeaveBalanceSummaryCopyWithImpl<$Res>
    implements _$LeaveBalanceSummaryCopyWith<$Res> {
  __$LeaveBalanceSummaryCopyWithImpl(this._self, this._then);

  final _LeaveBalanceSummary _self;
  final $Res Function(_LeaveBalanceSummary) _then;

/// Create a copy of LeaveBalanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalDays = null,Object? usedDays = null,}) {
  return _then(_LeaveBalanceSummary(
totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,usedDays: null == usedDays ? _self.usedDays : usedDays // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
