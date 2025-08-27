import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}

@freezed
abstract class PromotionModel with _$PromotionModel {
  factory PromotionModel({
    String? title,
    String? description,
    @Default(false) bool isLive,
    @Default('image') String promotionType,
    String? url,
    @Default(10) int displayDuration,
    @TimestampConverter() DateTime? startDate,
    @TimestampConverter() DateTime? endDate,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}
