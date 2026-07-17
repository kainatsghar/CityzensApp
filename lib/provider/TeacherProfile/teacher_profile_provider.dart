import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/TeacherProfile/teacher_profile_service.dart';
import 'package:tcs_app/shared_preference/shared_preference.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/TeacherProfile/teacher_profile_response.dart';

class TeacherProfileProvider with ChangeNotifier {
  TeacherProfileResponse? profileResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setTeacherProfileData(TeacherProfileResponse response) {
    profileResponse = response;
    notifyListeners();
  }

  Future<TeacherProfileResponse> loadTeacherProfile() async {
    try {
      TeacherProfileResponse response =
          await TeacherProfileService.teacherProfileRequest(
            userName: localDataProvider.userData!.userName!,
            token: localDataProvider.userData!.tokenId!,
          );
      setTeacherProfileData(response);
      await AppLocalData.setStringPrefValue(
        key: AppConstants.teacherProfileData,
        value: jsonEncode(response),
      );
      return response;
    } catch (ex) {
      String? teacherData = await AppLocalData.getStringPrefValue(
        key: AppConstants.teacherProfileData,
      );

      if (teacherData != null) {
        TeacherProfileResponse response = TeacherProfileResponse.fromJson(
          jsonDecode(teacherData),
        );
        setTeacherProfileData(response);
        return response;
      }
      rethrow;
    }
  }

  void clearData() {
    profileResponse = null;
  }
}
