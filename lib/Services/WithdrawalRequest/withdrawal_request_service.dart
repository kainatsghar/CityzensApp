import 'package:tcs_app/network/api_base_helper.dart';
import '../../Model/WithdrawalRequest/withdrawal_request.dart';
import '../../Model/WithdrawalRequest/withdrawal_response.dart';

class WithdrawalRequestService {
  static Future<WithdrawalResponse> getWithdrawalReasons({
    required int id,
  }) async {
    WithdrawalRequest request = WithdrawalRequest(id: id);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetWithdrawalReasons",
      body: request.toJson(),
    );
    return WithdrawalResponse.fromJson(response);
  }
}
