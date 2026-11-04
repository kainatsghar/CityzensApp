import 'package:tcs_app/citizen/Model/AddWithdrawalRequest/add_withdrawal_request.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';

class AddWithdrawalRequestService {
  static Future<ResponseMessage> addWithdrawalRequest(
      AddWithdrawalRequest addWithdrawalRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveWithdrawalRequest",
      body: addWithdrawalRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}
