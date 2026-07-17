import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Firebase/FeatureConfig/feature_config_model.dart';

class FeatureConfigRepository {
  FeatureConfigRepository() : super();

  FeatureConfigModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return FeatureConfigModel.fromJson(doc.data()!);
  }

  // Get new features
  Future<FeatureConfigModel?> getNewPaymentFlow() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newFeatures')
          .doc('newPaymentFlow')
          .get();

      if (snapshot.exists) {
        log('snapshot data: ${snapshot.data()}');
        return fromFirestore(snapshot);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get active promotion: $e');
      return null;
    }
  }

  // Get new features list
  Future<List<FeatureConfigModel>?> getNewFeaturesList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newFeatures')
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

  // Stream new payment feature
  Stream<FeatureConfigModel?> streamNewPaymentFeature() {
    return FirebaseFirestore.instance
        .collection('newFeatures')
        .doc('newPaymentFlow')
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return fromFirestore(snapshot);
          }
          return null;
        });
  }

  Future<void> addNewFeature(FeatureConfigModel newFeature) async {
    try {
      await FirebaseFirestore.instance
          .collection('newFeatures')
          .doc(
            newFeature.id,
          ) // you can also use .add() if you want Firestore to generate an ID
          .set(newFeature.toJson());
      debugPrint("Promotion added successfully ✅");
    } catch (e) {
      debugPrint("Failed to add promotion: $e");
    }
  }
}
