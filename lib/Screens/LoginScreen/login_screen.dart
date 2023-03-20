import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginProvider provider =
      Provider.of<LoginProvider>(AppNavigation.currentContext, listen: false);

  @override
  void initState() {
    provider.initializeData();
    super.initState();
  }

  @override
  void dispose() {
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textFontSize = 16.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Login'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<LoginProvider>(builder: (context, value, _) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Image.asset('images/tcs_logo.png',
                          height: size.width / 3, width: size.width / 3),
                      SizedBox(height: 10),
                      Form(
                        key: value.formKey,
                        child: Column(
                          children: <Widget>[
                            CustomTextFormField(
                                controller: value.userTypeController,
                                labelText: 'User Type',
                                readOnly: true,
                                onTap: () => value.userTypeBottomSheet(),
                                suffixWidget: ImageIcon(
                                    AssetImage('images/dropdown_icon.png'))),
                            SizedBox(height: 10),
                            CustomTextFormField(
                                controller: value.userNameController,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.next,
                                labelText: value.userNameLabel,
                                hintText: value.userNameHint,
                                prefixIcon: Icons.person,
                                validator: value.validator),
                            SizedBox(height: 15),
                            CustomTextFormField(
                                controller: value.passwordController,
                                obscureText: value.obscureText,
                                inputType: TextInputType.text,
                                labelText: 'Password',
                                hintText: 'xxxxxxx',
                                prefixIcon: Icons.vpn_key,
                                inputAction: TextInputAction.done,
                                suffixWidget: GestureDetector(
                                  onTap: () => value.showHidePassword(),
                                  child: Icon(value.obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                validator: value.validator),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => AppNavigation.navigateTo(
                                  AppNavRoutes.forgotPasswordRoute)),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomAppButton(
                          buttonTitle: 'Login', onTap: () => value.login()),
                      SizedBox(height: 15),
                      Text('- OR -'),
                      SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('New user? '),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.registrationRoute),
                            child: Text('Register here',
                                style: TextStyle(
                                    fontSize: textFontSize,
                                    decoration: TextDecoration.underline,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('images/alumni_icon.png',
                                width: size.width * 0.2),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () => HelperFunction.launchURL(
                                      AppConstants.alumniAppURL),
                                  child: Text(
                                    AppConstants.alumniAppURL,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                );
              }),
            ),
          ),
          /* Container(
              color: AppColors.primaryColor,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SafeArea(
                child: InkWell(
                  child: Text('Online Student Registration Form',
                      style: TextStyle(
                          fontSize: textFontSize,
                          fontStyle: FontStyle.italic,
                          color: AppColors.whiteColor)),
                  onTap: () =>
                      AppNavigation.navigateTo(AppNavRoutes.onlineStdRegRoute),
                ),
              ))*/
        ],
      ),
    );
  }
}
