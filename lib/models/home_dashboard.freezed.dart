// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeDashboard {

 Profile get profile;/// Bản ghi chấm công hôm nay (model của TV2). Null = chưa chấm công.
 AttendanceRecord? get today; MonthlySummary get summary; LeaveBalanceSummary get leave;
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<HomeDashboard> get copyWith => _$HomeDashboardCopyWithImpl<HomeDashboard>(this as HomeDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboard&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.leave, _this.leave) || other.leave == _this.leave));
}


@override
int get hashCode {
  final _this = this as HomeDashboard;
  return Object.hash(runtimeType,_this.profile,_this.today,_this.summary,_this.leave);
}

@override
String toString() {
  final _this = this as HomeDashboard;
  return 'HomeDashboard(profile: ${_this.profile}, today: ${_this.today}, summary: ${_this.summary}, leave: ${_this.leave})';
}


}

/// @nodoc
abstract mixin class $HomeDashboardCopyWith<$Res>  {
  factory $HomeDashboardCopyWith(HomeDashboard value, $Res Function(HomeDashboard) _then) = _$HomeDashboardCopyWithImpl;
@useResult
$Res call({
 Profile profile, AttendanceRecord? today, MonthlySummary summary, LeaveBalanceSummary leave
});


$ProfileCopyWith<$Res> get profile;$AttendanceRecordCopyWith<$Res>? get today;$MonthlySummaryCopyWith<$Res> get summary;$LeaveBalanceSummaryCopyWith<$Res> get leave;

}
/// @nodoc
class _$HomeDashboardCopyWithImpl<$Res>
    implements $HomeDashboardCopyWith<$Res> {
  _$HomeDashboardCopyWithImpl(this._self, this._then);

  final HomeDashboard _self;
  final $Res Function(HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? today = freezed,Object? summary = null,Object? leave = null,}) {
  return _then(HomeDashboard(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthlySummary,leave: null == leave ? _self.leave : leave // ignore: cast_nullable_to_non_nullable
as LeaveBalanceSummary,
  ));
}
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res> get profile {
  
  return $ProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of HomeDashboard
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
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<$Res> get summary {
  
  return $MonthlySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceSummaryCopyWith<$Res> get leave {
  
  return $LeaveBalanceSummaryCopyWith<$Res>(_self.leave, (value) {
    return _then(_self.copyWith(leave: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeDashboard].
extension HomeDashboardPatterns on HomeDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboard value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Profile profile,  AttendanceRecord? today,  MonthlySummary summary,  LeaveBalanceSummary leave)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.profile,_that.today,_that.summary,_that.leave);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Profile profile,  AttendanceRecord? today,  MonthlySummary summary,  LeaveBalanceSummary leave)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard():
return $default(_that.profile,_that.today,_that.summary,_that.leave);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Profile profile,  AttendanceRecord? today,  MonthlySummary summary,  LeaveBalanceSummary leave)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.profile,_that.today,_that.summary,_that.leave);case _:
  return null;

}
}

}

/// @nodoc


class _HomeDashboard implements HomeDashboard {
  const _HomeDashboard({required this.profile, this.today, required this.summary, required this.leave});
  

@override final  Profile profile;
/// Bản ghi chấm công hôm nay (model của TV2). Null = chưa chấm công.
@override final  AttendanceRecord? today;
@override final  MonthlySummary summary;
@override final  LeaveBalanceSummary leave;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardCopyWith<_HomeDashboard> get copyWith => __$HomeDashboardCopyWithImpl<_HomeDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboard&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.today, today) || other.today == today)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.leave, leave) || other.leave == leave));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile,today,summary,leave);
}

@override
String toString() {
    return 'HomeDashboard(profile: $profile, today: $today, summary: $summary, leave: $leave)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardCopyWith<$Res> implements $HomeDashboardCopyWith<$Res> {
  factory _$HomeDashboardCopyWith(_HomeDashboard value, $Res Function(_HomeDashboard) _then) = __$HomeDashboardCopyWithImpl;
@override @useResult
$Res call({
 Profile profile, AttendanceRecord? today, MonthlySummary summary, LeaveBalanceSummary leave
});


@override $ProfileCopyWith<$Res> get profile;@override $AttendanceRecordCopyWith<$Res>? get today;@override $MonthlySummaryCopyWith<$Res> get summary;@override $LeaveBalanceSummaryCopyWith<$Res> get leave;

}
/// @nodoc
class __$HomeDashboardCopyWithImpl<$Res>
    implements _$HomeDashboardCopyWith<$Res> {
  __$HomeDashboardCopyWithImpl(this._self, this._then);

  final _HomeDashboard _self;
  final $Res Function(_HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? today = freezed,Object? summary = null,Object? leave = null,}) {
  return _then(_HomeDashboard(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthlySummary,leave: null == leave ? _self.leave : leave // ignore: cast_nullable_to_non_nullable
as LeaveBalanceSummary,
  ));
}

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res> get profile {
  
  return $ProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of HomeDashboard
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
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<$Res> get summary {
  
  return $MonthlySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaveBalanceSummaryCopyWith<$Res> get leave {
  
  return $LeaveBalanceSummaryCopyWith<$Res>(_self.leave, (value) {
    return _then(_self.copyWith(leave: value));
  });
}
}

// dart format on
