import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Model/Results/results_response.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/ChangePassword/change_password_service.dart';
import 'package:tcs_app/Services/Results/result_service.dart';
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
}
