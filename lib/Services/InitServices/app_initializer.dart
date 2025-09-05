import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firebase_master.dart';
import 'firestore_manager.dart';
import 'push_notifications.dart';
import '../../firebase_options.dart';

class AppInitializer {
  AppInitializer._();

  static final FirebaseMaster _firebaseMaster = FirebaseMaster.instance;
  static final FirestoreManager _firestoreManager = FirestoreManager.instance;
  static final PushNotifications push = PushNotifications.instance;

  static FirebaseAnalyticsObserver get analyticsObserver =>
      _firebaseMaster.analyticsObserver;

  static bool _coreInitialized = false;
  static bool _bootstrapped = false;
  static Completer<void>? _bootstrapCompleter;

  /// Initialize Firebase core — safe from any isolate
  static Future<void> ensureCoreInitialized() async {
    if (_coreInitialized) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _coreInitialized = true;
    _log('[AppInit] Firebase core initialized');
  }

  /// Run all services bootstrap — idempotent
  static Future<void> bootstrapAll() async {
    if (_bootstrapCompleter != null) return _bootstrapCompleter!.future;
    _bootstrapCompleter = Completer<void>();

    try {
      if (!_coreInitialized) {
        await ensureCoreInitialized();
      }

      await _firebaseMaster.initialize();
      await push.init();

      unawaited(_firestoreManager.start());

      _bootstrapped = true;
      _bootstrapCompleter!.complete();
      _log('[AppInit] bootstrapAll complete ✅');
    } catch (e, s) {
      _log('[AppInit] bootstrapAll failed: $e');
      try {
        await _firebaseMaster.recordNonFatal(e, s);
      } catch (_) {}
      _bootstrapCompleter!.completeError(e, s);
    }

    return _bootstrapCompleter!.future;
  }

  static Future<void> dispose() async {
    if (!_bootstrapped) return;
    await _firebaseMaster.dispose();
    await _firestoreManager.dispose();
    _bootstrapped = false;
    _bootstrapCompleter = null;
    _log('[AppInit] disposed');
  }

  static void _log(String msg) {
    if (kDebugMode) debugPrint(msg);
  }
}
