import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/Login/login_service.dart';
import 'package:tcs_app/shared_preference/shared_preference.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/validators.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/Login/login_response.dart';
import 'package:tcs_app/services/LocalAuth/local_auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  late List<Options> userTypeList;
  String userNameLabel = 'Roll Number';
  String controllerMask = '00000000';
  TextEditingController passwordController = TextEditingController();
  String userType = 'Student';
  MaskedTextController? userNameController;
  bool rememberMe = true;
  List<SavedAccount> savedAccounts = [];
  String? validator(String? text) => userType == 'Teacher'
      ? Validators.validator(text)
      : userType == 'Parent'
      ? Validators.validatorForCNICNo(text)
      : Validators.validator(text);

  void showHidePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  Future<void> loadSavedAccounts() async {
    savedAccounts = await LocalAuthService.getSavedAccounts();
    notifyListeners();
  }

  Future<void> removeSavedAccount(SavedAccount account) async {
    await LocalAuthService.removeAccount(account.username, account.userType);
    await loadSavedAccounts();
  }

  Future<void> loginWithSavedAccount(SavedAccount account) async {
    bool authenticated = await LocalAuthService.authenticate();
    if (authenticated) {
      userType = account.userType;
      changeUserNameInputField(account.userType);
      notifyListeners();
      // Allow the widget tree to rebuild and bind the new controller before setting text values
      await Future.delayed(const Duration(milliseconds: 100));
      userNameController?.text = account.username;
      passwordController.text = account.password;
      notifyListeners();
      // Wait another small frame duration to let FormFieldState update its internal value from the controller
      await Future.delayed(const Duration(milliseconds: 50));
      await login();
    }
  }

  Future<void> login() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState?.validate() ?? false) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        LoginResponse loginResponse = await LoginService.loginRequest(
          userNameController?.text ?? '',
          passwordController.text,
          userType,
        );
        DialogBuilder.hideOpenDialog();
        if (loginResponse.isSuccessful ?? false) {
          loginResponse.userType = userType;
          loginResponse.userName = userNameController?.text ?? '';
          await AppLocalData.setStringPrefValue(
            key: AppConstants.userDataKey,
            value: jsonEncode(loginResponse),
          );

          if (rememberMe) {
            await LocalAuthService.saveAccount(
              loginResponse.userName!,
              passwordController.text,
              userType,
            );
          }

          Future.delayed(
            Duration.zero,
            () =>
                AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute),
          );
        } else {
          if (loginResponse.isException ?? false) {
            showSnackBar(
              'Server Error: Something went wrong. Please try again later.',
            );
          } else {
            showSnackBar(loginResponse.message);
          }
        }
      } else {
        DialogBuilder.hideOpenDialog();
      }
    } catch (ex) {
      DialogBuilder.hideOpenDialog();
      showSnackBar('$ex');
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void initializeData() {
    userNameController = MaskedTextController(mask: controllerMask);
    userTypeList = HelperFunction.userTypes();
    loadSavedAccounts();
  }

  void onUserTypeSelection(String v) {
    userType = v;
    changeUserNameInputField(v);
    notifyListeners();
    AppNavigation.goBack();
  }

  void changeUserNameInputField(String v) {
    controllerMask = v == 'Teacher'
        ? '00000000'
        : v == 'Parent'
        ? '00000-0000000-0'
        : '00000000';
    userNameController = MaskedTextController(mask: controllerMask);
    userNameLabel = v == 'Teacher'
        ? 'Employee Number'
        : v == 'Parent'
        ? 'Father CNIC Number'
        : 'Roll Number';
  }

  // void userTypeBottomSheet() {
  //   showModalBottomSheet(
  //     context: AppNavigation.currentContext!,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext bc) => CustomFilterBottomSheet(
  //       controller: userTypeController,
  //       filterOptions: userTypeList,
  //       onSelect: (v) => onUserTypeSelection(v),
  //     ),
  //   );
  // }

  void selectUserTypeInline(int index) {
    userType = userTypeList[index].title!;
    changeUserNameInputField(userTypeList[index].title!);
    notifyListeners();
  }

  void disposeData() {
    userNameController?.clear();
    passwordController.clear();
    obscureText = true;
    userType = 'Student';
    changeUserNameInputField(userType);
  }
}
