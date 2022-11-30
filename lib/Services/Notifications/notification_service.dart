import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class NotificationService {
  static Future<NotificationResponse> notificationRequest(
      {String userName, String token, String group}) async {
    UserDataRequest _request =
        UserDataRequest(userName: userName, tokenId: token, group: group);
    var response = await ApiBaseHelper.httpPostRequest("Notifications",
        body: _request.toJson());
    return NotificationResponse.fromJson(response);
  }
}
