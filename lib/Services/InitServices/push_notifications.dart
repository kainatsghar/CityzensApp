import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Routes/app_navigation.dart';
import '../../Routes/app_navigation_routes.dart';
import '../../Utils/helper_function.dart';

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

    await _initializeLocal();
    await _requestPermission();

    _cachedEnabled = await _readEnabledPref();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Foreground messages
    FirebaseMessaging.onMessage.listen(showFromForegroundMessage);

    // Opened messages
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);

    // Terminated case
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationTap(initial);
      });
    }

    _initialized = true;
    _log('[PN] PushNotifications initialized');
  }

  Future<void> _initializeLocal() async {
    final android = const AndroidInitializationSettings(
      '@mipmap/ic_notification',
    );
    final ios = const DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        final data = details.data;

        if (data.isNotEmpty) {
          _log('[PN] Handling data from local notification: $data');
          final route = data['route'];
          if (route != null) {
            _handlePayload(route, extras: data);
          } else if (data.containsKey('openUrl')) {
            HelperFunction.launchURL(data['openUrl']!);
          }
        }

        final payload = details.payload;
        if (payload != null) {
          _log('[PN] Handling payload from local notification: $payload');
          if (payload.startsWith('http')) {
            _handleNotificationLink(payload);
          } else {
            _handlePayload(payload);
          }
        }
      },
    );

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

  Future<void> _requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      _log('[PN] Permission: ${settings.authorizationStatus}');
    } catch (e) {
      _log('[PN] Permission request failed: $e');
    }
  }

  Future<void> showFromForegroundMessage(RemoteMessage message) async {
    if (!await isEnabled()) return;
    await _show(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      payload: message.data['route'] ?? message.data['openUrl'],
    );
  }

  Future<void> showFromBackgroundSafe(RemoteMessage message) async {
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

    await _local.show(
      id: Random().nextInt(0x7FFFFFFF),
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
    _log('[PN] Notification shown (title: $title)');
  }

  Future<void> handleNotificationTap(RemoteMessage message) async {
    if (message.data.isEmpty) {
      _log('[PN] No payload in tapped notification');
      return;
    }

    _log('[PN] Handling payload: ${message.data}');

    final route = message.data['route'];

    if (route != null) {
      _handlePayload(route, extras: message.data);
    } else if (message.data.containsKey('openUrl')) {
      HelperFunction.launchURL(message.data['openUrl']!);
      return;
    } else {
      _log('[PN] Unknown payload: ${message.data}');
    }
  }

  void _handlePayload(String route, {Map<String, dynamic>? extras}) {
    _log('[PN] Executing payload: $route with extras: $extras');

    switch (route) {
      // case 'Challan':
      //   if (extras?['studentId'] != null) {
      //     final id = extras!['studentId'];
      //     AppNavigation.navigateTo(
      //       AppNavRoutes.feeChallansRoute,
      //       arguments: {'studentId': id},
      //     );
      //   } else {
      //     AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute);
      //   }
      //   break;

      case 'Diary':
        AppNavigation.navigateTo(AppNavRoutes.studentDiaryRoute);
        break;

      case 'Classwork':
        AppNavigation.navigateTo(AppNavRoutes.studentAssignmentRoute);
        break;

      default:
        if (AppNavRoutes.isRouteAvailable(route)) {
          AppNavigation.navigateTo(route, arguments: extras);
        } else {
          _log('[PN] Unknown payload: $route');
        }
    }
  }

  void _handleNotificationLink(String? link) {
    if (link == null || link.isEmpty) return;

    // Ensure it’s a proper URL
    final url = link.startsWith('http') ? link : 'https://$link';
    HelperFunction.launchURL(url);
  }

  // Future<void> handleNotificationTap(RemoteMessage message) async {
  //   final payload = message.data['route'] ?? message.data['openUrl'];
  //   if (payload != null) _handlePayload(payload);
  // }

  // void _handlePayload(String payload) {
  //   if (payload.startsWith('http')) {
  //     HelperFunction.launchURL(payload);
  //   } else if (payload == 'Diary') {
  //     AppNavigation.navigateTo(AppNavRoutes.studentDiaryRoute);
  //   } else if (payload == 'Classwork') {
  //     AppNavigation.navigateTo(AppNavRoutes.studentAssignmentRoute);
  //   } else if (AppNavRoutes.isRouteAvailable(payload)) {
  //     AppNavigation.navigateTo(payload);
  //   }
  // }

  Future<bool> isEnabled() async => _cachedEnabled;

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    _cachedEnabled = enabled;
  }

  Future<bool> _readEnabledPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? true;
  }

  void _log(String msg) {
    if (kDebugMode) debugPrint(msg);
  }
}
