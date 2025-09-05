import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/Services/InitServices/push_notifications.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class FirebaseMaster {
  FirebaseMaster._internal();
  static final FirebaseMaster instance = FirebaseMaster._internal();

  // init guard
  bool _initialized = false;

  // statuses map for debug
  final Map<String, bool> _status = {
    'crashlytics': false,
    'analytics': false,
    'fcm': false,
    'remoteConfig': false,
  };

  // subscriptions
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;
  StreamSubscription<RemoteConfigUpdate>? _rcUpdateSub;

  // analytics observer
  FirebaseAnalyticsObserver? _analyticsObserver;
  FirebaseAnalyticsObserver get analyticsObserver => _analyticsObserver ??=
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  bool get isInitialized => _initialized;
  Map<String, bool> get statuses => Map.unmodifiable(_status);

  Future<void> initialize() async {
    if (_initialized) return;
    if (kDebugMode) debugPrint('[FM] Starting FirebaseMaster.initialize');

    await _initCrashlytics();
    await _initAnalytics();
    await _initRemoteConfig();
    await _initFCMListeners();

    _initialized = true;
    if (kDebugMode) debugPrint('[FM] FirebaseMaster initialized: $_status');
  }

  Future<void> _initCrashlytics() async {
    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      _status['crashlytics'] = true;
      if (kDebugMode) debugPrint('[FM] Crashlytics initialized');
    } catch (e, s) {
      _status['crashlytics'] = false;
      debugPrint('[FM] Crashlytics init failed: $e : $s');
    }
  }

  Future<void> _initAnalytics() async {
    try {
      final analytics = FirebaseAnalytics.instance;
      final supported = await _isAnalyticsAvailable();
      if (!supported) {
        _status['analytics'] = false;
        debugPrint('[FM] Analytics not supported');
        return;
      }
      await analytics.setAnalyticsCollectionEnabled(true);
      await analytics.logAppOpen();
      _analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics);
      _status['analytics'] = true;
      if (kDebugMode) debugPrint('[FM] Analytics initialized');
    } on PlatformException catch (e) {
      _status['analytics'] = false;
      debugPrint('[FM] Analytics PlatformException: $e');
    } catch (e) {
      _status['analytics'] = false;
      debugPrint('[FM] Analytics init error: $e');
    }
  }

  Future<bool> _isAnalyticsAvailable() async {
    try {
      return await FirebaseAnalytics.instance.isSupported();
    } catch (e) {
      return false;
    }
  }

  Future<void> _initRemoteConfig() async {
    final rc = FirebaseRemoteConfig.instance;

    try {
      await rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 20),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await rc.setDefaults({'apiBaseUrl': AppConstants.apiBaseURL});
    } catch (e, s) {
      debugPrint('[FM] Remote Config settings failed: $e');
      await recordNonFatal(e, s);
    }

    // Try fetch + activate separately
    try {
      await rc.fetch();
      final didActivate = await rc.activate();
      if (didActivate) {
        _applyRemoteConfig(rc, rc.getAll().keys.toSet());
      }
    } catch (e, s) {
      debugPrint('[FM] Remote Config initial fetch failed: $e');
      await recordNonFatal(e, s);
      // still continue to listen for updates
    }

    // Always attach listener even if fetch failed
    try {
      await _rcUpdateSub?.cancel();
      _rcUpdateSub = rc.onConfigUpdated.listen((event) async {
        try {
          final didActivate = await rc.activate();
          if (didActivate) {
            _applyRemoteConfig(rc, event.updatedKeys);
            if (kDebugMode) {
              debugPrint(
                '[FM] Remote Config updated: ${event.updatedKeys.join(', ')}',
              );
            }
          }
        } catch (e, s) {
          await recordNonFatal(e, s);
        }
      });
    } catch (e, s) {
      debugPrint('[FM] Remote Config listener failed: $e');
      await recordNonFatal(e, s);
    }

    _status['remoteConfig'] = true;
    debugPrint('[FM] Remote Config initialized');
  }

  void _applyRemoteConfig(FirebaseRemoteConfig rc, Set<String> keys) {
    try {
      if (keys.contains('apiBaseUrl')) {
        final url = rc.getString('apiBaseUrl');
        if (url.isNotEmpty &&
            (url.startsWith('http://') || url.startsWith('https://'))) {
          final clean = url.replaceAll(RegExp(r'/api/?$'), '');
          AppConstants.baseUrl = clean;
          AppConstants.apiBaseURL = '$clean/api/';
          debugPrint('[FM] API URL updated: ${AppConstants.apiBaseURL}');
        } else {
          FirebaseCrashlytics.instance.recordError(
            'Invalid apiBaseUrl',
            StackTrace.current,
          );
        }
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  Future<void> _initFCMListeners() async {
    try {
      // Cancel existing subs before attaching (prevents leaks)
      await _onMessageSub?.cancel();
      await _onMessageOpenedAppSub?.cancel();

      _onMessageSub = FirebaseMessaging.onMessage.listen((message) async {
        // Forward to PushNotifications to show local notification (main isolate)
        await PushNotifications.instance.showFromForegroundMessage(message);
      });

      _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen((
        message,
      ) {
        PushNotifications.instance.handleNotificationTap(message);
      });

      // Terminated case: getInitialMessage (fire once on cold start)
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) {
        // Delay navigation until first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PushNotifications.instance.handleNotificationTap(initial);
        });
      }

      _status['fcm'] = true;
      if (kDebugMode) debugPrint('[FM] FCM listeners attached');
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
    _onMessageSub = null;
    _onMessageOpenedAppSub = null;
    _rcUpdateSub = null;
    _initialized = false;
  }
}
