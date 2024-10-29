import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/StudentProfile/student_profile_service.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';

class StudentProfileProvider with ChangeNotifier {
  StudentProfileResponse? profileResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(AppNavigation.currentContext!, listen: false);

  void setStdProfileData(StudentProfileResponse response) {
    profileResponse = response;
    notifyListeners();
  }

  Future<StudentProfileResponse> loadStdProfile() async {
    try {
      StudentProfileResponse response = await StudentProfileService.stdProfileRequest(token: localDataProvider.userData!.tokenId!, userName: localDataProvider.studentId);
      setStdProfileData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }
}
