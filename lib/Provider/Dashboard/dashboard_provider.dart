import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/model/Results/results_response.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/model/UnverifiedReasons/unverified_reasons_response.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/ChangePassword/change_password_service.dart';
import 'package:tcs_app/services/Results/result_service.dart';
import 'package:tcs_app/services/UnverifiedReasons/unverified_reasons_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/OfflineState/data_state.dart';
import 'package:tcs_app/repositories/TeacherSection/teacher_section_repository.dart';
import 'package:tcs_app/repositories/SectionSubject/section_subject_repository.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';

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

  // ============= Repository Instances =============
  late TeacherSectionRepository _teacherSectionRepository;
  late SectionSubjectRepository _sectionSubjectRepository;

  // ============= Offline-First State Management =============
  // Track data states for both diary true and false sections
  DataState<TeacherSectionResponse> _diaryTrueSectionsState =
      const DataLoading();
  DataState<TeacherSectionResponse> _diaryFalseSectionsState =
      const DataLoading();

  // Map to store subject states: {classSectionId: {isDiary: state}}
  Map<int, Map<bool, DataState<SectionSubjectResponse>>> subjectStatesMap = {};

  // Flag to track if dashboard data has been initialized
  bool _isDashboardDataInitialized = false;

  // Flag to track if dashboard data is currently loading
  bool _isDashboardDataLoading = false;

  // Legacy compatibility: Direct access to cached data
  TeacherSectionResponse? diaryTrueSectionsResponse;
  TeacherSectionResponse? diaryFalseSectionsResponse;
  UnverifiedReasonsResponse? unverifiedReasonsResponse;
  Map<int, Map<bool, List<SectionSubject>?>> sectionSubjectsMap = {};

  // ============= Getters for New States =============
  DataState<TeacherSectionResponse> get diaryTrueSectionsState =>
      _diaryTrueSectionsState;

  DataState<TeacherSectionResponse> get diaryFalseSectionsState =>
      _diaryFalseSectionsState;

  bool get isDashboardDataInitialized => _isDashboardDataInitialized;
  bool get isDashboardDataLoading => _isDashboardDataLoading;

  /// Initialize repositories in constructor
  DashboardProvider() {
    _teacherSectionRepository = TeacherSectionRepository();
    _sectionSubjectRepository = SectionSubjectRepository();
  }

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

  /// ============= OFFLINE-FIRST: New initialization method =============
  /// Fetch all sections and subjects data for dashboard initialization
  /// Uses offline-first strategy: local cache first, background sync
  /// Fetches both isDiary=true and isDiary=false sections and their subjects
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

      // Load all data in parallel using offline-first approach
      await Future.wait([
        teacherProfileProvider.loadTeacherProfile(),
        _loadSectionsWithDiaryOfflineFirst(
          userName: userName,
          token: token,
          isDiary: true,
        ),
        _loadSectionsWithDiaryOfflineFirst(
          userName: userName,
          token: token,
          isDiary: false,
        ),
        loadUnverifiedReasons(token: token),
      ]);

      // Fetch subjects for all sections using offline-first
      await _loadSubjectsForAllSectionsOfflineFirst(
        userName: userName,
        token: token,
      );

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

  /// Load sections for a specific isDiary value (offline-first)
  Future<void> _loadSectionsWithDiaryOfflineFirst({
    required String userName,
    required String token,
    required bool isDiary,
  }) async {
    try {
      await _teacherSectionRepository.getSectionsOfflineFirst(
        userName: userName,
        token: token,
        isDiary: isDiary,
        onStateChange: (state) {
          if (isDiary) {
            _diaryTrueSectionsState = state;
            // Keep legacy data in sync for compatibility
            if (state.data != null) {
              diaryTrueSectionsResponse = state.data;
            }
          } else {
            _diaryFalseSectionsState = state;
            if (state.data != null) {
              diaryFalseSectionsResponse = state.data;
            }
          }
          notifyListeners();
        },
      );
    } catch (ex) {
      rethrow;
    }
  }

  /// Load subjects for all sections using offline-first
  Future<void> _loadSubjectsForAllSectionsOfflineFirst({
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

        // Initialize the maps for this section if not exists
        sectionSubjectsMap.putIfAbsent(classSectionId, () => {});
        subjectStatesMap.putIfAbsent(classSectionId, () => {});

        // Fetch subjects for isDiary = true
        subjectFutures.add(
          _fetchAndStoreSubjectsOfflineFirst(
            classSectionId: classSectionId,
            isDiary: true,
            userName: userName,
            token: token,
          ),
        );

        // Fetch subjects for isDiary = false
        subjectFutures.add(
          _fetchAndStoreSubjectsOfflineFirst(
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

  /// Helper method to fetch and store subjects using offline-first
  Future<void> _fetchAndStoreSubjectsOfflineFirst({
    required int classSectionId,
    required bool isDiary,
    required String userName,
    required String token,
  }) async {
    try {
      await _sectionSubjectRepository.getSubjectsOfflineFirst(
        classSectionId: classSectionId,
        token: token,
        teacherId: userName,
        isDiary: isDiary,
        onStateChange: (state) {
          subjectStatesMap[classSectionId]![isDiary] = state;

          // Keep legacy data in sync
          if (state.data != null) {
            sectionSubjectsMap[classSectionId]![isDiary] =
                state.data!.sectionSubject;
          } else {
            sectionSubjectsMap[classSectionId]![isDiary] = [];
          }

          notifyListeners();
        },
      );
    } catch (ex) {
      // Store empty list on error
      sectionSubjectsMap[classSectionId]![isDiary] = [];
    }
  }

  /// Force refresh dashboard data (for pull-to-refresh)
  Future<void> refreshDashboardData() async {
    final userName = localProvider.userData!.userName!;
    final token = localProvider.userData!.tokenId!;

    try {
      await Future.wait([
        _refreshSectionsWithDiary(
          userName: userName,
          token: token,
          isDiary: true,
        ),
        _refreshSectionsWithDiary(
          userName: userName,
          token: token,
          isDiary: false,
        ),
        loadUnverifiedReasons(token: token),
      ]);

      await _loadSubjectsForAllSectionsOfflineFirst(
        userName: userName,
        token: token,
      );
    } catch (ex) {
      showSnackBar('Failed to refresh data: $ex');
      rethrow;
    }
  }

  /// Force refresh sections for a specific isDiary value
  Future<void> _refreshSectionsWithDiary({
    required String userName,
    required String token,
    required bool isDiary,
  }) async {
    try {
      await _teacherSectionRepository.forceRefresh(
        userName: userName,
        token: token,
        isDiary: isDiary,
        onStateChange: (state) {
          if (isDiary) {
            _diaryTrueSectionsState = state;
            if (state.data != null) {
              diaryTrueSectionsResponse = state.data;
            }
          } else {
            _diaryFalseSectionsState = state;
            if (state.data != null) {
              diaryFalseSectionsResponse = state.data;
            }
          }
          notifyListeners();
        },
      );
    } catch (ex) {
      rethrow;
    }
  }

  /// Get subject state for a specific section
  DataState<SectionSubjectResponse>? getSubjectsState({
    required int classSectionId,
    required bool isDiary,
  }) {
    return subjectStatesMap[classSectionId]?[isDiary];
  }

  /// Get formatted last sync time for display
  String getLastSyncDisplayText(DateTime? lastSyncedAt) {
    return LocalCacheManager.getTimeSinceLastSync(lastSyncedAt);
  }

  /// Load unverified reasons for teacher
  Future<void> loadUnverifiedReasons({required String token}) async {
    try {
      UnverifiedReasonsResponse response =
          await UnverifiedReasonsService.getReasons(tokenId: token);
      unverifiedReasonsResponse = response;
      notifyListeners();
    } catch (ex) {
      unverifiedReasonsResponse = UnverifiedReasonsResponse();
      rethrow;
    }
  }

  ///Get unverified reasons list
  List<VerificationReason>? getUnverifiedReasons() {
    return unverifiedReasonsResponse?.verificationReasons;
  }

  /// Get all sections with isDiary = true (backward compatible)
  List<Section>? getSectionsWithDiary(bool isDiary) {
    if (isDiary) {
      return diaryTrueSectionsResponse?.section;
    } else {
      return diaryFalseSectionsResponse?.section;
    }
  }

  /// Get cached subjects for a specific section and isDiary value (backward compatible)
  List<SectionSubject>? getSubjectsForSection({
    required int classSectionId,
    required bool isDiary,
  }) {
    return sectionSubjectsMap[classSectionId]?[isDiary];
  }

  void teacherDataDispose() {
    diaryTrueSectionsResponse = null;
    diaryFalseSectionsResponse = null;
    unverifiedReasonsResponse = null;
    sectionSubjectsMap.clear();
    subjectStatesMap.clear();
    _isDashboardDataInitialized = false;
    _isDashboardDataLoading = false;
  }
}
