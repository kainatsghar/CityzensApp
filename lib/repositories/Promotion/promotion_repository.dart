import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Promotion/promotion_model.dart';
import 'package:tcs_app/network/api_base_helper.dart';

class PromotionRepository {
  PromotionRepository() : super();

  // Get active promotions
  Future<PromotionModel?> getActivePromotion() async {
    try {
      final response = await ApiBaseHelper.httpPostRequest(
        "GetAllLaunchPromotions",
      );

      final isSuccess = response['IsSuccess'] == true || response['isSuccess'] == true;
      final responseData = response['Data'] ?? response['data'];

      if (isSuccess && responseData != null) {
        List data = responseData;
        if (data.isNotEmpty) {
          for (var item in data) {
            var promo = PromotionModel.fromJson(item);
            if (promo.promotionKey == 'launchPromotion') {
              return promo;
            }
          }
          return PromotionModel.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get active promotion: $e');
      return null;
    }
  }

  // Get active promotions list
  Future<List<PromotionModel>?> getActivePromotionList() async {
    try {
      final response = await ApiBaseHelper.httpPostRequest(
        "GetAllLaunchPromotions",
      );

      final isSuccess = response['IsSuccess'] == true || response['isSuccess'] == true;
      final responseData = response['Data'] ?? response['data'];

      if (isSuccess && responseData != null) {
        List data = responseData;
        return data.map((e) => PromotionModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get active promotion list: $e');
      return null;
    }
  }

  // Stream active promotions
  Stream<PromotionModel?> streamActivePromotion() {
    return Stream.fromFuture(getActivePromotion());
  }

  Future<void> addPromotion(PromotionModel promotion, {File? file}) async {
    if (!kDebugMode) {
      debugPrint("Add promotion is only allowed in debug mode.");
      return;
    }
    try {
      if (file != null) {
        await ApiBaseHelper.httpMultipartPostRequest(
          "CreateLaunchPromotion",
          fields: _promotionToFields(promotion),
          filePath: file.path,
          fileField: 'file',
        );
      } else {
        await ApiBaseHelper.httpPostRequest(
          "CreateLaunchPromotion",
          body: promotion.toJson(),
        );
      }
      debugPrint("Promotion added successfully ✅");
    } catch (e) {
      debugPrint("Failed to add promotion: $e");
    }
  }

  Future<void> updatePromotion(PromotionModel promotion, {File? file}) async {
    if (!kDebugMode) {
      debugPrint("Update promotion is only allowed in debug mode.");
      return;
    }
    try {
      if (file != null) {
        await ApiBaseHelper.httpMultipartPostRequest(
          "UpdateLaunchPromotion",
          fields: _promotionToFields(promotion),
          filePath: file.path,
          fileField: 'file',
        );
      } else {
        await ApiBaseHelper.httpPostRequest(
          "UpdateLaunchPromotion",
          body: promotion.toJson(),
        );
      }
      debugPrint("Promotion updated successfully ✅");
    } catch (e) {
      debugPrint("Failed to update promotion: $e");
    }
  }

  Future<void> deletePromotion(int promotionId) async {
    if (!kDebugMode) {
      debugPrint("Delete promotion is only allowed in debug mode.");
      return;
    }
    try {
      await ApiBaseHelper.httpPostRequest(
        "DeleteLaunchPromotion",
        body: {"promotionId": promotionId},
      );
      debugPrint("Promotion deleted successfully ✅");
    } catch (e) {
      debugPrint("Failed to delete promotion: $e");
    }
  }

  /// Converts a [PromotionModel] to a flat String map for multipart requests.
  Map<String, String> _promotionToFields(PromotionModel p) {
    return {
      'promotionId': p.id.toString(),
      if (p.promotionKey != null) 'promotionKey': p.promotionKey!,
      if (p.adPosition != null) 'adPosition': p.adPosition!,
      if (p.title != null) 'title': p.title!,
      if (p.description != null) 'description': p.description!,
      'isLive': p.isLive.toString(),
      'isTesting': p.isTesting.toString(),
      'isFullScreen': p.isFullScreen.toString(),
      'promotionType': p.promotionType,
      if (p.url != null) 'url': p.url!,
      if (p.tapLinkURL != null) 'tapLinkURL': p.tapLinkURL!,
      'displayDuration': p.displayDuration.toString(),
      if (p.startDate != null) 'startDate': p.startDate!.toIso8601String(),
      if (p.endDate != null) 'endDate': p.endDate!.toIso8601String(),
      if (p.displayFileName != null) 'displayFileName': p.displayFileName!,
      if (p.filePath != null) 'filePath': p.filePath!,
    };
  }
}
