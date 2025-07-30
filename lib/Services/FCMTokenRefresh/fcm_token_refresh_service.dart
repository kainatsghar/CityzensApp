import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/model/Login/login_request.dart';

class FcmTokenRefreshService {
  static Future<bool> refreshToken() async {
    //String? fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? fcmToken;
    String? iosFcmToken;

    if (Platform.isIOS) {
      // Obtain the FCM token for iOS
      await Future.delayed(const Duration(seconds: 2));
      fcmToken = await messaging.getAPNSToken();
      //iosFcmToken = await messaging.getToken();
      if (fcmToken == null) {
        // Token generation might not be ready yet
        //print("FCM Token for iOS has not been generated yet.");
        return false;
      }
    } else {
      // Obtain the FCM token for Android
      fcmToken = await messaging.getToken();
      if (fcmToken == null) {
        //print("FCM Token for Android has not been generated yet.");
        return false;
      }
    }
    debugPrint("FCM Token: $fcmToken");
    var localData = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    LoginRequest request = LoginRequest(
      username: localData.userData!.userName,
      userType: localData.userData!.userType,
      fcmToken: fcmToken,
      iosFcmToken: iosFcmToken,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "RefreshToken",
      body: request.toJson(),
    );
    return response['Status'] ?? false;
  }
}
