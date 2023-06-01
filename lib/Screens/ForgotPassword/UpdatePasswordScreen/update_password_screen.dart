import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';

import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../Utils/app_colors.dart';

class UpdatePasswordScreen extends StatefulWidget {
  UpdatePasswordScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpdatePasswordScreenState();
  }
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'UPDATE PASSWORD'),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              child: Consumer<ForgotPasswordProvider>(
                  builder: (context, value, _) {
                return Column(children: <Widget>[
                  CustomLogoCover(),
                  SizedBox(height: size.height * 0.02),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(children: <Widget>[
                        Form(
                            key: value.updatePasswordFormKey,
                            child: Column(
                              children: <Widget>[
                                CustomTextFormField(
                                    isEnable: false,
                                    hintText:
                                        '${value.userNameController.text}',
                                    prefixIcon: Icons.person),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                    controller: value.passwordController,
                                    obscureText: true,
                                    inputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock,
                                    validator: value.passwordValidator),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                    obscureText: value.obscureText,
                                    controller: value.confirmPasswordController,
                                    inputType: TextInputType.text,
                                    inputAction: TextInputAction.done,
                                    hintText: 'Confirm Password',
                                    prefixIcon: Icons.lock,
                                    suffixWidget: GestureDetector(
                                        onTap: () => value.showHidePassword(),
                                        child: Icon(
                                            value.obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.whiteColor)),
                                    validator: value.confirmPasswordValidator),
                              ],
                            )),
                      ])),
                  SizedBox(height: size.height * 0.02),
                  CustomAppButton(
                      buttonTitle: 'Save', onTap: () => value.updatePassword())
                ]);
              }),
            )));
  }
}
