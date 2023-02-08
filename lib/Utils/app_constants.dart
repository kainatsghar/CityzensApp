class AppConstants {
  static const String apiBaseURL = "http://app.csn.edu.pk:8080/api/";
  static const String exceptionMessage =
      "Something Went Wrong, Please Try Again Later";
  static const String serverExceptionMessage =
      "Server Not Responding, Please Try Again Later";
  static const String feedExceptionMessage =
      "Feed Server Not Connected, Please Retry";
  static const String badResponseFormat = 'Bad Response Format';
  static const String slowInternetMsg = 'Slow Internet, Please Try Again';

  static const String noInternetMsg =
      'No Internet Connection, Connect Your Internet & Try Again';
  static const String noRecordFound = 'No Record Found';
  static const String assetIcons = 'assets/icons/';
  static const String assetImages = 'assets/images/';
  static const String textFont = 'Avenir';
  static const String alumniAppURL = "https://play.google.com/store/apps/details?id=com.viion.tcsalumniapp&pli=1";


  /// Shared Preferences Keys
  static const String userDataKey = 'userData';

  static const Map<String,String> appHeaders = {
  'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json'
  };
}
