import '../../Model/AddWithdrawalRequest/add_withdrawal_request.dart';
import '../../Network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

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
