import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/Results/results_request.dart';
import 'package:tcs_app/model/Results/all_pdf_results_request.dart';

class ResultService {
  static Future<dynamic> resultsRequest({
    required String userName,
    required String token,
    required int termId,
    required int academicYearId,
  }) async {
    ResultsRequest request = ResultsRequest(
      userName: userName,
      tokenId: token,
      termId: termId,
      academicYearId: academicYearId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "PDFResults",
      body: request.toJson(),
    );
    return response;
  }

  static Future<dynamic> allPDFResultsRequest({
    required String studentId,
    required String token,
  }) async {
    AllPDFResultsRequest request = AllPDFResultsRequest(
      studentId: studentId,
      tokenId: token,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "AllPDFResults",
      body: request.toJson(),
    );
    return response;
  }
}

