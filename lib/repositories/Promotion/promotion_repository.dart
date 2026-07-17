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

  Future<void> addPromotion(PromotionModel promotion) async {
    if (!kDebugMode) {
      debugPrint("Add promotion is only allowed in debug mode.");
      return;
    }
    try {
      await ApiBaseHelper.httpPostRequest(
        "CreateLaunchPromotion",
        body: promotion.toJson(),
      );
      debugPrint("Promotion added successfully ✅");
    } catch (e) {
      debugPrint("Failed to add promotion: $e");
    }
  }

  Future<void> updatePromotion(PromotionModel promotion) async {
    if (!kDebugMode) {
      debugPrint("Update promotion is only allowed in debug mode.");
      return;
    }
    try {
      await ApiBaseHelper.httpPostRequest(
        "UpdateLaunchPromotion",
        body: promotion.toJson(),
      );
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
}
