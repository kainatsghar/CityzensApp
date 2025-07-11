import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Routes/app_navigation.dart';
import '../Routes/app_navigation_routes.dart';

// ignore: constant_identifier_names
enum AppState { Foreground, Background, Terminated }

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  static Future<void> init() async {
    await Firebase.initializeApp();
    await _initializePushNotification();
  }

  static Future<void> _showNotification({RemoteMessage? message}) async {
    var android = const AndroidNotificationDetails(
      'id',
      'channel ',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      icon: '@mipmap/ic_notification',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_notification'),
    );
    var iOS = const DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(android: android, iOS: iOS);
    await FlutterLocalNotificationsPlugin().show(
        Random().nextInt(1000),
        '${message!.notification!.title}',
        '${message.notification!.body}',
        notificationDetails,
        payload: message.data['route']);
  }

  static Future<void> _initializeLocalNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_notification');
    var initializationSettingsIOs = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    await FlutterLocalNotificationsPlugin().initialize(initSettings);
  }

  static Future<void> _initializePushNotification() async {
    _initializeLocalNotifications();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    if (Platform.isIOS) {
      firebaseMessaging.getNotificationSettings();
    }
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message, true);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _showNotification(message: message);
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // _showNotification
    //
    //n(message: message);
  }

  static void _handleNotificationClick(
      RemoteMessage message, bool openedFromTerminated) {
    String? route = message.data['route'];
    if (route != null) {
      if (openedFromTerminated) {
        // If the app was terminated when the notification was clicked, navigate to the desired page directly
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToPage(route);
        });
      } else {
        // If the app was in foreground/background, directly navigate to the desired page.
        _navigateToPage(route);
      }
    }
  }

  static void _navigateToPage(String route) {
    if (route == 'Diary') {
      AppNavigation.navigateTo(AppNavRoutes.studentDiaryRoute);
    } else if (route == 'Classwork') {
      AppNavigation.navigateTo(AppNavRoutes.studentAssignmentRoute);
    }
  }
}
