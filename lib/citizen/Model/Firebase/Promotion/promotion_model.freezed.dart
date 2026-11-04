// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromotionModel {

 String get id; String? get title; String? get description; bool get isLive; bool get isTesting; bool get isFullScreen; String get promotionType; String? get url; String? get tapLinkURL; int get displayDuration;@TimestampConverter() DateTime? get startDate;@TimestampConverter() DateTime? get endDate;
/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromotionModelCopyWith<PromotionModel> get copyWith => _$PromotionModelCopyWithImpl<PromotionModel>(this as PromotionModel, _$identity);

  /// Serializes this PromotionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTesting, isTesting) || other.isTesting == isTesting)&&(identical(other.isFullScreen, isFullScreen) || other.isFullScreen == isFullScreen)&&(identical(other.promotionType, promotionType) || other.promotionType == promotionType)&&(identical(other.url, url) || other.url == url)&&(identical(other.tapLinkURL, tapLinkURL) || other.tapLinkURL == tapLinkURL)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isLive,isTesting,isFullScreen,promotionType,url,tapLinkURL,displayDuration,startDate,endDate);

@override
String toString() {
  return 'PromotionModel(id: $id, title: $title, description: $description, isLive: $isLive, isTesting: $isTesting, isFullScreen: $isFullScreen, promotionType: $promotionType, url: $url, tapLinkURL: $tapLinkURL, displayDuration: $displayDuration, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $PromotionModelCopyWith<$Res>  {
  factory $PromotionModelCopyWith(PromotionModel value, $Res Function(PromotionModel) _then) = _$PromotionModelCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String? description, bool isLive, bool isTesting, bool isFullScreen, String promotionType, String? url, String? tapLinkURL, int displayDuration,@TimestampConverter() DateTime? startDate,@TimestampConverter() DateTime? endDate
});




}
/// @nodoc
class _$PromotionModelCopyWithImpl<$Res>
    implements $PromotionModelCopyWith<$Res> {
  _$PromotionModelCopyWithImpl(this._self, this._then);

  final PromotionModel _self;
  final $Res Function(PromotionModel) _then;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? isLive = null,Object? isTesting = null,Object? isFullScreen = null,Object? promotionType = null,Object? url = freezed,Object? tapLinkURL = freezed,Object? displayDuration = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,isTesting: null == isTesting ? _self.isTesting : isTesting // ignore: cast_nullable_to_non_nullable
as bool,isFullScreen: null == isFullScreen ? _self.isFullScreen : isFullScreen // ignore: cast_nullable_to_non_nullable
as bool,promotionType: null == promotionType ? _self.promotionType : promotionType // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,tapLinkURL: freezed == tapLinkURL ? _self.tapLinkURL : tapLinkURL // ignore: cast_nullable_to_non_nullable
as String?,displayDuration: null == displayDuration ? _self.displayDuration : displayDuration // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PromotionModel].
extension PromotionModelPatterns on PromotionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromotionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromotionModel value)  $default,){
final _that = this;
switch (_that) {
case _PromotionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromotionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _PromotionModel():
return $default(_that.id,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration, @TimestampConverter()  DateTime? startDate, @TimestampConverter()  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromotionModel implements PromotionModel {
   _PromotionModel({required this.id, this.title, this.description, this.isLive = false, this.isTesting = false, this.isFullScreen = false, this.promotionType = 'image', this.url, this.tapLinkURL, this.displayDuration = 10, @TimestampConverter() this.startDate, @TimestampConverter() this.endDate});
  factory _PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);

@override final  String id;
@override final  String? title;
@override final  String? description;
@override@JsonKey() final  bool isLive;
@override@JsonKey() final  bool isTesting;
@override@JsonKey() final  bool isFullScreen;
@override@JsonKey() final  String promotionType;
@override final  String? url;
@override final  String? tapLinkURL;
@override@JsonKey() final  int displayDuration;
@override@TimestampConverter() final  DateTime? startDate;
@override@TimestampConverter() final  DateTime? endDate;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromotionModelCopyWith<_PromotionModel> get copyWith => __$PromotionModelCopyWithImpl<_PromotionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromotionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTesting, isTesting) || other.isTesting == isTesting)&&(identical(other.isFullScreen, isFullScreen) || other.isFullScreen == isFullScreen)&&(identical(other.promotionType, promotionType) || other.promotionType == promotionType)&&(identical(other.url, url) || other.url == url)&&(identical(other.tapLinkURL, tapLinkURL) || other.tapLinkURL == tapLinkURL)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isLive,isTesting,isFullScreen,promotionType,url,tapLinkURL,displayDuration,startDate,endDate);

@override
String toString() {
  return 'PromotionModel(id: $id, title: $title, description: $description, isLive: $isLive, isTesting: $isTesting, isFullScreen: $isFullScreen, promotionType: $promotionType, url: $url, tapLinkURL: $tapLinkURL, displayDuration: $displayDuration, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$PromotionModelCopyWith<$Res> implements $PromotionModelCopyWith<$Res> {
  factory _$PromotionModelCopyWith(_PromotionModel value, $Res Function(_PromotionModel) _then) = __$PromotionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String? description, bool isLive, bool isTesting, bool isFullScreen, String promotionType, String? url, String? tapLinkURL, int displayDuration,@TimestampConverter() DateTime? startDate,@TimestampConverter() DateTime? endDate
});




}
/// @nodoc
class __$PromotionModelCopyWithImpl<$Res>
    implements _$PromotionModelCopyWith<$Res> {
  __$PromotionModelCopyWithImpl(this._self, this._then);

  final _PromotionModel _self;
  final $Res Function(_PromotionModel) _then;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? isLive = null,Object? isTesting = null,Object? isFullScreen = null,Object? promotionType = null,Object? url = freezed,Object? tapLinkURL = freezed,Object? displayDuration = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_PromotionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,isTesting: null == isTesting ? _self.isTesting : isTesting // ignore: cast_nullable_to_non_nullable
as bool,isFullScreen: null == isFullScreen ? _self.isFullScreen : isFullScreen // ignore: cast_nullable_to_non_nullable
as bool,promotionType: null == promotionType ? _self.promotionType : promotionType // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,tapLinkURL: freezed == tapLinkURL ? _self.tapLinkURL : tapLinkURL // ignore: cast_nullable_to_non_nullable
as String?,displayDuration: null == displayDuration ? _self.displayDuration : displayDuration // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
