import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/imagepicker_bottom_sheet.dart';
import 'package:tcs_app/PushNotifications/push_notifications.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/firebase_options.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunction {
  static List<Options> userTypes() => [
    Options(title: 'Student', value: 1),
    Options(title: 'Parent', value: 2),
    Options(title: 'Teacher', value: 3),
  ];

  static Future<void> mainInitializer() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // await _initAnalytics();

    await initializeFCM();

    FirebaseMessaging.onBackgroundMessage(
      PushNotificationsManager.firebaseMessagingBackgroundHandler,
    );
    // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await initRemoteConfig();
  }

  static Future<void> initRemoteConfig() async {
    try {
      FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

      debugPrint('Initializing Remote Config...');
      await remoteConfig.ensureInitialized();
      debugPrint('Remote Config initialized');

      debugPrint('Setting Remote Config defaults...');
      await remoteConfig.setDefaults({'apiBaseUrl': AppConstants.apiBaseURL});
      debugPrint('Remote Config defaults set');

      debugPrint('Configuring Remote Config settings...');
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: Duration.zero,
        ),
      );
      debugPrint('Remote Config settings configured');

      bool configApplied = false;
      try {
        debugPrint('Fetching Remote Config values...');
        final bool activated = await remoteConfig.fetchAndActivate();
        debugPrint('Remote Config activation result: $activated');

        if (activated) {
          setApiBaseUrl(remoteConfig);
          configApplied = true;

          remoteConfig.onConfigUpdated.listen((event) async {
            debugPrint('Remote Config update received');
            final bool updated = await remoteConfig.activate();
            if (updated) {
              setApiBaseUrl(remoteConfig);
            }
          });
        }
      } catch (fetchError) {
        debugPrint('Error during fetch/activate: $fetchError');
        if (fetchError.toString().contains('403')) {
          debugPrint(
            '403 error detected. Checking if Firebase is properly initialized...',
          );
          debugPrint(
            'Current platform options: ${DefaultFirebaseOptions.currentPlatform}',
          );
        }
        // Only use last fetched values if we haven't already applied config
        if (!configApplied) {
          setApiBaseUrl(remoteConfig);
        }
      }
    } catch (e, stack) {
      debugPrint('Remote Config initialization error: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  // static Future<void> _initAnalytics() async {
  //   // Initialize Firebase Analytics
  //   try {
  //     final analytics = FirebaseAnalytics.instance;
  //     if (!kDebugMode) {
  //       await analytics.setAnalyticsCollectionEnabled(true);
  //     }
  //   } catch (e) {
  //     debugPrint('Error initializing Firebase Analytics: $e');
  //   }
  // }

  static void setApiBaseUrl(FirebaseRemoteConfig remoteConfig) {
    String apiBaseUrl = remoteConfig.getString('apiBaseUrl');
    if (apiBaseUrl.isNotEmpty) {
      // Remove any trailing slashes from the base URL
      apiBaseUrl = apiBaseUrl.replaceAll(RegExp(r'/api/'), '');

      debugPrint('API Base URL: $apiBaseUrl');
      AppConstants.baseUrl = apiBaseUrl;
      AppConstants.apiBaseURL = '$apiBaseUrl/api/';
      debugPrint('API URL: ${AppConstants.apiBaseURL}');
    }
  }

  static List<Options> attendanceOptions() => [
    Options(
      title: 'Present',
      isSelected: true,
      color: AppColors.successGreenColor,
      value: 1,
    ),
    Options(
      title: 'Absent',
      isSelected: false,
      color: AppColors.valuesRedColors,
      value: 2,
    ),
    Options(title: 'Leave', isSelected: false, color: Colors.amber, value: 3),
    Options(
      title: 'Unreconciled',
      isSelected: false,
      color: Colors.grey,
      value: 35,
    ),
  ];

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<DateTime?> openDatePicker({
    @required TextEditingController? filterDate,
  }) async {
    DateTime now = DateTime.now();
    DateTime initialDate = DateTime(now.year - 3, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: AppNavigation.currentContext!,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (ctx, child) => child!,
    );
    if (picked != null) {
      filterDate!.text = dateFormatter('$picked', format: 'dd-MMM-yyyy');
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

  static String dateFormatter(String? date, {String? format}) =>
      date == null || date == '' || date == 'null'
      ? '-'
      : DateFormat(format ?? 'MMMM dd, yyyy').format(DateTime.parse(date));

  static void imagePickerBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => const ImagePickerBottomSheet(),
    );
  }

  static String numberValue(dynamic number) =>
      number == null || number == '-' || '$number'.isEmpty || number == 'null'
      ? '-'
      : NumberFormat.decimalPattern().format(
          num.parse(
            removeTrailingZero(num.parse('$number').toStringAsFixed(2)),
          ),
        );

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!;
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

  static String noNullStringText(String? value) {
    if (value == 'null' || value == null || value.isEmpty || value == '-') {
      return '-';
    } else {
      return value;
    }
  }
}

Future<void> initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  try {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }
  } on Exception catch (e) {
    debugPrint('Error requesting notification permission: $e');
  }

  // Obtain tokens based on platform
  if (Platform.isIOS) {
    try {
      await Future.delayed(const Duration(seconds: 2));
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        //print("APNS Token: $apnsToken");
      } else {
        //print("Failed to obtain APNS Token.");
      }
    } on Exception catch (e) {
      debugPrint('Error obtaining APNS Token: $e');
    }
  }

  // For both Android and iOS, get the FCM token
  try {
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      //print("FCM Token: $fcmToken");
    } else {
      //print("Failed to obtain FCM Token.");
    }
  } on Exception catch (e) {
    debugPrint('Error obtaining FCM Token: $e');
  }
}
