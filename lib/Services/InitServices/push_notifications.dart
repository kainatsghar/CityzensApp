import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/firebase_options.dart';

// Background handler entry-point (must be top-level and visible to the runtime)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Minimal safe background initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FlutterLocalNotificationsPlugin backgroundLocal =
      FlutterLocalNotificationsPlugin();

  // Initialize locally in background isolate (minimal)
  final androidInit = const AndroidInitializationSettings(
    '@mipmap/ic_notification',
  );
  final iosInit = const DarwinInitializationSettings();
  try {
    await backgroundLocal.initialize(
      InitializationSettings(android: androidInit, iOS: iosInit),
    );
  } catch (e) {
    // continue even if init fails; we try to show notification below
    if (kDebugMode) debugPrint('[PN_BG] Local initialize failed: $e');
  }

  // Create channel on background isolate if possible (no prefs)
  if (Platform.isAndroid) {
    try {
      final androidPlugin = backgroundLocal
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'cityzens_notifications',
          'Cityzens Notifications',
          importance: Importance.max,
          playSound: true,
          showBadge: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[PN_BG] createChannel error: $e');
    }
  }

  // Build and show a notification directly
  final title = message.notification?.title ?? '';
  final body = message.notification?.body ?? '';

  final androidDetails = AndroidNotificationDetails(
    'cityzens_notifications',
    'Cityzens Notifications',
    priority: Priority.high,
    importance: Importance.max,
    playSound: true,
    icon: '@mipmap/ic_notification',
    largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_notification'),
  );
  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  try {
    await backgroundLocal.show(
      Random().nextInt(0x7FFFFFFF),
      title,
      body,
      details,
      payload: message.data['route'] ?? message.data['openUrl'],
    );
    if (kDebugMode) {
      debugPrint('[PN_BG] Notification shown from background (title: $title)');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[PN_BG] Error showing background notification: $e');
    }
  }
}

class PushNotifications {
  PushNotifications._();
  static final PushNotifications instance = PushNotifications._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _channelCreated = false;
  bool _cachedEnabled = true;

  static const String _channelId = 'cityzens_notifications';
  static const String _channelName = 'Cityzens Notifications';
  static const String _prefsKey = 'notifications_enabled';

  Future<void> init() async {
    if (_initialized) return;

    await _initializeLocalNotifications();

    final messaging = FirebaseMessaging.instance;

    // Request permission
    try {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint(
          '[PN] Notification permission: ${settings.authorizationStatus}',
        );
      }
    } catch (e) {
      debugPrint('[PN] Permission request failed: $e');
    }

    // cache pref
    _cachedEnabled = await _readEnabledPref();

    // Foreground presentation (iOS)
    try {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('[PN] setForegroundNotificationPresentationOptions error: $e');
    }

    _initialized = true;
    if (kDebugMode) {
      debugPrint('[PN] PushNotifications initialized (main isolate)');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    final android = const AndroidInitializationSettings(
      '@mipmap/ic_notification',
    );
    final ios = const DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    try {
      await _local.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          final payload = details.payload;
          if (payload == null) return;
          _handleLocalPayload(payload);
        },
      );
    } catch (e) {
      debugPrint('[PN] Local notifications init error: $e');
    }

    if (Platform.isAndroid && !_channelCreated) {
      final androidPlugin = _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          importance: Importance.max,
          playSound: true,
          showBadge: true,
        ),
      );
      _channelCreated = true;
    }
  }

  Future<void> showFromForeground({required RemoteMessage message}) async {
    if (!await isEnabled()) return;
    await _show(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      payload: message.data['route'] ?? message.data['openUrl'],
    );
  }

  Future<void> showFromBackgroundSafe(RemoteMessage message) async {
    // Compatibility wrapper - background handler uses its own implementation
    await _show(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      payload: message.data['route'] ?? message.data['openUrl'],
    );
  }

  Future<void> _show(String title, String body, {String? payload}) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      icon: '@mipmap/ic_notification',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_notification'),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _local.show(
        Random().nextInt(0x7FFFFFFF),
        title,
        body,
        details,
        payload: payload,
      );
      if (kDebugMode) {
        debugPrint('[PN] Local notification shown (title: $title)');
      }
    } catch (e) {
      debugPrint('[PN] Error showing notification: $e');
    }
  }

  Future<void> handleNotificationTap(RemoteMessage message) async {
    final route = message.data['route'];
    final openUrl = message.data['openUrl'];
    if (openUrl != null && openUrl.isNotEmpty) {
      HelperFunction.launchURL(openUrl);
      return;
    }
    if (route != null && route.isNotEmpty) {
      _navigateTo(route);
    }
  }

  Future<void> handleNotificationTapFromPayload(String payload) async {
    if (payload.startsWith('http')) {
      HelperFunction.launchURL(payload);
    } else {
      _navigateTo(payload);
    }
  }

  void _handleLocalPayload(String payload) {
    if (payload.startsWith('http')) {
      HelperFunction.launchURL(payload);
    } else {
      _navigateTo(payload);
    }
  }

  void _navigateTo(String route) {
    if (route == 'Diary') {
      AppNavigation.navigateTo(AppNavRoutes.studentDiaryRoute);
    } else if (route == 'Classwork') {
      AppNavigation.navigateTo(AppNavRoutes.studentAssignmentRoute);
    } else {
      if (AppNavRoutes.isRouteAvailable(route)) AppNavigation.navigateTo(route);
    }
  }

  Future<bool> isEnabled() async {
    return _cachedEnabled;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    _cachedEnabled = enabled;
  }

  Future<bool> _readEnabledPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? true;
  }
}
