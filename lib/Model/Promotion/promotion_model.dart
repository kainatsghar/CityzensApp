import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
abstract class PromotionModel with _$PromotionModel {
  factory PromotionModel({
    @JsonKey(name: 'promotionId') required int id,
    @JsonKey(name: 'promotionKey') String? promotionKey,
    @JsonKey(name: 'adPosition') String? adPosition,
    String? title,
    String? description,
    @Default(false) bool isLive,
    @Default(false) bool isTesting,
    @Default(true) bool isFullScreen,
    @Default('image') String promotionType,
    String? url,
    String? tapLinkURL,
    @Default(30) int displayDuration,
    DateTime? startDate,
    DateTime? endDate,
    String? displayFileName,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}
