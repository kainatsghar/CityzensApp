// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    _PromotionModel(
      id: (json['promotionId'] as num).toInt(),
      promotionKey: json['promotionKey'] as String?,
      adPosition: json['adPosition'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      isLive: json['isLive'] as bool? ?? false,
      isTesting: json['isTesting'] as bool? ?? false,
      isFullScreen: json['isFullScreen'] as bool? ?? true,
      promotionType: json['promotionType'] as String? ?? 'image',
      url: json['url'] as String?,
      tapLinkURL: json['tapLinkURL'] as String?,
      displayDuration: (json['displayDuration'] as num?)?.toInt() ?? 30,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      displayFileName: json['displayFileName'] as String?,
      filePath: json['filePath'] as String?,
    );

Map<String, dynamic> _$PromotionModelToJson(_PromotionModel instance) =>
    <String, dynamic>{
      'promotionId': instance.id,
      'promotionKey': instance.promotionKey,
      'adPosition': instance.adPosition,
      'title': instance.title,
      'description': instance.description,
      'isLive': instance.isLive,
      'isTesting': instance.isTesting,
      'isFullScreen': instance.isFullScreen,
      'promotionType': instance.promotionType,
      'url': instance.url,
      'tapLinkURL': instance.tapLinkURL,
      'displayDuration': instance.displayDuration,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'displayFileName': instance.displayFileName,
      'filePath': instance.filePath,
    };
