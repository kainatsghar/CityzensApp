import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/services/InitServices/push_notifications.dart';
import 'package:tcs_app/utils/app_constants.dart';

class FirebaseMaster {
  FirebaseMaster._internal();
  static final FirebaseMaster instance = FirebaseMaster._internal();

  bool _initialized = false;

  final Map<String, bool> _status = {
    'crashlytics': false,
    'analytics': false,
    'fcm': false,
    'remoteConfig': false,
  };

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;
  StreamSubscription<RemoteConfigUpdate>? _rcUpdateSub;

  FirebaseAnalyticsObserver? _analyticsObserver;
  FirebaseAnalyticsObserver get analyticsObserver => _analyticsObserver ??=
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  bool get isInitialized => _initialized;
  Map<String, bool> get statuses => Map.unmodifiable(_status);

  /// 🔥 Optimized initialization (parallel + minimal execution)
  Future<void> initialize() async {
    if (_initialized) return;
    if (kDebugMode) debugPrint('[FM] Starting FirebaseMaster.initialize');

    await Future.wait([
      _initCrashlytics(),
      _initAnalytics(),
      // _initRemoteConfig(),
      _initFCMListeners(),
    ]);

    _initialized = true;
    if (kDebugMode) debugPrint('[FM] FirebaseMaster initialized: $_status');
  }

  Future<void> _initCrashlytics() async {
    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      _status['crashlytics'] = true;
    } catch (e, s) {
      _status['crashlytics'] = false;
      debugPrint('[FM] Crashlytics init failed: $e');
      await recordNonFatal(e, s);
    }
  }

  Future<void> _initAnalytics() async {
    try {
      final analytics = FirebaseAnalytics.instance;
      if (await _isAnalyticsAvailable()) {
        await analytics.setAnalyticsCollectionEnabled(true);
        _analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics);
        _status['analytics'] = true;
      }
    } catch (e, s) {
      _status['analytics'] = false;
      debugPrint('[FM] Analytics init failed: $e');
      await recordNonFatal(e, s);
    }
  }

  Future<bool> _isAnalyticsAvailable() async {
    try {
      return await FirebaseAnalytics.instance.isSupported();
    } catch (_) {
      return false;
    }
  }

  Future<void> _initRemoteConfig() async {
    final rc = FirebaseRemoteConfig.instance;

    try {
      await rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 20),
          minimumFetchInterval: const Duration(minutes: 5), // 🔑 optimized
        ),
      );
      await rc.setDefaults({'apiBaseUrl': AppConstants.apiBaseURL});
    } catch (e, s) {
      debugPrint('[FM] Remote Config settings failed: $e');
      await recordNonFatal(e, s);
    }

    // Apply cached/default immediately
    _applyRemoteConfig(rc, rc.getAll().keys.toSet(), source: "defaults/cached");

    // Fetch+activate once
    try {
      final activated = await rc.fetchAndActivate();
      _applyRemoteConfig(
        rc,
        rc.getAll().keys.toSet(),
        source: activated ? "fetched" : "cached",
      );
    } catch (e, s) {
      debugPrint('[FM] Remote Config fetch error: $e');
      await recordNonFatal(e, s);
    }

    // Attach live listener (efficient)
    try {
      await _rcUpdateSub?.cancel();
      _rcUpdateSub = rc.onConfigUpdated.listen((event) async {
        if (await rc.activate()) {
          _applyRemoteConfig(rc, event.updatedKeys, source: "listener");
        }
      });
    } catch (e, s) {
      debugPrint('[FM] Remote Config listener failed: $e');
      await recordNonFatal(e, s);
    }

    _status['remoteConfig'] = true;
  }

  void _applyRemoteConfig(
    FirebaseRemoteConfig rc,
    Set<String> keys, {
    String source = "unknown",
  }) {
    if (keys.contains('apiBaseUrl')) {
      final url = rc.getString('apiBaseUrl').trim();
      if (url.startsWith('http://') || url.startsWith('https://')) {
        final clean = url.replaceAll(RegExp(r'/api/?$'), '');
        AppConstants.baseUrl = clean;
        AppConstants.apiBaseURL = '$clean/api/';
        debugPrint(
          '[FM] API URL updated from $source: ${AppConstants.apiBaseURL}',
        );
      } else {
        FirebaseCrashlytics.instance.recordError(
          'Invalid apiBaseUrl (source: $source)',
          StackTrace.current,
        );
      }
    }
  }

  Future<void> _initFCMListeners() async {
    try {
      await _onMessageSub?.cancel();
      await _onMessageOpenedAppSub?.cancel();

      _onMessageSub = FirebaseMessaging.onMessage.listen(
        (msg) => PushNotifications.instance.showFromForegroundMessage(msg),
      );

      _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen((
        msg,
      ) {
        PushNotifications.instance.handleNotificationTap(msg);
      });

      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PushNotifications.instance.handleNotificationTap(initial);
        });
      }

      _status['fcm'] = true;
    } catch (e, s) {
      _status['fcm'] = false;
      debugPrint('[FM] FCM init failed: $e');
      await recordNonFatal(e, s);
    }
  }

  Future<void> recordNonFatal(Object error, StackTrace stack) async {
    try {
      if (_status['crashlytics'] == true) {
        await FirebaseCrashlytics.instance.recordError(error, stack);
      }
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _onMessageSub?.cancel();
    await _onMessageOpenedAppSub?.cancel();
    await _rcUpdateSub?.cancel();
    _initialized = false;
  }
}
