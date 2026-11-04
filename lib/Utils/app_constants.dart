import 'package:tcs_app/citizen/Utils/citizen_constants.dart';

class AppConstants {
  // Common Application Info
  static const String appVersion = '1.13.2';
  static const String textFontFamily = 'NexaText';
  static const String appSupportEmail = 'appsupport@csn.edu.pk';
  static const String userDataKey = 'userData';

  // Common Header Configuration
  static const Map<String, String> appHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Common Network & Exception Messages
  static const String exceptionMessage =
      "Something Went Wrong, Please Try Again Later";
  static const String serverExceptionMessage =
      "Server Not Responding, Please Try Again Later";
  static const String badResponseFormat = 'Bad Response Format';
  static const String slowInternetMsg = 'Slow Internet, Please Try Again';
  static const String noInternetMsg =
      'No Internet Connection, Connect Your Internet & Try Again';
  static const String noRecordFound = 'No Record Found';

  // Forwarding Citizen constants for backward compatibility
  static String get apiBaseURL => CitizenConstants.apiBaseURL;
  static set apiBaseURL(String v) => CitizenConstants.apiBaseURL = v;
  static String get baseUrl => CitizenConstants.baseUrl;
  static set baseUrl(String v) => CitizenConstants.baseUrl = v;
  static String get apiLiveBaseURL => CitizenConstants.apiLiveBaseURL;
  static String get apiTestBaseURL => CitizenConstants.apiTestBaseURL;

  static const String markAttendanceMessage =
      CitizenConstants.markAttendanceMessage;
  static const String feedExceptionMessage =
      CitizenConstants.feedExceptionMessage;
  static const String paymentGatewayURL = CitizenConstants.paymentGatewayURL;
  static const String paymentGatewayNewURL =
      CitizenConstants.paymentGatewayNewURL;
}
