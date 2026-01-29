import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Firebase/Promotion/promotion_model.dart';

class PromotionRepository {
  PromotionRepository() : super();

  PromotionModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PromotionModel.fromJson(doc.data()!);
  }

  // Get active promotions
  Future<PromotionModel?> getActivePromotion() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('promotions')
          .doc('launchPromotion')
          .get();

      if (snapshot.exists) {
        return fromFirestore(snapshot);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get active promotion: $e');
      return null;
    }
  }

  // Get active promotions
  Future<List<PromotionModel>?> getActivePromotionList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('promotions')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map(fromFirestore).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get active promotion: $e');
      return null;
    }
  }

  // Stream active promotions
  Stream<PromotionModel?> streamActivePromotion() {
    return FirebaseFirestore.instance
        .collection('promotions')
        .doc('launchPromotion')
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return fromFirestore(snapshot);
          }
          return null;
        });
  }

  Future<void> addPromotion(PromotionModel promotion) async {
    try {
      await FirebaseFirestore.instance
          .collection('promotions')
          .doc(
            promotion.id,
          ) // you can also use .add() if you want Firestore to generate an ID
          .set(promotion.toJson());
      debugPrint("Promotion added successfully ✅");
    } catch (e) {
      debugPrint("Failed to add promotion: $e");
    }
  }
}
