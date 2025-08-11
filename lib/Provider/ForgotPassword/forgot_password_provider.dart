// import 'dart:js';

import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/success_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/ForgotPassword/forgot_password_service.dart';
import 'package:tcs_app/Services/UpdatePassword/update_password_service.dart';
import 'package:tcs_app/Services/VerifyPinCode/verify_pincode_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/validators.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final forgotFormKey = GlobalKey<FormState>();
  final pinCodeFormKey = GlobalKey<FormState>();
  final updatePasswordFormKey = GlobalKey<FormState>();

  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;
  List<Options> userTypeList = [];
  String userNameLabel = 'Roll Number', userNameHint = 'xxxxxxxx';
  String controllerMask = '00000000';
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController userTypeController = TextEditingController(
    text: 'Student',
  );
  MaskedTextController? userNameController;

  ResponseMessage? forgotResponse = ResponseMessage();

  LoginProvider loginProvider = Provider.of<LoginProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  String? validator(String? text) => userTypeController.text == 'Parent'
      ? Validators.validatorForCNICNo(text)
      : Validators.validator(text);

  void setResponseData(ResponseMessage responseMessage) {
    forgotResponse = responseMessage;
    notifyListeners();
  }

  void showHidePassword() {
    obscureTextPassword = !obscureTextPassword;
    notifyListeners();
  }

  void showHideConfirmPassword() {
    obscureTextConfirmPassword = !obscureTextConfirmPassword;
    notifyListeners();
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value != passwordController.text) {
      return "Password doesn't match";
    } else {
      return null;
    }
  }

  Future<void> forgotPassword() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (forgotFormKey.currentState?.validate() ?? false) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        // ResponseMessage responseMessage =
        ResponseMessage? responseMessage =
            await ForgotPasswordService.forgotPasswordRequest(
              userName: userNameController?.text ?? '',
              mobileNumber: phoneNumberController.text,
              userType: userTypeController.text,
            );
        // if (responseMessage.isSuccessful ) {
        if (responseMessage.isSuccessful!) {
          setResponseData(responseMessage);
          Future.delayed(
            const Duration(milliseconds: 1),
            () => AppNavigation.navigateTo(AppNavRoutes.forgotPinCodeRoute),
          );
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (exception) {
      showSnackBar(exception);
    }
    DialogBuilder.hideOpenDialog();
  }

  Future<void> verifyPinCode() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (pinCodeFormKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await VerifyPinCodeService.verifyPinCodeRequest(
              userName: userNameController?.text ?? '',
              pinCode: pinCodeController.text,
              userType: userTypeController.text,
            );
        // if (responseMessage.isSuccessful) {
        if (responseMessage.isSuccessful ?? false) {
          confirmPasswordController.clear();
          passwordController.clear();
          Future.delayed(
            const Duration(milliseconds: 1),
            () => AppNavigation.navigateTo(AppNavRoutes.updatePasswordRoute),
          );
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (exception) {
      showSnackBar(exception);
    }
    DialogBuilder.hideOpenDialog();
  }

  Future<void> updatePassword() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (updatePasswordFormKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        // ResponseMessage responseMessage =
        ResponseMessage? responseMessage =
            await UpdatePasswordService.updatePasswordRequest(
              userName: userNameController?.text ?? '',
              confirmPassword: confirmPasswordController.text,
              userType: userTypeController.text,
            );
        // if (responseMessage.isSuccessful) {
        if (responseMessage.isSuccessful ?? false) {
          Future.delayed(
            const Duration(milliseconds: 1),
            () => AppNavigation.removeAllRoutes(),
          );
          showSnackBar(
            'Password for ${userNameController?.text} has been updated successfully',
            color: AppColors.successGreenColor,
          );
          disposeData();
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (exception) {
      showSnackBar(exception);
    }
    DialogBuilder.hideOpenDialog();
  }

  void initializeData() {
    userTypeController = TextEditingController(text: 'Student');
    userNameController = MaskedTextController(mask: controllerMask);
    userTypeList = HelperFunction.userTypes().take(2).toList();
    onUserTypeSelection(
      userTypeList.any(
            (element) => element.title == loginProvider.userTypeController.text,
          )
          ? loginProvider.userTypeController.text
          : userTypeList.first.title!,
      isInitialization: true,
    );
  }

  void initializePinCodeData() {
    pinCodeController.clear();
    // if (forgotResponse.isSuccessful != null && forgotResponse.isSuccessful) {
    // if (forgotResponse.isSuccessful) {
    if (forgotResponse?.isSuccessful ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showDialog(
          context: AppNavigation.currentContext!,
          builder: (BuildContext context) => SuccessDialogBox(
            title: 'Success',
            description: forgotResponse?.message ?? 'An error occured',
            // description: forgotResponse.message,
            buttonText: 'OK',
          ),
        );
      });
    }
  }

  void onUserTypeSelection(String v, {bool isInitialization = false}) {
    userTypeController.text = v;
    controllerMask = v == 'Teacher'
        ? '00000000'
        : v == 'Parent'
        ? '00000-0000000-0'
        : '00000000';
    userNameController = MaskedTextController(mask: controllerMask);
    userNameLabel = v == 'Parent' ? 'CNIC Number' : 'Roll Number';
    userNameHint = v == 'Parent' ? 'xxxxx-xxxxxxx-x' : 'xxxxxxxx';

    if (!isInitialization) {
      notifyListeners();
      AppNavigation.goBack();
    }
  }

  void userTypeBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        controller: userTypeController,
        filterOptions: userTypeList,
        onSelect: (v) => onUserTypeSelection(v),
      ),
    );
  }

  void disposeData() {
    userNameController!.clear();
    phoneNumberController.clear();
    pinCodeController.clear();
    forgotResponse = ResponseMessage();
    userTypeController = TextEditingController(text: 'Student');
    controllerMask = '00000000';
    confirmPasswordController.clear();
    passwordController.clear();
    obscureTextPassword = true;
    obscureTextConfirmPassword = true;
  }
}
