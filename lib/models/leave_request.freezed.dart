// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveRequest {

 String get id; String get employeeId; String get leaveTypeId; DateTime get startDate; DateTime get endDate; HalfDay get halfDay;/// Số ngày nghỉ thực (đã trừ cuối tuần, ngày lễ; nửa ngày = 0.5).
 double get totalDays; String get reason; String? get attachmentUrl; LeaveStatus get status; String? get approvedBy; DateTime? get approvedAt; String? get rejectReason; DateTime? get createdAt;/// Loại phép (join `leave_types(*)`).
@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? get leaveType;/// Tên người nghỉ (join `profiles`), chỉ có ở lịch nghỉ team.
@JsonKey(includeToJson: false) String? get employeeName;
/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveRequestCopyWith<LeaveRequest> get copyWith => _$LeaveRequestCopyWithImpl<LeaveRequest>(this as LeaveRequest, _$identity);

  /// Serializes this LeaveRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaveRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.employeeId, _this.employeeId) || other.employeeId == _this.employeeId)&&(identical(other.leaveTypeId, _this.leaveTypeId) || other.leaveTypeId == _this.leaveTypeId)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.halfDay, _this.halfDay) || other.halfDay == _this.halfDay)&&(identical(other.totalDays, _this.totalDays) || other.totalDays == _this.totalDays)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.attachmentUrl, _this.attachmentUrl) || other.attachmentUrl == _this.attachmentUrl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.approvedBy, _this.approvedBy) || other.approvedBy == _this.approvedBy)&&(identical(other.approvedAt, _this.approvedAt) || other.approvedAt == _this.approvedAt)&&(identical(other.rejectReason, _this.rejectReason) || other.rejectReason == _this.rejectReason)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.leaveType, _this.leaveType) || other.leaveType == _this.leaveType)&&(identical(other.employeeName, _this.employeeName) || other.employeeName == _this.employeeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaveRequest;
  return Object.hash(runtimeType,_this.id,_this.employeeId,_this.leaveTypeId,_this.startDate,_this.endDate,_this.halfDay,_this.totalDays,_this.reason,_this.attachmentUrl,_this.status,_this.approvedBy,_this.approvedAt,_this.rejectReason,_this.createdAt,_this.leaveType,_this.employeeName);
}

@override
String toString() {
  final _this = this as LeaveRequest;
  return 'LeaveRequest(id: ${_this.id}, employeeId: ${_this.employeeId}, leaveTypeId: ${_this.leaveTypeId}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, halfDay: ${_this.halfDay}, totalDays: ${_this.totalDays}, reason: ${_this.reason}, attachmentUrl: ${_this.attachmentUrl}, status: ${_this.status}, approvedBy: ${_this.approvedBy}, approvedAt: ${_this.approvedAt}, rejectReason: ${_this.rejectReason}, createdAt: ${_this.createdAt}, leaveType: ${_this.leaveType}, employeeName: ${_this.employeeName})';
}


}

/// @nodoc
abstract mixin class $LeaveRequestCopyWith<$Res>  {
  factory $LeaveRequestCopyWith(LeaveRequest value, $Res Function(LeaveRequest) _then) = _$LeaveRequestCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, String leaveTypeId, DateTime startDate, DateTime endDate, HalfDay halfDay, double totalDays, String reason, String? attachmentUrl, LeaveStatus status, String? approvedBy, DateTime? approvedAt, String? rejectReason, DateTime? createdAt,@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType,@JsonKey(includeToJson: false) String? employeeName
});


$LeaveTypeCopyWith<$Res>? get leaveType;

}
/// @nodoc
class _$LeaveRequestCopyWithImpl<$Res>
    implements $LeaveRequestCopyWith<$Res> {
  _$LeaveRequestCopyWithImpl(this._self, this._then);

  final LeaveRequest _self;
  final $Res Function(LeaveRequest) _then;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? halfDay = null,Object? totalDays = null,Object? reason = null,Object? attachmentUrl = freezed,Object? status = null,Object? approvedBy = freezed,Object? approvedAt = freezed,Object? rejectReason = freezed,Object? createdAt = freezed,Object? leaveType = freezed,Object? employeeName = freezed,}) {
  return _then(LeaveRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as HalfDay,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,leaveType: freezed == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeaveRequest
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


/// Adds pattern-matching-related methods to [LeaveRequest].
extension LeaveRequestPatterns on LeaveRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveRequest value)  $default,){
final _that = this;
switch (_that) {
case _LeaveRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  String leaveTypeId,  DateTime startDate,  DateTime endDate,  HalfDay halfDay,  double totalDays,  String reason,  String? attachmentUrl,  LeaveStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime? createdAt, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType, @JsonKey(includeToJson: false)  String? employeeName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.halfDay,_that.totalDays,_that.reason,_that.attachmentUrl,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.leaveType,_that.employeeName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  String leaveTypeId,  DateTime startDate,  DateTime endDate,  HalfDay halfDay,  double totalDays,  String reason,  String? attachmentUrl,  LeaveStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime? createdAt, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType, @JsonKey(includeToJson: false)  String? employeeName)  $default,) {final _that = this;
switch (_that) {
case _LeaveRequest():
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.halfDay,_that.totalDays,_that.reason,_that.attachmentUrl,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.leaveType,_that.employeeName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  String leaveTypeId,  DateTime startDate,  DateTime endDate,  HalfDay halfDay,  double totalDays,  String reason,  String? attachmentUrl,  LeaveStatus status,  String? approvedBy,  DateTime? approvedAt,  String? rejectReason,  DateTime? createdAt, @JsonKey(name: 'leave_types', includeToJson: false)  LeaveType? leaveType, @JsonKey(includeToJson: false)  String? employeeName)?  $default,) {final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
return $default(_that.id,_that.employeeId,_that.leaveTypeId,_that.startDate,_that.endDate,_that.halfDay,_that.totalDays,_that.reason,_that.attachmentUrl,_that.status,_that.approvedBy,_that.approvedAt,_that.rejectReason,_that.createdAt,_that.leaveType,_that.employeeName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LeaveRequest extends LeaveRequest {
  const _LeaveRequest({required this.id, required this.employeeId, required this.leaveTypeId, required this.startDate, required this.endDate, this.halfDay = HalfDay.none, required this.totalDays, required this.reason, this.attachmentUrl, this.status = LeaveStatus.pending, this.approvedBy, this.approvedAt, this.rejectReason, this.createdAt, @JsonKey(name: 'leave_types', includeToJson: false) this.leaveType, @JsonKey(includeToJson: false) this.employeeName}): super._();
  factory _LeaveRequest.fromJson(Map<String, dynamic> json) => _$LeaveRequestFromJson(json);

@override final  String id;
@override final  String employeeId;
@override final  String leaveTypeId;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override@JsonKey() final  HalfDay halfDay;
/// Số ngày nghỉ thực (đã trừ cuối tuần, ngày lễ; nửa ngày = 0.5).
@override final  double totalDays;
@override final  String reason;
@override final  String? attachmentUrl;
@override@JsonKey() final  LeaveStatus status;
@override final  String? approvedBy;
@override final  DateTime? approvedAt;
@override final  String? rejectReason;
@override final  DateTime? createdAt;
/// Loại phép (join `leave_types(*)`).
@override@JsonKey(name: 'leave_types', includeToJson: false) final  LeaveType? leaveType;
/// Tên người nghỉ (join `profiles`), chỉ có ở lịch nghỉ team.
@override@JsonKey(includeToJson: false) final  String? employeeName;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveRequestCopyWith<_LeaveRequest> get copyWith => __$LeaveRequestCopyWithImpl<_LeaveRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.leaveTypeId, leaveTypeId) || other.leaveTypeId == leaveTypeId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.halfDay, halfDay) || other.halfDay == halfDay)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,employeeId,leaveTypeId,startDate,endDate,halfDay,totalDays,reason,attachmentUrl,status,approvedBy,approvedAt,rejectReason,createdAt,leaveType,employeeName);
}

@override
String toString() {
    return 'LeaveRequest(id: $id, employeeId: $employeeId, leaveTypeId: $leaveTypeId, startDate: $startDate, endDate: $endDate, halfDay: $halfDay, totalDays: $totalDays, reason: $reason, attachmentUrl: $attachmentUrl, status: $status, approvedBy: $approvedBy, approvedAt: $approvedAt, rejectReason: $rejectReason, createdAt: $createdAt, leaveType: $leaveType, employeeName: $employeeName)';
}


}

/// @nodoc
abstract mixin class _$LeaveRequestCopyWith<$Res> implements $LeaveRequestCopyWith<$Res> {
  factory _$LeaveRequestCopyWith(_LeaveRequest value, $Res Function(_LeaveRequest) _then) = __$LeaveRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, String leaveTypeId, DateTime startDate, DateTime endDate, HalfDay halfDay, double totalDays, String reason, String? attachmentUrl, LeaveStatus status, String? approvedBy, DateTime? approvedAt, String? rejectReason, DateTime? createdAt,@JsonKey(name: 'leave_types', includeToJson: false) LeaveType? leaveType,@JsonKey(includeToJson: false) String? employeeName
});


@override $LeaveTypeCopyWith<$Res>? get leaveType;

}
/// @nodoc
class __$LeaveRequestCopyWithImpl<$Res>
    implements _$LeaveRequestCopyWith<$Res> {
  __$LeaveRequestCopyWithImpl(this._self, this._then);

  final _LeaveRequest _self;
  final $Res Function(_LeaveRequest) _then;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? leaveTypeId = null,Object? startDate = null,Object? endDate = null,Object? halfDay = null,Object? totalDays = null,Object? reason = null,Object? attachmentUrl = freezed,Object? status = null,Object? approvedBy = freezed,Object? approvedAt = freezed,Object? rejectReason = freezed,Object? createdAt = freezed,Object? leaveType = freezed,Object? employeeName = freezed,}) {
  return _then(_LeaveRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,leaveTypeId: null == leaveTypeId ? _self.leaveTypeId : leaveTypeId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as HalfDay,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,leaveType: freezed == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeaveRequest
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
