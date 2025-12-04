// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeatureConfigModel {

 String get id; bool get isLive; bool get isTest;@TimestampConverter() DateTime? get startDate;@TimestampConverter() DateTime? get endDate;
/// Create a copy of FeatureConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureConfigModelCopyWith<FeatureConfigModel> get copyWith => _$FeatureConfigModelCopyWithImpl<FeatureConfigModel>(this as FeatureConfigModel, _$identity);

  /// Serializes this FeatureConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureConfigModel&&(identical(other.id, id) || other.id == id)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTest, isTest) || other.isTest == isTest)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isLive,isTest,startDate,endDate);

@override
String toString() {
  return 'FeatureConfigModel(id: $id, isLive: $isLive, isTest: $isTest, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $FeatureConfigModelCopyWith<$Res>  {
  factory $FeatureConfigModelCopyWith(FeatureConfigModel value, $Res Function(FeatureConfigModel) _then) = _$FeatureConfigModelCopyWithImpl;
@useResult
$Res call({
 String id, bool isLive, bool isTest,@TimestampConverter() DateTime? startDate,@TimestampConverter() DateTime? endDate
});




}
/// @nodoc
class _$FeatureConfigModelCopyWithImpl<$Res>
    implements $FeatureConfigModelCopyWith<$Res> {
  _$FeatureConfigModelCopyWithImpl(this._self, this._then);

  final FeatureConfigModel _self;
  final $Res Function(FeatureConfigModel) _then;

/// Create a copy of FeatureConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isLive = null,Object? isTest = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,isTest: null == isTest ? _self.isTest : isTest // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureConfigModel].
extension FeatureConfigModelPatterns on FeatureConfigModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureConfigModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _FeatureConfigModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureConfigModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool isLive,  bool isTest, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureConfigModel() when $default != null:
return $default(_that.id,_that.isLive,_that.isTest,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool isLive,  bool isTest, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _FeatureConfigModel():
return $default(_that.id,_that.isLive,_that.isTest,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool isLive,  bool isTest, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _FeatureConfigModel() when $default != null:
return $default(_that.id,_that.isLive,_that.isTest,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureConfigModel implements FeatureConfigModel {
   _FeatureConfigModel({required this.id, this.isLive = false, this.isTest = false, @TimestampConverter() this.startDate, @TimestampConverter() this.endDate});
  factory _FeatureConfigModel.fromJson(Map<String, dynamic> json) => _$FeatureConfigModelFromJson(json);

@override final  String id;
@override@JsonKey() final  bool isLive;
@override@JsonKey() final  bool isTest;
@override@TimestampConverter() final  DateTime? startDate;
@override@TimestampConverter() final  DateTime? endDate;

/// Create a copy of FeatureConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureConfigModelCopyWith<_FeatureConfigModel> get copyWith => __$FeatureConfigModelCopyWithImpl<_FeatureConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureConfigModel&&(identical(other.id, id) || other.id == id)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTest, isTest) || other.isTest == isTest)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isLive,isTest,startDate,endDate);

@override
String toString() {
  return 'FeatureConfigModel(id: $id, isLive: $isLive, isTest: $isTest, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$FeatureConfigModelCopyWith<$Res> implements $FeatureConfigModelCopyWith<$Res> {
  factory _$FeatureConfigModelCopyWith(_FeatureConfigModel value, $Res Function(_FeatureConfigModel) _then) = __$FeatureConfigModelCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isLive, bool isTest,@TimestampConverter() DateTime? startDate,@TimestampConverter() DateTime? endDate
});




}
/// @nodoc
class __$FeatureConfigModelCopyWithImpl<$Res>
    implements _$FeatureConfigModelCopyWith<$Res> {
  __$FeatureConfigModelCopyWithImpl(this._self, this._then);

  final _FeatureConfigModel _self;
  final $Res Function(_FeatureConfigModel) _then;

/// Create a copy of FeatureConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isLive = null,Object? isTest = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_FeatureConfigModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,isTest: null == isTest ? _self.isTest : isTest // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
