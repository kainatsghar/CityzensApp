import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Results/results_request.dart';

class ResultService {
  static Future<dynamic> resultsRequest(
      {required String userName,
      required String token,
      required int termId,
      required int academicYearId}) async {
    ResultsRequest request = ResultsRequest(
        userName: userName,
        tokenId: token,
        termId: termId,
        academicYearId: academicYearId);
    var response = await ApiBaseHelper.httpPostRequest("PDFResults",
        body: request.toJson());
    return response;
  }
}
