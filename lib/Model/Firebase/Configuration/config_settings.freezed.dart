// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfigSettings {

 String? get baseUrl;
/// Create a copy of ConfigSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigSettingsCopyWith<ConfigSettings> get copyWith => _$ConfigSettingsCopyWithImpl<ConfigSettings>(this as ConfigSettings, _$identity);

  /// Serializes this ConfigSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigSettings&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseUrl);

@override
String toString() {
  return 'ConfigSettings(baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class $ConfigSettingsCopyWith<$Res>  {
  factory $ConfigSettingsCopyWith(ConfigSettings value, $Res Function(ConfigSettings) _then) = _$ConfigSettingsCopyWithImpl;
@useResult
$Res call({
 String? baseUrl
});




}
/// @nodoc
class _$ConfigSettingsCopyWithImpl<$Res>
    implements $ConfigSettingsCopyWith<$Res> {
  _$ConfigSettingsCopyWithImpl(this._self, this._then);

  final ConfigSettings _self;
  final $Res Function(ConfigSettings) _then;

/// Create a copy of ConfigSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseUrl = freezed,}) {
  return _then(_self.copyWith(
baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfigSettings].
extension ConfigSettingsPatterns on ConfigSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfigSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfigSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfigSettings value)  $default,){
final _that = this;
switch (_that) {
case _ConfigSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfigSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ConfigSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? baseUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfigSettings() when $default != null:
return $default(_that.baseUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? baseUrl)  $default,) {final _that = this;
switch (_that) {
case _ConfigSettings():
return $default(_that.baseUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? baseUrl)?  $default,) {final _that = this;
switch (_that) {
case _ConfigSettings() when $default != null:
return $default(_that.baseUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfigSettings implements ConfigSettings {
   _ConfigSettings({this.baseUrl});
  factory _ConfigSettings.fromJson(Map<String, dynamic> json) => _$ConfigSettingsFromJson(json);

@override final  String? baseUrl;

/// Create a copy of ConfigSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigSettingsCopyWith<_ConfigSettings> get copyWith => __$ConfigSettingsCopyWithImpl<_ConfigSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigSettings&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseUrl);

@override
String toString() {
  return 'ConfigSettings(baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class _$ConfigSettingsCopyWith<$Res> implements $ConfigSettingsCopyWith<$Res> {
  factory _$ConfigSettingsCopyWith(_ConfigSettings value, $Res Function(_ConfigSettings) _then) = __$ConfigSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? baseUrl
});




}
/// @nodoc
class __$ConfigSettingsCopyWithImpl<$Res>
    implements _$ConfigSettingsCopyWith<$Res> {
  __$ConfigSettingsCopyWithImpl(this._self, this._then);

  final _ConfigSettings _self;
  final $Res Function(_ConfigSettings) _then;

/// Create a copy of ConfigSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseUrl = freezed,}) {
  return _then(_ConfigSettings(
baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
