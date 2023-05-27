import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Registration/registration_provider.dart';

import '../../../Utils/app_colors.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String userType;

  CreatePasswordScreen({Key key, this.userType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePasswordScreenState();
  }
}

class CreatePasswordScreenState extends State<CreatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'CREATE PASSWORD'),
        body: LayoutBuilder(builder: (context, boxConstraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              child:
                  Consumer<RegistrationProvider>(builder: (context, value, _) {
                return Column(
                  children: <Widget>[
                    Image.asset('images/logo_cover.png',
                        fit: BoxFit.fitWidth,
                        height: size.height * 0.18,
                        width: size.width * 0.5),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Form(
                              key: value.createPasswordFormKey,
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
                                      controller:
                                          value.confirmPasswordController,
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
                                      validator:
                                          value.confirmPasswordValidator),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    CustomAppButton(
                        buttonTitle: 'Save',
                        onTap: () => value.createPassword())
                  ],
                );
              }),
            ),
          );
        }));
  }
}
