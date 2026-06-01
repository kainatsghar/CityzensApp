class AppNavRoutes {
  static const initialRoute = '/';
  static const loginRoute = '/login';
  static const promotionRoute = '/promotion';
  static const authWrapperRoute = '/authWrapper';
  static const registrationRoute = '/userRegistration';
  static const forgotPinCodeRoute = '/forgotPinCode';
  static const registrationPinCodeRoute = '/registrationPinCode';
  static const createPasswordRoute = '/createPassword';
  static const studentDashboardRoute = '/studentDashboard';
  static const parentDashboardRoute = '/studentDashboard';
  static const studentProfileRoute = '/studentProfile';
  static const resultsRoute = '/results';
  static const academicTermRoute = '/academicTerm';
  static const libraryRoute = '/library';
  static const notificationsRoute = '/notifications';
  static const feeChallansRoute = '/feeChallans';
  static const teacherDashboardRoute = '/teacherDashboard';
  static const teacherProfileRoute = '/teacherProfile';
  static const markAttendanceRoute = '/markAttendance';
  static const attendanceRoute = '/attendance';
  static const alevelAttendanceRoute = '/alevelAttendance';
  static const attendanceSubjectRoute = '/attendanceSubject';
  static const onlineStdRegRoute = '/onlineStdReg';
  static const forgotPasswordRoute = '/forgotPassword';
  static const updatePasswordRoute = '/updatePassword';
  static const aboutUsRoute = '/aboutUs';
  static const appFeedbackRoute = '/appFeedback';
  static const changePasswordRoute = '/changePassword';
  static const teacherSectionRoute = '/teacherSection';
  static const markUnidentifiedRoute = '/markUnidentified';
  static const addDiaryRoute = '/addDiary';
  static const teacherDiaryRoute = '/teacherDiary';
  static const studentDiaryRoute = '/studentDiary';
  static const challanPaymentRoute = '/challanPayment';
  static const introductionRoute = '/introduction';
  static const studentAssignmentRoute = '/studentAssignment';
  static const addAssignmentRoute = '/addAssignment';
  static const teacherAssignmentRoute = '/teacherAssignment';
  static const studentSchoolEventsRoute = '/studentSchoolEvents';
  static const addSchoolEventRoute = '/addStudentSchoolEvent';
  static const teacherSchoolEventsRoute = '/teacherSchoolEvents';
  static const teacherClassTestResultRoute = '/teacherClassTestResult';
  static const teacherAddClassResultRoute = '/teacherAddClassResult';
  static const studentClassTestResultRoute = '/studentClassTestResult';
  static const individualEducationPlanRoute = '/individualEducationPlan';
  static const bookanAppointmentRoute = '/bookanAppointment';
  static const parentAppointmentRoute = '/parentAppointment';
  static const eyeOnYourChildRoute = '/eyeOnYourChild';
  static const parentEyeOnYourChildRoute = '/parentEyeOnYourChild';
  static const teacherTimeTableRoute = '/teacherTimeTable';
  static const teacherTimeTableSectionRoute = '/teacherTimeTableSection';
  static const teacherSurveyRoute = '/teacherSurvey';
  static const studentSurveyRoute = '/studentSurvey';
  static const parentSurveyRoute = '/parentSurvey';
  static const withdrawalRequestRoute = '/withdrawalRequest';
  static const complaintQueryRoute = '/complaintQuery';
  static const addCircularRoute = '/addCircular';
  static const teacherCircularRoute = '/teacherCircular';
  static const teacherAcademicHubRoute = '/teacherAcademicHub';
  static const studentAcademicHubRoute = '/studentAcademicHub';

  /// Returns true if the given route name matches any of the defined routes
  static bool isRouteAvailable(String routeName) {
    if (routeName.isEmpty) return false;

    // Normalize the route name by removing any trailing slashes
    final normalizedRoute = routeName.endsWith('/')
        ? routeName.substring(0, routeName.length - 1)
        : routeName;

    // Set of all route constants (using Set to ensure uniqueness)
    final allRoutes = <String>{
      initialRoute,
      loginRoute,
      promotionRoute,
      authWrapperRoute,
      registrationRoute,
      forgotPinCodeRoute,
      registrationPinCodeRoute,
      createPasswordRoute,
      studentDashboardRoute,
      studentProfileRoute,
      resultsRoute,
      academicTermRoute,
      libraryRoute,
      notificationsRoute,
      feeChallansRoute,
      teacherDashboardRoute,
      teacherProfileRoute,
      markAttendanceRoute,
      attendanceRoute,
      alevelAttendanceRoute,
      attendanceSubjectRoute,
      onlineStdRegRoute,
      forgotPasswordRoute,
      updatePasswordRoute,
      aboutUsRoute,
      appFeedbackRoute,
      changePasswordRoute,
      teacherSectionRoute,
      markUnidentifiedRoute,
      addDiaryRoute,
      teacherDiaryRoute,
      studentDiaryRoute,
      challanPaymentRoute,
      introductionRoute,
      studentAssignmentRoute,
      addAssignmentRoute,
      teacherAssignmentRoute,
      studentSchoolEventsRoute,
      addSchoolEventRoute,
      teacherSchoolEventsRoute,
      teacherClassTestResultRoute,
      teacherAddClassResultRoute,
      studentClassTestResultRoute,
      individualEducationPlanRoute,
      bookanAppointmentRoute,
      parentAppointmentRoute,
      eyeOnYourChildRoute,
      parentEyeOnYourChildRoute,
      teacherTimeTableRoute,
      teacherTimeTableSectionRoute,
      teacherSurveyRoute,
      studentSurveyRoute,
      parentSurveyRoute,
      withdrawalRequestRoute,
      complaintQueryRoute,
      addCircularRoute,
      teacherCircularRoute,
      teacherAcademicHubRoute,
      studentAcademicHubRoute,
    };

    return allRoutes.any((route) => route == normalizedRoute);
  }
}
