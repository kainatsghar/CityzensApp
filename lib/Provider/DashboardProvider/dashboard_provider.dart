import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/ChangePassword/change_password_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardProvider with ChangeNotifier {
  final changePasswordFormKey = GlobalKey<FormState>();

  bool obscureText = true;
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
      return "Password must be atleast 8 characters long";
    } else {
      return null;
    }
  }

  String confirmPasswordValidator(String value) {
    if (value.isEmpty) {
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
      if (changePasswordFormKey.currentState.validate()) {
        FocusScope.of(AppNavigation.currentContext).requestFocus(FocusNode());
        ResponseMessage responseMessage =
            await ChangePasswordService.changePasswordRequest(
                userName: userNameController.text,
                oldPassword: oldPassController.text,
                userType: userTypeController.text);
        if (responseMessage.isSuccessful) {
          Future.delayed(Duration.zero, () => AppNavigation.goBack());
          showSnackBar(
              'Password for ${userNameController.text} has been changed successfully',
              color: AppColors.graphGreenColor);
          disposeData();
        } else {
          showSnackBar(responseMessage.message);
        }
      }
    } catch (ex) {
      showSnackBar(ex);
    }
    DialogBuilder.hideOpenDialog();
  }

  void initializeData() {
    var localProvider = Provider.of<LocalDataProvider>(
        AppNavigation.currentContext,
        listen: false);
    userNameController.text = localProvider.userData.userName;
    userTypeController.text = localProvider.userData.userType;
  }

  launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=' + 'com.tcs.tcsapp';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  launchAppStore() {
    LaunchReview.launch(writeReview: false, iOSAppId: '1449936833');
  }

  launchEmail() async {
    const address = 'mailto:appfeedback@csn.edu.pk';
    try {
      if (await canLaunchUrl(Uri.parse(address))) {
        await launchUrl(Uri.parse(address));
      } else {
        throw 'Could not launch $address';
      }
    } catch (_) {
      throw 'Could not launch $address';
    }
  }

  loadVersionName() async {
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
  }
}
