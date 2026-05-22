import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/Logout/logout_service.dart';
import 'package:tcs_app/shared_preference/shared_preference.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/Login/login_response.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

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
          showSnackBar(
            'Please login again. Your data needs to be refreshed.',
            color: AppColors.primary,
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
    try {
      ResponseMessage response = await LogoutService.logoutRequest(
        userData!.tokenId!,
      );
      if (response.isSuccessful ?? false) {
        if (userData!.userType == 'Teacher') {
          AppLocalData.removeKeyData(key: AppConstants.teacherProfileData);
        }
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
