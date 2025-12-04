import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tcs_app/Model/Firebase/timestamp_converter.dart';

part 'feature_config_model.freezed.dart';
part 'feature_config_model.g.dart';

@freezed
abstract class FeatureConfigModel with _$FeatureConfigModel {
  factory FeatureConfigModel({
    required String id,
    @Default(false) bool isLive,
    @Default(false) bool isTest,
    @TimestampConverter() DateTime? startDate,
    @TimestampConverter() DateTime? endDate,
  }) = _FeatureConfigModel;

  factory FeatureConfigModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureConfigModelFromJson(json);
}
