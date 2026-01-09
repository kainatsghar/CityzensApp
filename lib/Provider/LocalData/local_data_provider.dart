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
import 'package:tcs_app/Services/Logout/logout_service.dart';
import 'package:tcs_app/SharedPreference/shared_preference.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/model/Login/login_response.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class LocalDataProvider with ChangeNotifier {
  LoginResponse? userData = LoginResponse();

  String studentId = '';
  int? gradeId = 0;

  Future<LoginResponse> loadStoredData({bool teacherForceLogIn = false}) async {
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
        if (userData!.id == 0 && teacherForceLogIn) {
          AppLocalData.removeKeyData(key: AppConstants.userDataKey);
          userData = LoginResponse(userType: 'Teacher');
        }
      }
      notifyListeners();
    } else {
      userData = LoginResponse();
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
    if (studentId.isNotEmpty) {
      AppLocalData.setStringPrefValue(key: studentId, value: file.path);
    } else {
      AppLocalData.setStringPrefValue(
        key: '${userData!.userName}',
        value: file.path,
      );
    }
    notifyListeners();
  }

  Future<String?> loadImagePath(String userId) async =>
      await AppLocalData.getStringPrefValue(key: userId);

  Future logout(BuildContext context) async {
    DialogBuilder.showLoadingIndicator();
    try {
      ResponseMessage response = await LogoutService.logoutRequest(
        userData!.tokenId!,
      );
      if (response.isSuccessful ?? false) {
        AppLocalData.removeKeyData(key: AppConstants.userDataKey);
        Future.delayed(
          Duration.zero,
          () => AppNavigation.pushAndKillAll(AppNavRoutes.authWrapperRoute),
        );
      } else {
        showSnackBar(response.message);
      }
    } catch (ex) {
      showSnackBar('$ex');
    }
    DialogBuilder.hideOpenDialog();
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
