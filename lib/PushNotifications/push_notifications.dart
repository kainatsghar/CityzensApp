import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppState { Foreground, Background, Terminated }

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  static Future<void> init() async {
    await _initializePushNotification();
  }

  static Future<void> _showNotification({RemoteMessage message}) async {
    var android = const AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max, playSound: true);
    var iOS = const DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(android: android, iOS: iOS);
    await FlutterLocalNotificationsPlugin().show(
        Random().nextInt(1000),
        '${message.notification.title}',
        '${message.notification.body}',
        notificationDetails);
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
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
          alert: true, sound: true, badge: true);
      _firebaseMessaging.getNotificationSettings();
    } else {
      _firebaseMessaging.requestPermission(
          alert: true, sound: true, badge: true);
    }
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //  _showNotification(message: message);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _showNotification(message: message);
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // _showNotification(message: message);
  }
}
