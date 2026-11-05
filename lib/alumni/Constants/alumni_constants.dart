class AlumniConstants {
  // TCS Alumni Backend Base URLs
  static const String liveBaseUrl = 'https://tcsalumni.linkalumniapp.com/';
  static const String devBaseUrl = 'https://dev.linkalumniapp.com/';
  static const String baseUrl =devBaseUrl;

  // API Endpoints
  static const String loginEndpoint = 'api/user_login';
  static const String forgotPasswordUrl =
      'https://tcsalumni.linkalumniapp.com/forgot_password';

  // App Store Links
  static const String alumniIOSAppURL =
      'https://apps.apple.com/us/app/a-cityzen-for-life/id1660765260';
  static const String alumniAndroidAppURL =
      'https://play.google.com/store/apps/details?id=com.viion.tcsalumniapp&pli=1';

  // Session & Local Storage Keys
  static const String keyIsAlumniLoggedIn = 'is_alumni_logged_in';
  static const String keyAlumniUserData = 'alumni_user_data';
  static const String keyAlumniToken = 'token';
  static const String keyAlumniUserId = 'user_id';
  static const String keyAlumniLoginStatus = 'loginStatus';
}

