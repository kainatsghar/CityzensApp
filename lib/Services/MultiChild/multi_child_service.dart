import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class MultiChildService {
  static Future<MultiChildResponse> multiChildRequest(
      {String userName, String token, }) async {
    UserDataRequest _request = UserDataRequest(
        userName: userName,
        tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("ChildrenList",
        body: _request.toJson());
    return MultiChildResponse.fromJson(response);
  }
}