import 'package:flutter/foundation.dart';

class AppConstants {
  static String apiBaseURL = "$baseUrl/api/";
  static String baseUrl = kDebugMode
      ? apiTestBaseURL
      : apiLiveBaseURL; // Use test URL in debug mode, live URL in release

  //We are using this URL for Firebase Remote Config "apiBaseUrl"
  static const String apiLiveBaseURL = "https://app.csn.edu.pk:8090";
  static const String apiTestBaseURL = "https://testcityzenapi.csn.edu.pk";

  static const String appVersion = '1.12.20';
  static const String exceptionMessage =
      "Something Went Wrong, Please Try Again Later";
  static const String markAttendanceMessage = "Please Mark Complete Attendance";
  static const String serverExceptionMessage =
      "Server Not Responding, Please Try Again Later";
  static const String feedExceptionMessage =
      "Feed Server Not Connected, Please Retry";
  static const String badResponseFormat = 'Bad Response Format';
  static const String slowInternetMsg = 'Slow Internet, Please Try Again';

  static const String noInternetMsg =
      'No Internet Connection, Connect Your Internet & Try Again';
  static const String noRecordFound = 'No Record Found';
  static const String imagesPath = 'images/';
  static const String textFontFamily = 'NexaText';
  static const String alumniAppURL =
      "https://play.google.com/store/apps/details?id=com.viion.tcsalumniapp&pli=1";
  static const String paymentGatewayURL =
      'https://billing.thecityschool.edu.pk/challan';

  /// Shared Preferences Keys
  static const String userDataKey = 'userData';

  static const Map<String, String> appHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
}
