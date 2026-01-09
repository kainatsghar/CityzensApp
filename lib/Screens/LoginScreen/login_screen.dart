import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/CustomWidgets/UserTypeTabSelector/user_type_tab_selector.dart';
import 'package:tcs_app/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/validators.dart';

import '../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginProvider provider = Provider.of<LoginProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

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
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'LOGIN'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<LoginProvider>(
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: <Widget>[
                          const CustomLogoCover(),
                          SizedBox(height: size.height * 0.03),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 25.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Form(
                              key: value.formKey,
                              child: Column(
                                children: <Widget>[
                                  UserTypeTabSelector(
                                    options: value.userTypeList,
                                    initialIndex: value.userTypeList.indexWhere(
                                      (t) => t.title == value.userType,
                                    ),
                                    onChanged: (index) =>
                                        provider.selectUserTypeInline(index),
                                    height: 48,
                                  ),

                                  // CustomTextFormField(
                                  //   controller: value.userTypeController,
                                  //   hintText: 'User Type',
                                  //   readOnly: true,
                                  //   onTap: () => value.userTypeBottomSheet(),
                                  //   suffixWidget: const ImageIcon(
                                  //     AssetImage(
                                  //       'assets/images/dropdown_icon.png',
                                  //     ),
                                  //     color: AppColors.whiteColor,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 12),
                                  CustomTextFormField(
                                    controller: value.userNameController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    labelText: value.userNameLabel,
                                    hintText: value.userNameLabel,
                                    prefixIcon: Icons.person,
                                    validator: value.validator,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextFormField(
                                    controller: value.passwordController,
                                    obscureText: value.obscureText,
                                    inputType: TextInputType.text,
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock,
                                    inputAction: TextInputAction.done,
                                    suffixWidget: GestureDetector(
                                      onTap: () => value.showHidePassword(),
                                      child: Icon(
                                        value.obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    validator: Validators.validator,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: const Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppColors.primaryTitleColor,
                                    // shadows: [
                                    //   Shadow(
                                    //     color: AppColors.primaryColor,
                                    //     blurRadius: 12,
                                    //   ),
                                    // ],
                                  ),
                                ),
                                onTap: () => AppNavigation.navigateTo(
                                  AppNavRoutes.forgotPasswordRoute,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomAppButton(
                            buttonTitle: 'Login',
                            onTap: () => value.login(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.black26,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("OR"),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black26,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          // const Text('- OR -'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('New user? '),
                              const SizedBox(height: 8),
                              InkWell(
                                // onTap: () => AppNavigation.navigateTo(
                                //     AppNavRoutes.registrationRoute),
                                onTap: () => AppNavigation.navigateTo(
                                  AppNavRoutes.introductionRoute,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.paleYellow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Register here",
                                    style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                //  const Text(
                                //   'Register here',
                                //   style: TextStyle(
                                //     fontSize: 16.0,
                                //     fontStyle: FontStyle.italic,
                                //     decoration: TextDecoration.underline,
                                //     decorationColor:
                                //         AppColors.primaryTitleColor,
                                //     color: AppColors.primaryTitleColor,
                                //     fontWeight: FontWeight.w500,
                                //     shadows: [
                                //       Shadow(
                                //         color: AppColors.primaryColor,
                                //         blurRadius: 4,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.025),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/alumni_icon.png',
                                  width: size.width * 0.2,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: InkWell(
                                      onTap: () => HelperFunction.launchURL(
                                        Platform.isIOS
                                            ? AppConstants.alumniIOSAppURL
                                            : AppConstants.alumniAndroidAppURL,
                                      ),
                                      child: const Text(
                                        'The City School ALUMNI App',
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColors.primaryTitleColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
      ),
    );
  }
}
