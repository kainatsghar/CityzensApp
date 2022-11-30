import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class StudentProfileService {
  static Future<StudentProfileResponse> stdProfileRequest(
      {String userName, String token, }) async {
    UserDataRequest _request = UserDataRequest(
        userName: userName,
        tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("Profile",
        body: _request.toJson());
    return StudentProfileResponse.fromJson(response);
  }
}