import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Library/library_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class LibraryService {
  static Future<LibraryResponse> libraryRequest(
      {String userName, String token}) async {
    UserDataRequest _request =
        UserDataRequest(userName: userName, tokenId: token);
    var response =
        await ApiBaseHelper.httpPostRequest("Library", body: _request.toJson());
    return LibraryResponse.fromJson(response);
  }
}
