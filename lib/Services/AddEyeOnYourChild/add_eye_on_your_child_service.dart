import '../../Model/AddEyeOnYourChild/add_eye_on_your_child_request.dart';
import '../../Model/AddEyeOnYourChild/add_eye_on_your_child_response.dart';
import '../../network/api_base_helper.dart';

class AddEyeOnYourChildService {
  static Future<AddEyeOnYourChildResponse> saveStudentUpdatesForParent({
    required int studentId,
    required int updateId,
    required String? tokenId,
    required int? createdBy,
    required int? modifiedBy,
    required String fileName1,
    required String fileName2,
    required String fileName3,
    required String fileBaseString1,
    required String fileBaseString2,
    required String fileBaseString3,
  }) async {
    AddEyeOnYourChildRequest request = AddEyeOnYourChildRequest(
      studentId: studentId,
      updateId: updateId,
      tokenId: tokenId,
      createdBy: createdBy,
      modifiedBy: modifiedBy,
      fileName1: fileName1,
      fileName2: fileName2,
      fileName3: fileName3,
      fileBaseString1: fileBaseString1,
      fileBaseString2: fileBaseString2,
      fileBaseString3: fileBaseString3,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveStudentUpdatesForParent",
      body: request.toJson(),
    );
    return AddEyeOnYourChildResponse.fromJson(response);
  }
}
