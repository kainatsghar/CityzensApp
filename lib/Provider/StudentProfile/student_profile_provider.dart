import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/StudentProfile/student_profile_service.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';

class StudentProfileProvider with ChangeNotifier {
  StudentProfileResponse? profileResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setStdProfileData(StudentProfileResponse response) {
    // Only notify if data has actually changed to prevent unnecessary UI jitters
    if (profileResponse != null) {
      String oldData = jsonEncode(profileResponse!.toJson());
      String newData = jsonEncode(response.toJson());
      if (oldData == newData) {
        debugPrint('Student Profile data unchanged, skipping notifyListeners');
        return;
      }
    }
    
    profileResponse = response;
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
