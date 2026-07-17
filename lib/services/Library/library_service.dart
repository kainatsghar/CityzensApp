import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/Library/library_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class LibraryService {
  static Future<LibraryResponse> libraryRequest({
    required String userName,
    required String token,
  }) async {
    UserDataRequest request = UserDataRequest(
      userName: userName,
      tokenId: token,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "Library",
      body: request.toJson(),
    );
    return LibraryResponse.fromJson(response);
  }
}
