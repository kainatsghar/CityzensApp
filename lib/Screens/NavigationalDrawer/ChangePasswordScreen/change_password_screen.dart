import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../utils/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var provider = Provider.of<DashboardProvider>(
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
      appBar: const CustomAppBar(title: 'CHANGE PASSWORD'),
      body: SafeArea(
        child: Consumer<DashboardProvider>(
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: SingleChildScrollView(
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
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: value.changePasswordFormKey,
                            child: Column(
                              children: <Widget>[
                                CustomTextFormField(
                                  isEnable: false,
                                  hintText: value.userNameController.text,
                                  prefixIcon: Icons.person,
                                ),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                  controller: value.oldPassController,
                                  obscureText: value.obscureText,
                                  suffixWidget: GestureDetector(
                                    onTap: () => value.showHidePassword(),
                                    child: Icon(
                                      value.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  hintText: 'Current Password',
                                  prefixIcon: Icons.lock,
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                  controller: value.newPassController,
                                  obscureText: value.obscureTextNewPassword,
                                  suffixWidget: GestureDetector(
                                    onTap: () => value.showHideNewPassword(),
                                    child: Icon(
                                      value.obscureTextNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  hintText: 'New Password',
                                  prefixIcon: Icons.lock,
                                  validator: value.passwordValidator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                  obscureText: value.obscureTextConfirmPassword,
                                  controller: value.confirmPassController,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  hintText: 'Confirm Password',
                                  prefixIcon: Icons.lock,
                                  suffixWidget: GestureDetector(
                                    onTap: () =>
                                        value.showHideConfirmPassword(),
                                    child: Icon(
                                      value.obscureTextConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  validator: value.confirmPasswordValidator,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    CustomAppButton(
                      buttonTitle: 'Save',
                      onTap: () => value.changePassword(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
