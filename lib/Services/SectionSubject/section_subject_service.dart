import '../../Model/SectionSubject/section_subject_response.dart';
import '../../Network/api_base_helper.dart';
import '../../model/UserData/user_data_request.dart';

class SectionSubjectService {
  static Future<SectionSubjectResponse> getSubjectsRequest(
      {String userName, String token}) async {
    UserDataRequest _request =
        UserDataRequest(userName: userName, tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("GetSubjects",
        body: _request.toJson());
    return SectionSubjectResponse.fromJson(response);
  }
}
