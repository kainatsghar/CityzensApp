import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Utils/validators.dart';

import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../Utils/app_colors.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return UpdatePasswordScreenState();
  }
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'UPDATE PASSWORD'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Consumer<ForgotPasswordProvider>(
            builder: (context, value, _) {
              return Column(
                children: <Widget>[
                  const CustomLogoCover(),
                  SizedBox(height: size.height * 0.02),
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
                          key: value.updatePasswordFormKey,
                          child: Column(
                            children: <Widget>[
                              CustomTextFormField(
                                isEnable: false,
                                hintText: '${value.userNameController?.text}',
                                prefixIcon: Icons.person,
                              ),
                              SizedBox(height: size.height * 0.02),
                              CustomTextFormField(
                                controller: value.passwordController,
                                obscureText: value.obscureTextPassword,
                                suffixWidget: GestureDetector(
                                  onTap: () => value.showHidePassword(),
                                  child: Icon(
                                    value.obscureTextPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                hintText: 'Password',
                                prefixIcon: Icons.lock,
                                validator: Validators.passwordValidator,
                              ),
                              SizedBox(height: size.height * 0.02),
                              CustomTextFormField(
                                obscureText: value.obscureTextConfirmPassword,
                                controller: value.confirmPasswordController,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                hintText: 'Confirm Password',
                                prefixIcon: Icons.lock,
                                suffixWidget: GestureDetector(
                                  onTap: () => value.showHideConfirmPassword(),
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
                    onTap: () => value.updatePassword(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
