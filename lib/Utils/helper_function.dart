import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/imagepicker_bottom_sheet.dart';
import 'package:tcs_app/Model/PushNotification/push_notification_response.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunction {
  static List<Options> userTypes() => [
        Options(title: 'Student', value: 1),
        Options(title: 'Parent', value: 2),
        Options(title: 'Teacher', value: 3)
      ];

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    showNotification(message: message);
  }

  static Future<void> showNotification(
      {@required RemoteMessage message}) async {
    var response = PushNotificationResponse.fromJson(message.data);
    var android = const AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max, playSound: true);
    var iOS = const IOSNotificationDetails();
    var notificationDetails = NotificationDetails(android: android, iOS: iOS);
    await FlutterLocalNotificationsPlugin()
        .show(0, '${response.title}', '${response.body}', notificationDetails);
  }

  static Future<void> initializeLocalNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = const IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    await FlutterLocalNotificationsPlugin().initialize(initSettings);
  }

  static Future<void> initializePushNotification() async {
    initializeLocalNotifications();
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
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotification(message: message);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(message: message);
    });
  }

  static Future<void> mainInitializer() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  static List<Options> attendanceOptions() => [
        Options(title: 'P', isSelected: true, color: Colors.green, value: 1),
        Options(title: 'A', isSelected: false, color: Colors.red, value: 2),
        Options(title: 'L', isSelected: false, color: Colors.amber, value: 3)
      ];

  static launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<DateTime> openDatePicker(
      {@required TextEditingController filterDate}) async {
    DateTime now = DateTime.now();
    DateTime initialDate = DateTime(now.year - 3, now.month, now.day);
    final DateTime picked = await showDatePicker(
        context: AppNavigation.currentContext,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: initialDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (ctx, child) => child);
    if (picked != null) {
      filterDate.text = dateFormatter('$picked', format: 'dd-MMM-yyyy');
    }
    return picked;
  }

  static List<Options> genderOptions() => [
        Options(title: 'Male', value: 1),
        Options(title: 'Female', value: 2),
      ];

  static List<Options> previousSchoolOptions() => [
        Options(title: 'Yes', value: 1),
        Options(title: 'No', value: 0),
      ];

  static String dateFormatter(String date, {String format}) =>
      date == null || date == '' || date == 'null'
          ? '-'
          : DateFormat(format ?? 'MMMM dd, yyyy').format(DateTime.parse(date));

  static imagePickerBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => ImagePickerBottomSheet());
  }

  static String numberValue(dynamic number) =>
      number == null || number == '-' || '$number'.isEmpty || number == 'null'
          ? '-'
          : NumberFormat.decimalPattern().format(num.parse(
              removeTrailingZero(num.parse('$number').toStringAsFixed(2))));

  static String validator(String value) {
    if (value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
  }

  static String removeTrailingZero(String string) {
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }

  static String noNullStringText(String value) {
    if (value == 'null' || value == null || value.isEmpty || value == '-') {
      return '-';
    } else {
      return value;
    }
  }
}
