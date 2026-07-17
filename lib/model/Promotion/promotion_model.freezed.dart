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

@JsonKey(name: 'promotionId') int get id;@JsonKey(name: 'promotionKey') String? get promotionKey;@JsonKey(name: 'adPosition') String? get adPosition; String? get title; String? get description; bool get isLive; bool get isTesting; bool get isFullScreen; String get promotionType; String? get url; String? get tapLinkURL; int get displayDuration; DateTime? get startDate; DateTime? get endDate; String? get displayFileName;@JsonKey(name: 'filePath') String? get filePath;
/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromotionModelCopyWith<PromotionModel> get copyWith => _$PromotionModelCopyWithImpl<PromotionModel>(this as PromotionModel, _$identity);

  /// Serializes this PromotionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.promotionKey, promotionKey) || other.promotionKey == promotionKey)&&(identical(other.adPosition, adPosition) || other.adPosition == adPosition)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTesting, isTesting) || other.isTesting == isTesting)&&(identical(other.isFullScreen, isFullScreen) || other.isFullScreen == isFullScreen)&&(identical(other.promotionType, promotionType) || other.promotionType == promotionType)&&(identical(other.url, url) || other.url == url)&&(identical(other.tapLinkURL, tapLinkURL) || other.tapLinkURL == tapLinkURL)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.displayFileName, displayFileName) || other.displayFileName == displayFileName)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,promotionKey,adPosition,title,description,isLive,isTesting,isFullScreen,promotionType,url,tapLinkURL,displayDuration,startDate,endDate,displayFileName,filePath);

@override
String toString() {
  return 'PromotionModel(id: $id, promotionKey: $promotionKey, adPosition: $adPosition, title: $title, description: $description, isLive: $isLive, isTesting: $isTesting, isFullScreen: $isFullScreen, promotionType: $promotionType, url: $url, tapLinkURL: $tapLinkURL, displayDuration: $displayDuration, startDate: $startDate, endDate: $endDate, displayFileName: $displayFileName, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class $PromotionModelCopyWith<$Res>  {
  factory $PromotionModelCopyWith(PromotionModel value, $Res Function(PromotionModel) _then) = _$PromotionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'promotionId') int id,@JsonKey(name: 'promotionKey') String? promotionKey,@JsonKey(name: 'adPosition') String? adPosition, String? title, String? description, bool isLive, bool isTesting, bool isFullScreen, String promotionType, String? url, String? tapLinkURL, int displayDuration, DateTime? startDate, DateTime? endDate, String? displayFileName,@JsonKey(name: 'filePath') String? filePath
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? promotionKey = freezed,Object? adPosition = freezed,Object? title = freezed,Object? description = freezed,Object? isLive = null,Object? isTesting = null,Object? isFullScreen = null,Object? promotionType = null,Object? url = freezed,Object? tapLinkURL = freezed,Object? displayDuration = null,Object? startDate = freezed,Object? endDate = freezed,Object? displayFileName = freezed,Object? filePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,promotionKey: freezed == promotionKey ? _self.promotionKey : promotionKey // ignore: cast_nullable_to_non_nullable
as String?,adPosition: freezed == adPosition ? _self.adPosition : adPosition // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
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
as DateTime?,displayFileName: freezed == displayFileName ? _self.displayFileName : displayFileName // ignore: cast_nullable_to_non_nullable
as String?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'promotionId')  int id, @JsonKey(name: 'promotionKey')  String? promotionKey, @JsonKey(name: 'adPosition')  String? adPosition,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration,  DateTime? startDate,  DateTime? endDate,  String? displayFileName, @JsonKey(name: 'filePath')  String? filePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.promotionKey,_that.adPosition,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate,_that.displayFileName,_that.filePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'promotionId')  int id, @JsonKey(name: 'promotionKey')  String? promotionKey, @JsonKey(name: 'adPosition')  String? adPosition,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration,  DateTime? startDate,  DateTime? endDate,  String? displayFileName, @JsonKey(name: 'filePath')  String? filePath)  $default,) {final _that = this;
switch (_that) {
case _PromotionModel():
return $default(_that.id,_that.promotionKey,_that.adPosition,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate,_that.displayFileName,_that.filePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'promotionId')  int id, @JsonKey(name: 'promotionKey')  String? promotionKey, @JsonKey(name: 'adPosition')  String? adPosition,  String? title,  String? description,  bool isLive,  bool isTesting,  bool isFullScreen,  String promotionType,  String? url,  String? tapLinkURL,  int displayDuration,  DateTime? startDate,  DateTime? endDate,  String? displayFileName, @JsonKey(name: 'filePath')  String? filePath)?  $default,) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.promotionKey,_that.adPosition,_that.title,_that.description,_that.isLive,_that.isTesting,_that.isFullScreen,_that.promotionType,_that.url,_that.tapLinkURL,_that.displayDuration,_that.startDate,_that.endDate,_that.displayFileName,_that.filePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromotionModel implements PromotionModel {
   _PromotionModel({@JsonKey(name: 'promotionId') required this.id, @JsonKey(name: 'promotionKey') this.promotionKey, @JsonKey(name: 'adPosition') this.adPosition, this.title, this.description, this.isLive = false, this.isTesting = false, this.isFullScreen = true, this.promotionType = 'image', this.url, this.tapLinkURL, this.displayDuration = 30, this.startDate, this.endDate, this.displayFileName, @JsonKey(name: 'filePath') this.filePath});
  factory _PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);

@override@JsonKey(name: 'promotionId') final  int id;
@override@JsonKey(name: 'promotionKey') final  String? promotionKey;
@override@JsonKey(name: 'adPosition') final  String? adPosition;
@override final  String? title;
@override final  String? description;
@override@JsonKey() final  bool isLive;
@override@JsonKey() final  bool isTesting;
@override@JsonKey() final  bool isFullScreen;
@override@JsonKey() final  String promotionType;
@override final  String? url;
@override final  String? tapLinkURL;
@override@JsonKey() final  int displayDuration;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  String? displayFileName;
@override@JsonKey(name: 'filePath') final  String? filePath;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.promotionKey, promotionKey) || other.promotionKey == promotionKey)&&(identical(other.adPosition, adPosition) || other.adPosition == adPosition)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.isTesting, isTesting) || other.isTesting == isTesting)&&(identical(other.isFullScreen, isFullScreen) || other.isFullScreen == isFullScreen)&&(identical(other.promotionType, promotionType) || other.promotionType == promotionType)&&(identical(other.url, url) || other.url == url)&&(identical(other.tapLinkURL, tapLinkURL) || other.tapLinkURL == tapLinkURL)&&(identical(other.displayDuration, displayDuration) || other.displayDuration == displayDuration)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.displayFileName, displayFileName) || other.displayFileName == displayFileName)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,promotionKey,adPosition,title,description,isLive,isTesting,isFullScreen,promotionType,url,tapLinkURL,displayDuration,startDate,endDate,displayFileName,filePath);

@override
String toString() {
  return 'PromotionModel(id: $id, promotionKey: $promotionKey, adPosition: $adPosition, title: $title, description: $description, isLive: $isLive, isTesting: $isTesting, isFullScreen: $isFullScreen, promotionType: $promotionType, url: $url, tapLinkURL: $tapLinkURL, displayDuration: $displayDuration, startDate: $startDate, endDate: $endDate, displayFileName: $displayFileName, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$PromotionModelCopyWith<$Res> implements $PromotionModelCopyWith<$Res> {
  factory _$PromotionModelCopyWith(_PromotionModel value, $Res Function(_PromotionModel) _then) = __$PromotionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'promotionId') int id,@JsonKey(name: 'promotionKey') String? promotionKey,@JsonKey(name: 'adPosition') String? adPosition, String? title, String? description, bool isLive, bool isTesting, bool isFullScreen, String promotionType, String? url, String? tapLinkURL, int displayDuration, DateTime? startDate, DateTime? endDate, String? displayFileName,@JsonKey(name: 'filePath') String? filePath
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? promotionKey = freezed,Object? adPosition = freezed,Object? title = freezed,Object? description = freezed,Object? isLive = null,Object? isTesting = null,Object? isFullScreen = null,Object? promotionType = null,Object? url = freezed,Object? tapLinkURL = freezed,Object? displayDuration = null,Object? startDate = freezed,Object? endDate = freezed,Object? displayFileName = freezed,Object? filePath = freezed,}) {
  return _then(_PromotionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,promotionKey: freezed == promotionKey ? _self.promotionKey : promotionKey // ignore: cast_nullable_to_non_nullable
as String?,adPosition: freezed == adPosition ? _self.adPosition : adPosition // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
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
as DateTime?,displayFileName: freezed == displayFileName ? _self.displayFileName : displayFileName // ignore: cast_nullable_to_non_nullable
as String?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
