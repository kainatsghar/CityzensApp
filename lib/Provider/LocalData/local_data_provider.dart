import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/Services/Logout/logout_service.dart';
import 'package:tcs_app/SharedPreference/shared_preference.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/model/Login/login_response.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

import '../../Screens/Parent/ParentDashboardScreen/parent_dashboard_screen.dart';
import '../../Screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import '../../Screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';

class LocalDataProvider with ChangeNotifier {
  LoginResponse userData = LoginResponse();

  String studentId = '';

  Future<void> loadStoredData() async {
    String localData =
        await AppLocalData.getStringPrefValue(key: AppConstants.userDataKey);
    if (localData != null) {
      userData = LoginResponse.fromJson(jsonDecode(localData));
      if (userData.userType == 'Student') {
        setStudentId(userData.userName);
      }
      notifyListeners();
    } else {
      userData = LoginResponse();
    }
  }

  void setStudentId(String id) {
    studentId = id;
    notifyListeners();
  }

  Future<Widget> authDecider() async {
    await loadStoredData();
    if (userData.tokenId == null) {
      return LoginScreen();
    } else {
      if (userData.userType == 'Student') {
        return StudentDashboardScreen();
      } else if (userData.userType == 'Teacher') {
        return TeacherDashboardScreen();
      } else {
        return ParentDashboardScreen();
      }
    }
  }

  void setUserImage(File file) {
    if (studentId.isNotEmpty) {
      AppLocalData.setStringPrefValue(key: '$studentId', value: file.path);
    } else {
      AppLocalData.setStringPrefValue(
          key: '${userData.userName}', value: file.path);
    }
    notifyListeners();
  }

  Future<String> loadImagePath(String userId) async =>
      await AppLocalData.getStringPrefValue(key: userId);

  Future logout(BuildContext context) async {
    DialogBuilder.showLoadingIndicator();
    try {
      ResponseMessage response =
          await LogoutService.logoutRequest(userData.tokenId);
      if (response.isSuccessful) {
        AppLocalData.removeKeyData(key: AppConstants.userDataKey);
        Future.delayed(Duration.zero,
            () => AppNavigation.pushAndKillAll(AppNavRoutes.authWrapperRoute));
      } else {
        showSnackBar(response.message);
      }
    } catch (ex) {
      showSnackBar('$ex');
    }
    DialogBuilder.hideOpenDialog();
  }

  openCamera() async {
    AppNavigation.goBack();
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(File(image.path));
  }

  openGallery() async {
    AppNavigation.goBack();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(File(image.path));
  }

  Future cropImage(File image) async {
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
