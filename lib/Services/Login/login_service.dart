import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Login/login_request.dart';
import 'package:tcs_app/model/Login/login_response.dart';

class LoginService {
  static Future<LoginResponse> loginRequest(
    String username,
    String password,
    String userType,
  ) async {
    //String? fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    // ignore: unused_local_variable
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint('User declined or has not accepted permission');
      }
    } on Exception catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }

    String? fcmToken;
    String? iosFcmToken;

    if (Platform.isIOS == true) {
      // Ensure token is generated
      try {
        fcmToken = await messaging.getAPNSToken();
        // ignore: avoid_print
        //print("APNS Token: $fcmToken");
        iosFcmToken = await messaging.getToken();
        // ignore: avoid_print
        //print("FCM Token: $iosFcmToken");

        // if (fcmToken == null) {
        //   //print("APNS Token has not been generated yet.");
        // } else {
        //   //print("APNS Token: $fcmToken");
        // }
      } on Exception catch (e) {
        debugPrint('Error obtaining APNS Token: $e');
      }
    } else {
      try {
        fcmToken = await messaging.getToken();
      } on Exception catch (e) {
        debugPrint('Error obtaining FCM Token: $e');
      }
    }
    debugPrint("FCM Token: $fcmToken");

    LoginRequest loginRequest = LoginRequest(
      username: username,
      password: password,
      userType: userType,
      fcmToken: fcmToken,
      iosFcmToken: iosFcmToken,
      isIOSDevice: Platform.isIOS,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "Auth",
      body: loginRequest.toJson(),
    );
    var loginResponse = LoginResponse.fromJson(response);
    return loginResponse;
  }

  // static Future<LoginResponse> loginRequest(
  //     String username, String password, String userType) async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   // Request permission for notifications
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   String? fcmToken;
  //   String? apnsToken;

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     // Get FCM token
  //     fcmToken = await messaging.getToken();
  //     print("FCM Token: $fcmToken");

  //     // Get APNS token for iOS
  //     if (Platform.isIOS) {
  //       // Try getting the APNS token
  //       apnsToken = await messaging.getAPNSToken();
  //       if (apnsToken == null) {
  //         print("APNS Token not set yet. Retrying...");
  //         // Retry after a short delay
  //         await Future.delayed(Duration(seconds: 2));
  //         apnsToken = await messaging.getAPNSToken();
  //       }
  //       print("APNS Token: $apnsToken");
  //     }
  //   } else {
  //     print("User has not granted permission for notifications.");
  //   }

  //   LoginRequest loginRequest = LoginRequest(
  //     username: username,
  //     password: password,
  //     userType: userType,
  //     fcmToken: fcmToken,
  //     iosFcmToken: apnsToken, // Assuming you still want to use this
  //     isIOSDevice: Platform.isIOS,
  //   );

  //   var response = await ApiBaseHelper.httpPostRequest("Auth",
  //       body: loginRequest.toJson());
  //   var loginResponse = LoginResponse.fromJson(response);
  //   return loginResponse;
  // }
}
