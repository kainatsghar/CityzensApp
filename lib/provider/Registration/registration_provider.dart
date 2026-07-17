import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/success_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/provider/Login/login_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/Registration/registration_service.dart';
import 'package:tcs_app/services/UpdatePassword/update_password_service.dart';
import 'package:tcs_app/services/VerifyPinCode/verify_pincode_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/validators.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class RegistrationProvider with ChangeNotifier {
  final regFormKey = GlobalKey<FormState>();
  final pinCodeFormKey = GlobalKey<FormState>();
  final createPasswordFormKey = GlobalKey<FormState>();

  bool obscureText = true;
  late List<Options> userTypeList;
  String userNameLabel = 'Roll Number', userNameHint = 'xxxxxxxx';
  String controllerMask = '00000000';
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController userTypeController = TextEditingController(
    text: 'Student',
  );
  late MaskedTextController userNameController;

  ResponseMessage _responseMessage = ResponseMessage();

  LoginProvider loginProvider = Provider.of<LoginProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  String? validator(String? text) => userTypeController.text == 'Parent'
      ? Validators.validatorForCNICNo(text)
      : Validators.validator(text);

  void setResponseData(ResponseMessage responseMessage) {
    _responseMessage = responseMessage;
    notifyListeners();
  }

  void showHidePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // String validator(String value) {
  //   if (value.isEmpty) {
  //     return "Required*";
  //   } else {
  //     return null;
  //   }
  // }
  // String? validator(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "Required*";
  //   } else {
  //     return null;
  //   }
  // }

  // String passwordValidator(String value) {
  //   if (value.isEmpty) {
  //     return "Required*";
  //   } else if (value.length < 8) {
  //     return "Password must be at least 8 characters long";
  //   } else {
  //     return null;
  //   }
  // }
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
    } else if (value != passwordController.text) {
      return "Password doesn't match";
    } else {
      return null;
    }
  }

  Future<void> userRegistration() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (regFormKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage? responseMessage =
            await RegistrationService.userRegRequest(
              userName: userNameController.text,
              mobileNumber: phoneNumberController.text,
              userType: userTypeController.text,
            );
        if (responseMessage.isSuccessful ?? false) {
          setResponseData(responseMessage);
          Future.delayed(
            const Duration(milliseconds: 1),
            () =>
                AppNavigation.navigateTo(AppNavRoutes.registrationPinCodeRoute),
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
              userName: userNameController.text,
              pinCode: pinCodeController.text,
              userType: userTypeController.text,
              isRegPin: true,
            );
        if (responseMessage.isSuccessful ?? false) {
          confirmPasswordController.clear();
          passwordController.clear();
          Future.delayed(
            const Duration(milliseconds: 1),
            () => AppNavigation.navigateTo(AppNavRoutes.createPasswordRoute),
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

  Future<void> createPassword() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (createPasswordFormKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage? responseMessage =
            await UpdatePasswordService.updatePasswordRequest(
              userName: userNameController.text,
              confirmPassword: confirmPasswordController.text,
              userType: userTypeController.text,
              isRegPass: true,
            );
        if (responseMessage.isSuccessful ?? false) {
          Future.delayed(
            const Duration(milliseconds: 1),
            () => AppNavigation.removeAllRoutes(),
          );
          showSnackBar(
            'Password for ${userNameController.text} has been created successfully',
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
    userNameController = MaskedTextController(mask: controllerMask);
    userTypeList = HelperFunction.userTypes().take(2).toList();
    onUserTypeSelection(
      userTypeList.any((element) => element.title == loginProvider.userType)
          ? loginProvider.userType
          : userTypeList.first.title!,
      isInitialization: true,
    );
  }

  void initializePinCodeData() {
    pinCodeController.clear();
    // if (_responseMessage.isSuccessful != null && _responseMessage.isSuccessful) {
    if (_responseMessage.isSuccessful ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showDialog(
          context: AppNavigation.currentContext!,
          builder: (BuildContext context) => SuccessDialogBox(
            title: 'Success',
            description: _responseMessage.message!,
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
    userNameLabel = v == 'Parent' ? 'Father CNIC Number' : 'Roll Number';
    userNameHint = v == 'Parent' ? 'xxxxx-xxxxxxx-x' : 'xxxxxxxx';
    if (!isInitialization) {
      notifyListeners();
      AppNavigation.goBack();
    }
  }

  void selectUserTypeInline(int index) {
    userTypeController.text = userTypeList[index].title!;
    onUserTypeSelection(userTypeList[index].title!, isInitialization: true);
    notifyListeners();
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
