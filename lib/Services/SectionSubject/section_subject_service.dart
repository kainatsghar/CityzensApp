import 'package:tcs_app/Model/SectionSubject/section_subject_request.dart';

import '../../Model/SectionSubject/section_subject_response.dart';
import '../../Network/api_base_helper.dart';

class SectionSubjectService {
  static Future<SectionSubjectResponse> getSubjectsRequest({required String classSectionId, required String token, required String teacherId, bool isDiary = false}) async {
    SectionSubjectRequest request = SectionSubjectRequest(id: classSectionId, tokenId: token, teacherId: teacherId, isDiary: isDiary);
    var response = await ApiBaseHelper.httpPostRequest("GetSubjects", body: request.toJson());
    return SectionSubjectResponse.fromJson(response);
  }
}
