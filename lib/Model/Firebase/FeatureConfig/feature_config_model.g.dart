// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeatureConfigModel _$FeatureConfigModelFromJson(Map<String, dynamic> json) =>
    _FeatureConfigModel(
      id: json['id'] as String,
      isLive: json['isLive'] as bool? ?? false,
      isTest: json['isTest'] as bool? ?? false,
      startDate: const TimestampConverter().fromJson(json['startDate']),
      endDate: const TimestampConverter().fromJson(json['endDate']),
    );

Map<String, dynamic> _$FeatureConfigModelToJson(_FeatureConfigModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isLive': instance.isLive,
      'isTest': instance.isTest,
      'startDate': const TimestampConverter().toJson(instance.startDate),
      'endDate': const TimestampConverter().toJson(instance.endDate),
    };
