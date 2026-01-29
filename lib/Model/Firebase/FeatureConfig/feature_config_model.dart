import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tcs_app/model/Firebase/timestamp_converter.dart';

part 'feature_config_model.freezed.dart';
part 'feature_config_model.g.dart';

@freezed
abstract class FeatureConfigModel with _$FeatureConfigModel {
  const FeatureConfigModel._();
  factory FeatureConfigModel({
    required String id,
    @Default(false) bool isLive,
    @Default(false) bool isTest,
    @Default(false) bool isTesting,
    @TimestampConverter() DateTime? startDate,
    @TimestampConverter() DateTime? endDate,
  }) = _FeatureConfigModel;

  factory FeatureConfigModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureConfigModelFromJson(json);

  bool get isActive {
    final now = DateTime.now();

    // 🔧 DEBUG / TEST MODE
    if (kDebugMode) {
      return isTesting;
    }

    // 🚀 RELEASE MODE
    if (kReleaseMode && isLive) {
      if (startDate != null && now.isBefore(startDate!)) return false;
      if (endDate != null && now.isAfter(endDate!)) return false;
      return true;
    }

    return false;
  }
}
