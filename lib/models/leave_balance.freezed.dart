// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveBalance {

 String get id; String get employeeId; String get leaveTypeId; int get year; double get totalDays; double get usedDays;/// Cột generated trên DB = total_days - used_days.
 double get remainingDays;/// Loại phép (join `leave_types(*)`).
@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? get leaveType;
/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceCopyWith<LeaveBalance> get copyWith => _$LeaveBalanceCopyWithImpl<LeaveBalance>(this as LeaveBalance, _$identity);

  /// Serializes this LeaveBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaveBalance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalance&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.employeeId, _this.employeeId) || other.employeeId == _this.employeeId)&&(identical(other.leaveTypeId, _this.leaveTypeId) || other.leaveTypeId == _this.leaveTypeId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.totalDays, _this.totalDays) || other.totalDays == _this.totalDays)&&(identical(other.usedDays, _this.usedDays) || other.usedDays == _this.usedDays)&&(identical(other.remainingDays, _this.remainingDays) || other.remainingDays == _this.remainingDays)&&(identical(other.leaveType, _this.leaveType) || other.leaveType == _this.leaveType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaveBalance;
  return Object.hash(runtimeType,_this.id,_this.employeeId,_this.leaveTypeId,_this.year,_this.totalDays,_this.usedDays,_this.remainingDays,_this.leaveType);
}

@override
String toString() {
  final _this = this as LeaveBalance;
  return 'LeaveBalance(id: ${_this.id}, employeeId: ${_this.employeeId}, leaveTypeId: ${_this.leaveTypeId}, year: ${_this.year}, totalDays: ${_this.totalDays}, usedDays: ${_this.usedDays}, remainingDays: ${_this.remainingDays}, leaveType: ${_this.leaveType})';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceCopyWith<$Res>  {
  factory $LeaveBalanceCopyWith(LeaveBalance value, $Res Function(LeaveBalance) _then) = _$LeaveBalanceCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, String leaveTypeId, int year, double totalDays, double usedDays, double remainingDays,@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType
});


$LeaveTypeCopyWith<$Res>? get leaveType;

}
/// @nodoc
class _$LeaveBalanceCopyWithImpl<$Res>
    implements $LeaveBalanceCopyWith<$Res> {
  _$LeaveBalanceCopyWithImpl(this._self, this._then);

  final LeaveBalance _self;
  final $Res Function(LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? leaveTypeId = null,Object? year = null,Object? totalDays = null,Object? usedDays = null,Object? remainingDays = null,Object? leaveType = freezed,}) {
  return _then(LeaveBalance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,usedDays: null == usedDays ? _self.usedDays : usedDays // ignore: cast_nullable_to_non_nullable
as double,remainingDays: null == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as double,leaveType: freezed == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType?,
  ));
}
/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeCopyWith<$Res>? get leaveType {
    if (_self.leaveType == null) {
    return null;
  }

  return $LeaveTypeCopyWith<$Res>(_self.leaveType!, (value) {
    return _then(_self.copyWith(leaveType: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveBalance].
extension LeaveBalancePatterns on LeaveBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalance value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  String leaveTypeId,  int year,  double totalDays,  double usedDays,  double remainingDays, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.year,_that.totalDays,_that.usedDays,_that.remainingDays,_that.leaveType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  String leaveTypeId,  int year,  double totalDays,  double usedDays,  double remainingDays, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance():
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.year,_that.totalDays,_that.usedDays,_that.remainingDays,_that.leaveType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  String leaveTypeId,  int year,  double totalDays,  double usedDays,  double remainingDays, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.year,_that.totalDays,_that.usedDays,_that.remainingDays,_that.leaveType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LeaveBalance extends LeaveBalance {
  const _LeaveBalance({required this.id, required this.employeeId, required this.leaveTypeId, required this.year, this.totalDays = 0, this.usedDays = 0, this.remainingDays = 0, @JsonKey(name: 'leave_types', includeToJson: false) this.leaveType}): super._();
  factory _LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);

@override final  String id;
@override final  String employeeId;
@override final  String leaveTypeId;
@override final  int year;
@override@JsonKey() final  double totalDays;
@override@JsonKey() final  double usedDays;
/// Cột generated trên DB = total_days - used_days.
@override@JsonKey() final  double remainingDays;
/// Loại phép (join `leave_types(*)`).
@override@JsonKey(name: 'leave_types', includeToJson: false) final  LeaveType? leaveType;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceCopyWith<_LeaveBalance> get copyWith => __$LeaveBalanceCopyWithImpl<_LeaveBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalance&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.year, year) || other.year == year)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.usedDays, usedDays) || other.usedDays == usedDays)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,employeeId,leaveTypeId,year,totalDays,usedDays,remainingDays,leaveType);
}

@override
String toString() {
    return 'LeaveBalance(id: $id, employeeId: $employeeId, leaveTypeId: $leaveTypeId, year: $year, totalDays: $totalDays, usedDays: $usedDays, remainingDays: $remainingDays, leaveType: $leaveType)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceCopyWith<$Res> implements $LeaveBalanceCopyWith<$Res> {
  factory _$LeaveBalanceCopyWith(_LeaveBalance value, $Res Function(_LeaveBalance) _then) = __$LeaveBalanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, String leaveTypeId, int year, double totalDays, double usedDays, double remainingDays,@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType
});


@override $LeaveTypeCopyWith<$Res>? get leaveType;

}
/// @nodoc
class __$LeaveBalanceCopyWithImpl<$Res>
    implements _$LeaveBalanceCopyWith<$Res> {
  __$LeaveBalanceCopyWithImpl(this._self, this._then);

  final _LeaveBalance _self;
  final $Res Function(_LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? leaveTypeId = null,Object? year = null,Object? totalDays = null,Object? usedDays = null,Object? remainingDays = null,Object? leaveType = freezed,}) {
  return _then(_LeaveBalance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,usedDays: null == usedDays ? _self.usedDays : usedDays // ignore: cast_nullable_to_non_nullable
as double,remainingDays: null == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as double,leaveType: freezed == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType?,
  ));
}

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveTypeCopyWith<$Res>? get leaveType {
    if (_self.leaveType == null) {
    return null;
  }

  return $LeaveTypeCopyWith<$Res>(_self.leaveType!, (value) {
    return _then(_self.copyWith(leaveType: value));
  });
}
}

// dart format on
