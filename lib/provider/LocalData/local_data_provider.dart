import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/provider/Login/login_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';
import 'package:tcs_app/provider/Diary/diary_provider.dart';
import 'package:tcs_app/provider/Assignment/assignment_provider.dart';
import 'package:tcs_app/provider/Circular/circular_provider.dart';
import 'package:tcs_app/provider/MarkUnverified/mark_unverified_provider.dart';
import 'package:tcs_app/provider/Survey/survey_provider.dart';
import 'package:tcs_app/provider/SchoolEvents/school_event_provider.dart';
import 'package:tcs_app/provider/TimeTable/timetable_provider.dart';
import 'package:tcs_app/provider/ComplaintQuery/complaint_query_provider.dart';
import 'package:tcs_app/provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/provider/Appointment/appointment_provider.dart';
import 'package:tcs_app/provider/WithdrawalRequest/withdrawal_request_provider.dart';
import 'package:tcs_app/provider/SupportForm/support_form_provider.dart';
import 'package:tcs_app/provider/Library/library_provider.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/Logout/logout_service.dart';
import 'package:tcs_app/shared_preference/shared_preference.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/Login/login_response.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';

class LocalDataProvider with ChangeNotifier {
  LoginResponse? userData = LoginResponse();

  String studentId = '';
  int? gradeId = 0;

  final Map<String, String> _imagePaths = {};
  Map<String, String> get imagePaths => _imagePaths;

  Future<LoginResponse> loadStoredData() async {
    String? localData = await AppLocalData.getStringPrefValue(
      key: AppConstants.userDataKey,
    );
    if (localData != null) {
      userData = LoginResponse.fromJson(jsonDecode(localData));
      if (userData!.userType == 'Student') {
        setStudentId(userData!.userName!);
        setSGradeId(userData!.info!.gradeId!);
      } else if (userData!.userType == 'Teacher') {
        setSGradeId(userData!.gradeId);
        if (userData!.id == 0) {
          AppLocalData.removeKeyData(key: AppConstants.userDataKey);
          userData = LoginResponse();
          studentId = '';
          gradeId = 0;
          showSnackBar(
            'Please login again. Your data needs to be refreshed.',
            color: AppColors.primaryColor,
          );
        }
      }
      // Preload image path for current user/student to eliminate startup visual flicker
      final key = studentId.isNotEmpty ? studentId : '${userData!.userName}';
      if (key.isNotEmpty) {
        final path = await AppLocalData.getStringPrefValue(key: key);
        if (path != null) {
          _imagePaths[key] = path;
        }
      }
      notifyListeners();
    } else {
      userData = LoginResponse();
      studentId = '';
      gradeId = 0;
    }
    return userData!;
  }

  void setStudentId(String id) {
    studentId = id;
    notifyListeners();
  }

  void setSGradeId(int? gId) {
    gradeId = gId;
    notifyListeners();
  }

  void setUserImage(File file) {
    final key = studentId.isNotEmpty ? studentId : '${userData!.userName}';
    AppLocalData.setStringPrefValue(key: key, value: file.path);
    _imagePaths[key] = file.path;
    notifyListeners();
  }

  Future<void> cacheImagePath(String userId) async {
    if (_imagePaths.containsKey(userId)) return;
    final path = await AppLocalData.getStringPrefValue(key: userId);
    if (path != null) {
      _imagePaths[userId] = path;
      notifyListeners();
    }
  }

  Future<String?> loadImagePath(String userId) async {
    if (_imagePaths.containsKey(userId)) {
      return _imagePaths[userId];
    }
    final path = await AppLocalData.getStringPrefValue(key: userId);
    if (path != null) {
      _imagePaths[userId] = path;
    }
    return path;
  }

  Future logout(BuildContext context) async {
    DialogBuilder.showLoadingIndicator();
    final studentDashboardProvider = Provider.of<StudentDashboardProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    final teacherProfileProvider = Provider.of<TeacherProfileProvider>(context, listen: false);
    final markAttendanceProvider = Provider.of<MarkAttendanceProvider>(context, listen: false);
    final studentProfileProvider = Provider.of<StudentProfileProvider>(context, listen: false);
    final feeChallanProvider = Provider.of<FeeChallanProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final resultsProvider = Provider.of<ResultsProvider>(context, listen: false);
    final studentAttendanceProvider = Provider.of<StudentAttendanceProvider>(context, listen: false);
    final studentALevelAttendanceProvider = Provider.of<StudentALevelAttendanceProvider>(context, listen: false);
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    final assignmentProvider = Provider.of<AssignmentProvider>(context, listen: false);
    final circularProvider = Provider.of<CircularProvider>(context, listen: false);
    final markUnverifiedProvider = Provider.of<MarkUnverifiedProvider>(context, listen: false);
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    final schoolEventProvider = Provider.of<SchoolEventProvider>(context, listen: false);
    final timeTableProvider = Provider.of<TimeTableProvider>(context, listen: false);
    final complaintQueryProvider = Provider.of<ComplaintQueryProvider>(context, listen: false);
    final eyeOnYourChildProvider = Provider.of<EyeOnYourChildProvider>(context, listen: false);
    final classTestResultProvider = Provider.of<ClassTestResultProvider>(context, listen: false);
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    final withdrawalRequestProvider = Provider.of<WithdrawalRequestProvider>(context, listen: false);
    final supportFormProvider = Provider.of<SupportFormProvider>(context, listen: false);
    final libraryProvider = Provider.of<LibraryProvider>(context, listen: false);

    try {
      ResponseMessage response = await LogoutService.logoutRequest(
        userData!.tokenId!,
      );
      if (response.isSuccessful ?? false) {
        if (userData!.userType == 'Teacher') {
          AppLocalData.removeKeyData(key: AppConstants.teacherProfileData);
        }
        AppLocalData.removeKeyData(key: AppConstants.userDataKey);

        // 1. Clear analytics contexts before changing user identity
        await AppAnalyticsService.logLogout();

        // 2. Hide loader and trigger navigation transition immediately.
        // This deactivates the current routes (and their widgets like NavigationalDrawer/TeacherDashboardScreen),
        // preventing them from rebuilding when states are cleared.
        DialogBuilder.hideOpenDialog();
        AppNavigation.pushAndKillAll(AppNavRoutes.authWrapperRoute);

        // 3. Postpone state clearing to the next frame to prevent active listeners from acting on cleared states.
        Future.delayed(Duration.zero, () {
          studentId = '';
          gradeId = 0;
          userData = LoginResponse();

          // Clear other active provider states
          studentDashboardProvider.clearData();
          loginProvider.disposeData();
          dashboardProvider.teacherDataDispose();
          teacherProfileProvider.clearData();
          markAttendanceProvider.clearData();
          studentProfileProvider.clearData();
          feeChallanProvider.clearData();
          notificationProvider.clearData();
          resultsProvider.clearData();
          studentAttendanceProvider.clearData();
          studentALevelAttendanceProvider.clearData();
          diaryProvider.clearData();
          diaryProvider.clearLibraryData();
          assignmentProvider.clearData();
          assignmentProvider.clearLibraryData();
          circularProvider.clearData();
          circularProvider.clearLibraryData();
          markUnverifiedProvider.clearData();
          surveyProvider.clearData();
          schoolEventProvider.clearData();
          schoolEventProvider.clearLibraryData();
          timeTableProvider.clearData();
          complaintQueryProvider.clearData();
          eyeOnYourChildProvider.clearData();
          classTestResultProvider.clearData();
          classTestResultProvider.clearLibraryData();
          appointmentProvider.clearData();
          withdrawalRequestProvider.clearData();
          supportFormProvider.clearData();
          libraryProvider.clearData();

          // Clear all offline caches to prevent data leaking between users
          LocalCacheManager.clearAllCaches();
        });
      } else {
        DialogBuilder.hideOpenDialog();
        showSnackBar(response.message);
      }
    } catch (ex) {
      DialogBuilder.hideOpenDialog();
      showSnackBar('$ex');
    }
  }

  Future<void> openCamera() async {
    AppNavigation.goBack();
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(File(image?.path ?? 'null'));
  }

  Future<void> openGallery() async {
    AppNavigation.goBack();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(File(image?.path ?? 'null'));
  }

  Future cropImage(File image) async {
    if (await File(image.path).exists()) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (croppedFile != null) {
        setUserImage(File(croppedFile.path));
      }
    }
  }
}
