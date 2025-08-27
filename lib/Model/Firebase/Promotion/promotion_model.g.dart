// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    _PromotionModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      isLive: json['isLive'] as bool? ?? false,
      promotionType: json['promotionType'] as String? ?? 'image',
      url: json['url'] as String?,
      displayDuration: (json['displayDuration'] as num?)?.toInt() ?? 10,
      startDate: const TimestampConverter().fromJson(json['startDate']),
      endDate: const TimestampConverter().fromJson(json['endDate']),
    );

Map<String, dynamic> _$PromotionModelToJson(_PromotionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'isLive': instance.isLive,
      'promotionType': instance.promotionType,
      'url': instance.url,
      'displayDuration': instance.displayDuration,
      'startDate': const TimestampConverter().toJson(instance.startDate),
      'endDate': const TimestampConverter().toJson(instance.endDate),
    };
