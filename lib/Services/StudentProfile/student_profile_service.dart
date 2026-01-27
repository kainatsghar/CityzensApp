import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class StudentProfileService {
  static Future<StudentProfileResponse> stdProfileRequest({
    required String userName,
    required String token,
  }) async {
    UserDataRequest request = UserDataRequest(
      userName: userName,
      tokenId: token,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "Profile",
      body: request.toJson(),
    );
    return StudentProfileResponse.fromJson(response);
  }
}
