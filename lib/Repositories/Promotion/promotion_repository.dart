import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/Model/Firebase/Promotion/promotion_model.dart';

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
}
