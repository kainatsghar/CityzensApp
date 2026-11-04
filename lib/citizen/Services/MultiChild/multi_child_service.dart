import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/citizen/Model/UserData/user_data_request.dart';

class MultiChildService {
  static Future<MultiChildResponse> multiChildRequest(
      {required String userName, required String token}) async {
    UserDataRequest request =
        UserDataRequest(userName: userName, tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("ChildrenList",
        body: request.toJson());
    return MultiChildResponse.fromJson(response);
  }
}
