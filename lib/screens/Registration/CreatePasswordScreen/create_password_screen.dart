import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/provider/Registration/registration_provider.dart';

import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../utils/app_colors.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String? userType;

  const CreatePasswordScreen({super.key, this.userType});

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
      appBar: const CustomAppBar(title: 'CREATE PASSWORD'),
      body: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              child: Consumer<RegistrationProvider>(
                builder: (context, value, _) {
                  return Column(
                    children: <Widget>[
                      const CustomLogoCover(),
                      SizedBox(height: size.height * 0.02),
                      CustomCard(
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: value.createPasswordFormKey,
                              child: Column(
                                children: <Widget>[
                                  CustomTextFormField(
                                    isEnable: false,
                                    hintText: value.userNameController.text,
                                    prefixIcon: Icons.person,
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  CustomTextFormField(
                                    controller: value.passwordController,
                                    obscureText: true,
                                    inputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock,
                                    validator: value.passwordValidator,
                                  ),
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
                                        color: AppColors.white,
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
                        onTap: () => value.createPassword(),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
