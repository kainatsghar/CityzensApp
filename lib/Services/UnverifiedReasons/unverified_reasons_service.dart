// import 'package:flutter/cupertino.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

import '../../model/UnverifiedReasons/unverified_reasons_response.dart';
import '../../network/api_base_helper.dart';

class UnverifiedReasonsService {
  static Future<UnverifiedReasonsResponse> getReasons({
    required String tokenId,
  }) async {
    UserDataRequest request = UserDataRequest(tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetStudentVerificationReason",
      body: request.toJson(),
    );
    // ignore: avoid_print
    //print(response);
    return UnverifiedReasonsResponse.fromJson(response);
  }
}
