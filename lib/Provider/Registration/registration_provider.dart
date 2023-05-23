import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/success_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/Registration/registration_service.dart';
import 'package:tcs_app/Services/UpdatePassword/update_password_service.dart';
import 'package:tcs_app/Services/VerifyPinCode/verify_pincode_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationProvider with ChangeNotifier {
  final regFormKey = GlobalKey<FormState>();
  final pinCodeFormKey = GlobalKey<FormState>();
  final createPasswordFormKey = GlobalKey<FormState>();

  bool obscureText = true;
  List<Options> userTypeList;
  String userNameLabel = 'Roll Number', userNameHint = 'xxxxxxxx';
  String controllerMask = '00000000';
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController userTypeController =
      TextEditingController(text: 'Student');
  MaskedTextController userNameController;

  ResponseMessage _responseMessage = ResponseMessage();

  void setResponseData(ResponseMessage responseMessage) {
    _responseMessage = responseMessage;
    notifyListeners();
  }

  void showHidePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  String validator(String value) {
    if (value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return "Required*";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long";
    } else {
      return null;
    }
  }

  String confirmPasswordValidator(String value) {
    if (value.isEmpty) {
      return "Required*";
    } else if (value != passwordController.text) {
      return "Password doesn't match";
    } else {
      return null;
    }
  }

  Future<void> userRegistration() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (regFormKey.currentState.validate()) {
        FocusScope.of(AppNavigation.currentContext).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await RegistrationService.userRegRequest(
                userName: userNameController.text,
                mobileNumber: phoneNumberController.text,
                userType: userTypeController.text);
        if (responseMessage.isSuccessful) {
          setResponseData(responseMessage);
          Future.delayed(
              Duration(milliseconds: 1),
              () => AppNavigation.navigateTo(
                  AppNavRoutes.registrationPinCodeRoute));
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
      if (pinCodeFormKey.currentState.validate()) {
        FocusScope.of(AppNavigation.currentContext).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await VerifyPinCodeService.verifyPinCodeRequest(
                userName: userNameController.text,
                pinCode: pinCodeController.text,
                userType: userTypeController.text,
                isRegPin: true);
        if (responseMessage.isSuccessful) {
          confirmPasswordController.clear();
          passwordController.clear();
          Future.delayed(Duration(milliseconds: 1),
              () => AppNavigation.navigateTo(AppNavRoutes.createPasswordRoute));
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (exception) {
      showSnackBar(exception);
    }
    DialogBuilder.hideOpenDialog();
  }

  Future<void> createPassword() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (createPasswordFormKey.currentState.validate()) {
        FocusScope.of(AppNavigation.currentContext).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await UpdatePasswordService.updatePasswordRequest(
                userName: userNameController.text,
                confirmPassword: confirmPasswordController.text,
                userType: userTypeController.text,
                isRegPass: true);
        if (responseMessage.isSuccessful) {
          Future.delayed(
              Duration(milliseconds: 1), () => AppNavigation.removeAllRoutes());
          showSnackBar(
              'Password for ${userNameController.text} has been created successfully',color: AppColors.successGreenColor);
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
    userNameController = new MaskedTextController(mask: controllerMask);
    userTypeList = HelperFunction.userTypes().take(2).toList();
  }

  void initializePinCodeData() {
    pinCodeController.clear();
    if (_responseMessage.isSuccessful != null &&
        _responseMessage.isSuccessful) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showDialog(
            context: AppNavigation.currentContext,
            builder: (BuildContext context) => SuccessDialogBox(
                title: 'Success',
                description: _responseMessage.message,
                buttonText: 'OK'));
      });
    }
  }

  void onUserTypeSelection(String v) {
    userTypeController.text = v;
    controllerMask = v == 'Teacher'
        ? '00000000'
        : v == 'Parent'
            ? '00000-0000000-0'
            : '00000000';
    userNameController = new MaskedTextController(mask: controllerMask);
    userNameLabel = v == 'Parent' ? 'CNIC Number' : 'Roll Number';
    userNameHint = v == 'Parent' ? 'xxxxx-xxxxxxx-x' : 'xxxxxxxx';
    notifyListeners();
    AppNavigation.goBack();
  }

  void userTypeBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            controller: userTypeController,
            filterOptions: userTypeList,
            onSelect: (v) => onUserTypeSelection(v)));
  }

  launchEmail() async {
    const address = 'mailto:appfeedback@csn.edu.pk';
    if (await canLaunchUrl(Uri.parse(address))) {
      await launchUrl(Uri.parse(address));
    }
  }

  void disposeData() {
    userNameController.clear();
    phoneNumberController.clear();
    pinCodeController.clear();
    _responseMessage = ResponseMessage();
    userTypeController = TextEditingController(text: 'Student');
    controllerMask = '00000000';
    confirmPasswordController.clear();
    passwordController.clear();
    obscureText = true;
  }
}
