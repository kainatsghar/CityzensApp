class CitizenConstants {
  // The City School Citizen API Base URLs
  static const String apiLiveBaseURL = "https://cityzenapi.csn.edu.pk";
  static const String apiTestBaseURL = "https://testcityzenapi.csn.edu.pk";

  // Active Base URL (change to apiLiveBaseURL for production)
  static String baseUrl = apiTestBaseURL;
  static String apiBaseURL = "$baseUrl/api/";

  // Citizen Fee Payment Gateways
  static const String paymentGatewayURL =
      'https://billing.thecityschool.edu.pk/challan';
  static const String paymentGatewayNewURL =
      'https://billing.thecityschool.edu.pk/directpayment/';

  // Citizen Specific Alert Messages
  static const String markAttendanceMessage = "Please Mark Complete Attendance";
  static const String feedExceptionMessage =
      "Feed Server Not Connected, Please Retry";
}

