import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/TeacherProfile/teacher_profile_response.dart';
import 'package:tcs_app/citizen/Model/UserData/user_data_request.dart';

class TeacherProfileService {
  static Future<TeacherProfileResponse> teacherProfileRequest({required String userName, required String token}) async {
    UserDataRequest request = UserDataRequest(tokenId: token, userName: userName);
    var response = await ApiBaseHelper.httpPostRequest("TeacherProfile", body: request.toJson());
    return TeacherProfileResponse.fromJson(response);
  }
}
