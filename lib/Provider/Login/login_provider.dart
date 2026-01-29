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

class LoginProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  late List<Options> userTypeList;
  String userNameLabel = 'Roll Number';
  String controllerMask = '00000000';
  TextEditingController passwordController = TextEditingController();
  String userType = 'Student';
  MaskedTextController? userNameController;
  String? validator(String? text) => userType == 'Teacher'
      ? Validators.validator(text)
      : userType == 'Parent'
      ? Validators.validatorForCNICNo(text)
      : Validators.validator(text);

  void showHidePassword() {
    obscureText = !obscureText;
    notifyListeners();
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
