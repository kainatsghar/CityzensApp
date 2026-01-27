import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Model/Results/results_response.dart';
import 'package:tcs_app/Model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/ChangePassword/change_password_service.dart';
import 'package:tcs_app/Services/Results/result_service.dart';
import 'package:tcs_app/Services/SectionSubject/section_subject_service.dart';
import 'package:tcs_app/Services/TeacherSection/teacher_section_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class DashboardProvider with ChangeNotifier {
  final changePasswordFormKey = GlobalKey<FormState>();

  var localProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );
  ResultsResponse resultsResponse = ResultsResponse();
  bool obscureText = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmPassword = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  String projectVersion = '';

  // Dashboard cached data
  TeacherSectionResponse? diaryTrueSectionsResponse;
  TeacherSectionResponse? diaryFalseSectionsResponse;

  // Map to store subjects for each section: {classSectionId: {isDiary: subjects}}
  Map<int, Map<bool, List<SectionSubject>?>> sectionSubjectsMap = {};

  // Flag to track if dashboard data has been initialized
  bool _isDashboardDataInitialized = false;

  // Flag to track if dashboard data is currently loading
  bool _isDashboardDataLoading = false;

  bool get isDashboardDataInitialized => _isDashboardDataInitialized;

  bool get isDashboardDataLoading => _isDashboardDataLoading;

  void showHidePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void showHideNewPassword() {
    obscureTextNewPassword = !obscureTextNewPassword;
    notifyListeners();
  }

  void showHideConfirmPassword() {
    obscureTextConfirmPassword = !obscureTextConfirmPassword;
    notifyListeners();
  }

  // Validator
  String? validator(String? value) {
    if (value == null || value.isEmpty) return "Required*";
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long";
    } else {
      return null;
    }
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value != newPassController.text) {
      return "Password doesn't match";
    } else {
      return null;
    }
  }

  Future<void> changePassword() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (changePasswordFormKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await ChangePasswordService.changePasswordRequest(
              userName: userNameController.text,
              oldPassword: oldPassController.text,
              userType: userTypeController.text,
            );
        if (responseMessage.isSuccessful ?? false) {
          // if (responseMessage.isSuccessful) {
          Future.delayed(Duration.zero, () => AppNavigation.goBack());
          showSnackBar(
            'Password for ${userNameController.text} has been changed successfully',
            color: AppColors.successGreenColor,
          );
          disposeData();
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (ex) {
      showSnackBar(ex.toString());
    }
    DialogBuilder.hideOpenDialog();
  }

  void initializeData() {
    var localProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    userTypeController.text = localProvider.userData!.userType!;
    userNameController.text = localProvider.userData!.userType == 'Student'
        ? localProvider.studentId
        : '${localProvider.userData!.userName}';
  }

  Future<dynamic> loadResults({
    required int academicYearId,
    required int termId,
  }) async {
    try {
      resultsResponse = ResultsResponse();

      var response = await ResultService.resultsRequest(
        userName: localProvider.studentId,
        token: localProvider.userData!.tokenId!,
        academicYearId: academicYearId,
        termId: termId,
      );
      setResultsResponse(ResultsResponse.fromJson(response));
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setResultsResponse(ResultsResponse response) {
    resultsResponse = response;
    notifyListeners();
  }

  Future<void> loadVersionName() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      projectVersion = packageInfo.version;
      notifyListeners();
    } catch (exception) {
      throw exception.toString();
    }
  }

  void disposeData() {
    userNameController.clear();
    oldPassController.clear();
    newPassController.clear();
    confirmPassController.clear();
    obscureText = true;
    obscureTextNewPassword = true;
    obscureTextConfirmPassword = true;
  }

  var teacherProfileProvider = Provider.of<TeacherProfileProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  /// Fetch all sections and subjects data for dashboard initialization
  /// Fetches both isDiary=true and isDiary=false sections and their respective subjects
  /// Only fetches once - subsequent calls use cached data
  Future<void> initializeDashboardDataForTeacher() async {
    // Skip if data is already initialized
    if (_isDashboardDataInitialized) {
      debugPrint('Dashboard data already cached, skipping fetch');
      return;
    }

    try {
      // Set loading state to true
      _isDashboardDataLoading = true;
      notifyListeners();

      final userName = localProvider.userData!.userName!;
      final token = localProvider.userData!.tokenId!;

      await Future.wait([
        teacherProfileProvider.loadTeacherProfile(),
        loadSectionsWithDiary(userName: userName, token: token, isDiary: true),
        loadSectionsWithDiary(userName: userName, token: token, isDiary: false),
      ]);

      // // Load teacher profile
      // await teacherProfileProvider.loadTeacherProfile();

      // // Fetch sections for isDiary = true
      // await loadSectionsWithDiary(
      //   userName: userName,
      //   token: token,
      //   isDiary: true,
      // );

      // // Fetch sections for isDiary = false
      // await loadSectionsWithDiary(
      //   userName: userName,
      //   token: token,
      //   isDiary: false,
      // );

      // Fetch subjects for all sections
      await loadSubjectsForAllSections(userName: userName, token: token);

      // Mark data as initialized
      _isDashboardDataInitialized = true;
      _isDashboardDataLoading = false;
      notifyListeners();
    } catch (ex) {
      _isDashboardDataLoading = false;
      notifyListeners();
      showSnackBar('Failed to load dashboard data: $ex');
      rethrow;
    }
  }

  /// Load sections for a specific isDiary value
  Future<void> loadSectionsWithDiary({
    required String userName,
    required String token,
    required bool isDiary,
  }) async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
            userName: userName,
            token: token,
            isDiary: isDiary,
          );

      if (isDiary) {
        diaryTrueSectionsResponse = response;
      } else {
        diaryFalseSectionsResponse = response;
      }

      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }

  /// Load subjects for all sections in both isDiary states
  /// Fetches subjects in parallel for all sections to improve performance
  Future<void> loadSubjectsForAllSections({
    required String userName,
    required String token,
  }) async {
    try {
      // Get all sections from both responses
      final allSections = <Section>[];

      if (diaryTrueSectionsResponse?.section != null) {
        allSections.addAll(diaryTrueSectionsResponse!.section!);
      }
      if (diaryFalseSectionsResponse?.section != null) {
        allSections.addAll(diaryFalseSectionsResponse!.section!);
      }

      // Remove duplicates based on classSectionId
      final uniqueSections = <int, Section>{};
      for (final section in allSections) {
        uniqueSections[section.classSectionId!] = section;
      }

      // Create list of futures for all subject requests (parallel execution)
      final subjectFutures = <Future<void>>[];

      for (final section in uniqueSections.values) {
        final classSectionId = section.classSectionId!;

        // Initialize the map for this section if not exists
        sectionSubjectsMap.putIfAbsent(classSectionId, () => {});

        // Fetch subjects for isDiary = true
        subjectFutures.add(
          _fetchAndStoreSubjects(
            classSectionId: classSectionId,
            isDiary: true,
            userName: userName,
            token: token,
          ),
        );

        // Fetch subjects for isDiary = false
        subjectFutures.add(
          _fetchAndStoreSubjects(
            classSectionId: classSectionId,
            isDiary: false,
            userName: userName,
            token: token,
          ),
        );
      }

      // Execute all requests in parallel
      await Future.wait(subjectFutures);

      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }

  /// Helper method to fetch and store subjects for a specific section
  Future<void> _fetchAndStoreSubjects({
    required int classSectionId,
    required bool isDiary,
    required String userName,
    required String token,
  }) async {
    try {
      SectionSubjectResponse response =
          await SectionSubjectService.getSubjectsRequest(
            classSectionId: classSectionId.toString(),
            token: token,
            teacherId: userName,
            isDiary: isDiary,
          );
      sectionSubjectsMap[classSectionId]![isDiary] = response.sectionSubject;
    } catch (ex) {
      // Store empty list on error
      sectionSubjectsMap[classSectionId]![isDiary] = [];
    }
  }

  /// Get cached subjects for a specific section and isDiary value
  List<SectionSubject>? getSubjectsForSection({
    required int classSectionId,
    required bool isDiary,
  }) {
    return sectionSubjectsMap[classSectionId]?[isDiary];
  }

  /// Get all sections with isDiary = true
  List<Section>? getSectionsWithDiary(bool isDiary) {
    if (isDiary) {
      return diaryTrueSectionsResponse?.section;
    } else {
      return diaryFalseSectionsResponse?.section;
    }
  }

  void teacherDataDispose() {
    diaryTrueSectionsResponse = null;
    diaryFalseSectionsResponse = null;
    sectionSubjectsMap.clear();
    _isDashboardDataInitialized = false;
    _isDashboardDataLoading = false;
  }
}
