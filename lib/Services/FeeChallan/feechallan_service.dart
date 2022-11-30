import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class FeeChallanService {
  static Future<OutstandingChallanResponse> outStandingChallanRequest(
      {String userName, String token}) async {
    UserDataRequest _request =
        UserDataRequest(userName: userName, tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("OutstandingChallans",
        body: _request.toJson());
    return OutstandingChallanResponse.fromJson(response);
  }

  static Future<ChallanReceiptResponse> challanReceiptRequest(
      {String userName, String token}) async {
    UserDataRequest _request =
        UserDataRequest(userName: userName, tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("ChallansHistory",
        body: _request.toJson());
    return ChallanReceiptResponse.fromJson(response);
  }
}
