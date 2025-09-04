// lib/services/firestore_manager.dart
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  FirestoreManager._();
  static final FirestoreManager instance = FirestoreManager._();

  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    // Instead of a healthCheck, just log availability
    try {
      final settings = FirebaseFirestore.instance.settings;
      dev.log('[FS] Firestore initialized with settings: $settings');
    } catch (e, s) {
      dev.log('[FS] Firestore init error: $e', stackTrace: s);
    }
  }

  Future<void> dispose() async {
    dev.log('[FS] FirestoreManager disposed');
    _started = false;
  }
}
