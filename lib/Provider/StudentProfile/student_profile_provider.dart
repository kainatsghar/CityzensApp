import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/StudentProfile/student_profile_service.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';

class StudentProfileProvider with ChangeNotifier {
  Map<String, StudentProfileResponse> cachedProfiles = {};

  StudentProfileResponse? get profileResponse {
    String currentStudentId = localDataProvider.studentId ?? '';
    if (cachedProfiles.containsKey(currentStudentId)) {
      return cachedProfiles[currentStudentId];
    }
    
    // Attempt to load from Dashboard provider to avoid redundant fetches
    try {
      final dashboardProvider = Provider.of<StudentDashboardProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );
      final dashboardProfile = dashboardProvider.getChildData(currentStudentId)?.profile;
      if (dashboardProfile != null) {
        cachedProfiles[currentStudentId] = dashboardProfile;
        return dashboardProfile;
      }
    } catch (_) {}
    
    return null;
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setStdProfileData(StudentProfileResponse response) {
    String currentStudentId = localDataProvider.studentId ?? '';

    // Only notify if data has actually changed to prevent unnecessary UI jitters
    if (cachedProfiles.containsKey(currentStudentId)) {
      String oldData = jsonEncode(cachedProfiles[currentStudentId]!.toJson());
      String newData = jsonEncode(response.toJson());
      if (oldData == newData) {
        debugPrint('Student Profile data unchanged, skipping notifyListeners');
        return;
      }
    }
    
    cachedProfiles[currentStudentId] = response;
    notifyListeners();
  }

  Future<StudentProfileResponse> loadStdProfile() async {
    try {
      StudentProfileResponse response =
          await StudentProfileService.stdProfileRequest(
            token: localDataProvider.userData!.tokenId!,
            userName: localDataProvider.studentId,
          );
      setStdProfileData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }
}
