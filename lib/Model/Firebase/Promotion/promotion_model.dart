import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tcs_app/Model/Firebase/timestamp_converter.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
abstract class PromotionModel with _$PromotionModel {
  factory PromotionModel({
    required String id,
    String? title,
    String? description,
    @Default(false) bool isLive,
    @Default(false) bool isTesting,
    @Default(false) bool isFullScreen,
    @Default('image') String promotionType,
    String? url,
    String? tapLinkURL,
    @Default(10) int displayDuration,
    @TimestampConverter() DateTime? startDate,
    @TimestampConverter() DateTime? endDate,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}
