import 'package:tcs_app/Model/SectionSubject/section_subject_request.dart';

import '../../Model/SectionSubject/section_subject_response.dart';
import '../../Network/api_base_helper.dart';

class SectionSubjectService {
  static Future<SectionSubjectResponse> getSubjectsRequest(
      {String classSectionId, String token, String teacherId}) async {
    SectionSubjectRequest _request = SectionSubjectRequest(
        id: classSectionId, tokenId: token, teacherId: teacherId);
    var response = await ApiBaseHelper.httpPostRequest("GetSubjects",
        body: _request.toJson());
    return SectionSubjectResponse.fromJson(response);
  }
}
