import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/UserData/user_data_request.dart';
import 'package:tcs_app/citizen/Model/AcademicTerm/academic_term_response.dart';

class AcademicTermService {
  static Future<AcademicTermResponse> academicTermRequest(
      {required String userName, required String token}) async {
    UserDataRequest request =
        UserDataRequest(userName: userName, tokenId: token);
    var response =
        await ApiBaseHelper.httpPostRequest("DropDown", body: request.toJson());
    return AcademicTermResponse.fromJson(response);
  }
}
