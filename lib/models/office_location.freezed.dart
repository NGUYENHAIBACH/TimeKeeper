// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'office_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfficeLocation {

 String get id; String get name; String? get address; double get latitude; double get longitude;/// Bán kính cho phép chấm công (mét).
 int get radiusMeters; bool get isActive;
/// Create a copy of OfficeLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfficeLocationCopyWith<OfficeLocation> get copyWith => _$OfficeLocationCopyWithImpl<OfficeLocation>(this as OfficeLocation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OfficeLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfficeLocation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.radiusMeters, _this.radiusMeters) || other.radiusMeters == _this.radiusMeters)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as OfficeLocation;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.latitude,_this.longitude,_this.radiusMeters,_this.isActive);
}

@override
String toString() {
  final _this = this as OfficeLocation;
  return 'OfficeLocation(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, radiusMeters: ${_this.radiusMeters}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $OfficeLocationCopyWith<$Res>  {
  factory $OfficeLocationCopyWith(OfficeLocation value, $Res Function(OfficeLocation) _then) = _$OfficeLocationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, double latitude, double longitude, int radiusMeters, bool isActive
});




}
/// @nodoc
class _$OfficeLocationCopyWithImpl<$Res>
    implements $OfficeLocationCopyWith<$Res> {
  _$OfficeLocationCopyWithImpl(this._self, this._then);

  final OfficeLocation _self;
  final $Res Function(OfficeLocation) _then;

/// Create a copy of OfficeLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? isActive = null,}) {
  return _then(OfficeLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OfficeLocation].
extension OfficeLocationPatterns on OfficeLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfficeLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfficeLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfficeLocation value)  $default,){
final _that = this;
switch (_that) {
case _OfficeLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfficeLocation value)?  $default,){
final _that = this;
switch (_that) {
case _OfficeLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  double latitude,  double longitude,  int radiusMeters,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfficeLocation() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.radiusMeters,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  double latitude,  double longitude,  int radiusMeters,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _OfficeLocation():
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.radiusMeters,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  double latitude,  double longitude,  int radiusMeters,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _OfficeLocation() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.radiusMeters,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _OfficeLocation extends OfficeLocation {
  const _OfficeLocation({required this.id, required this.name, this.address, required this.latitude, required this.longitude, this.radiusMeters = 100, this.isActive = true}): super._();
  

@override final  String id;
@override final  String name;
@override final  String? address;
@override final  double latitude;
@override final  double longitude;
/// Bán kính cho phép chấm công (mét).
@override@JsonKey() final  int radiusMeters;
@override@JsonKey() final  bool isActive;

/// Create a copy of OfficeLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfficeLocationCopyWith<_OfficeLocation> get copyWith => __$OfficeLocationCopyWithImpl<_OfficeLocation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfficeLocation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,latitude,longitude,radiusMeters,isActive);
}

@override
String toString() {
    return 'OfficeLocation(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$OfficeLocationCopyWith<$Res> implements $OfficeLocationCopyWith<$Res> {
  factory _$OfficeLocationCopyWith(_OfficeLocation value, $Res Function(_OfficeLocation) _then) = __$OfficeLocationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, double latitude, double longitude, int radiusMeters, bool isActive
});




}
/// @nodoc
class __$OfficeLocationCopyWithImpl<$Res>
    implements _$OfficeLocationCopyWith<$Res> {
  __$OfficeLocationCopyWithImpl(this._self, this._then);

  final _OfficeLocation _self;
  final $Res Function(_OfficeLocation) _then;

/// Create a copy of OfficeLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? isActive = null,}) {
  return _then(_OfficeLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
