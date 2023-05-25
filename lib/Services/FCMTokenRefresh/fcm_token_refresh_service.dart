import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/model/Login/login_request.dart';

class FcmTokenRefreshService {
  static Future<bool> refreshToken() async {
    String fcmToken = await FirebaseMessaging.instance.getToken();
    var localData = Provider.of<LocalDataProvider>(AppNavigation.currentContext,
        listen: false);
    LoginRequest _request = LoginRequest(
        username: localData.userData.userName,
        userType: localData.userData.userType,
        fcmToken: fcmToken);
    var response = await ApiBaseHelper.httpPostRequest("RefreshToken",
        body: _request.toJson());
    return response['Status'] ?? false;
  }
}
