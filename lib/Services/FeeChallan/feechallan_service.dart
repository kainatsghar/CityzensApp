import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class FeeChallanService {
  static Future<OutstandingChallanResponse> outStandingChallanRequest({
    required String userName,
    required String token,
  }) async {
    UserDataRequest request = UserDataRequest(
      userName: userName,
      tokenId: token,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "OutstandingChallans",
      body: request.toJson(),
    );
    return OutstandingChallanResponse.fromJson(response);
  }

  static Future<ChallanReceiptResponse> challanReceiptRequest({
    required String userName,
    required String? token,
  }) async {
    // {required String userName,required String token}) async {
    UserDataRequest request = UserDataRequest(
      userName: userName,
      tokenId: token!,
    );
    // UserDataRequest(userName: userName, tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest(
      "ChallansHistory",
      body: request.toJson(),
    );
    return ChallanReceiptResponse.fromJson(response);
  }
}
