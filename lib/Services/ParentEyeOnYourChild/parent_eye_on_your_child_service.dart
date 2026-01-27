import '../../Model/ParentEyeOnYourChild/parent_eye_on_your_child_request.dart';
import '../../Model/ParentEyeOnYourChild/parent_eye_on_your_child_response.dart';
import '../../network/api_base_helper.dart';

class ParentEyeOnYourChildService {
  static Future<ParentEyeOnYourChildResponse> getStudentUpdatesForParent({
    required int userName,
    required String tokenId,
  }) async {
    ParentEyeOnYourChildRequest request = ParentEyeOnYourChildRequest(
      studentId: userName,
      tokenId: tokenId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetStudentUpdatesForParent",
      body: request.toJson(),
    );
    return ParentEyeOnYourChildResponse.fromJson(response);
  }
}
