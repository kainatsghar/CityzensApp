import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/Services/InitServices/firebase_master.dart';
import 'package:tcs_app/Services/InitServices/firestore_manager.dart';
import 'package:tcs_app/Services/InitServices/push_notifications.dart';
import 'package:tcs_app/firebase_options.dart';

class AppInitializer {
  AppInitializer._();

  static final FirebaseMaster _firebaseMaster = FirebaseMaster.instance;
  static final FirestoreManager _firestoreManager = FirestoreManager.instance;

  // inside class Bootstrap
  static FirebaseAnalyticsObserver get analyticsObserver =>
      _firebaseMaster.analyticsObserver;

  static bool _coreInitialized = false;
  static bool _bootstrapped = false;
  static Completer<void>? _bootstrapCompleter;

  /// Initialize Firebase core — safe to call from any isolate.
  static Future<void> ensureCoreInitialized() async {
    if (_coreInitialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _coreInitialized = true;
      _debug('[Bootstrap] Firebase core initialized');
    } catch (e, s) {
      _debug('[Bootstrap] Firebase core init failed: $e : $s');
      rethrow;
    }
  }

  /// Run all bootstrap steps — idempotent & safe to call multiple times.
  static Future<void> bootstrapAll() async {
    if (_bootstrapCompleter != null) return _bootstrapCompleter!.future;
    _bootstrapCompleter = Completer<void>();

    try {
      if (!_coreInitialized) {
        await ensureCoreInitialized();
      }

      // Initialize Firebase services sequentially
      await _firebaseMaster.initialize();
      await PushNotifications.instance.init();

      // Start Firestore manager (non-blocking, internal error-safe)
      unawaited(_firestoreManager.start());

      _bootstrapped = true;
      _bootstrapCompleter!.complete();
      _debug('[Bootstrap] bootstrapAll complete ✅');
    } catch (e, s) {
      _debug('[Bootstrap] bootstrapAll failed: $e');
      try {
        await _firebaseMaster.recordNonFatal(e, s);
      } catch (_) {}
      _bootstrapCompleter!.completeError(e, s);
    }

    return _bootstrapCompleter!.future;
  }

  /// Gracefully shut down services (optional — call on app exit).
  static Future<void> dispose() async {
    if (!_bootstrapped) return;
    await _firebaseMaster.dispose();
    await _firestoreManager.dispose();
    _bootstrapped = false;
    _bootstrapCompleter = null;
    _debug('[Bootstrap] disposed');
  }

  static void _debug(String msg) {
    if (kDebugMode) debugPrint(msg);
  }
}
