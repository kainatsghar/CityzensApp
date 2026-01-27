import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class NotificationService {
  static Future<NotificationResponse> notificationRequest({
    required String userName,
    required String token,
    required String group,
  }) async {
    UserDataRequest request = UserDataRequest(
      userName: userName,
      tokenId: token,
      group: group,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "Notifications",
      body: request.toJson(),
    );
    return NotificationResponse.fromJson(response);
  }
}
