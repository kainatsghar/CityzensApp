import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Results/results_request.dart';

class ResultService {
  static Future<dynamic> resultsRequest(
      {String userName, String token, int termId, int academicYearId}) async {
    ResultsRequest _request = ResultsRequest(
        userName: userName,
        tokenId: token,
        termId: termId,
        academicYearId: academicYearId);
    var response =
        await ApiBaseHelper.httpPostRequest("Results", body: _request.toJson());
    return response;
  }
}
