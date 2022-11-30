import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Registration/registration_provider.dart';

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
    double padding = 10.0, imageWidth = 2.5;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'Create Password'),
        body: LayoutBuilder(builder: (context, boxConstraints) {
          final mediaQueryData = MediaQuery.of(context);
          if (boxConstraints.maxWidth <= 320) {
            padding = 5.0;
            imageWidth = 2.8;
          } else if (mediaQueryData.orientation == Orientation.landscape) {
            imageWidth = 6.0;
            padding = 5.0;
          }
          return Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child:
                  Consumer<RegistrationProvider>(builder: (context, value, _) {
                return Column(
                  children: <Widget>[
                    Image.asset(
                      'images/tcs_logo.png',
                      height: size.width / imageWidth,
                      width: size.width / imageWidth,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5.0, right: 5.0, top: padding),
                      child: Column(
                        children: <Widget>[
                          Form(
                              key: value.createPasswordFormKey,
                              child: Column(
                                children: <Widget>[
                                  CustomTextFormField(
                                      isEnable: false,
                                      labelText:
                                          '${/*value.userNameController.text*/ 1234}',
                                      prefixIcon: Icons.person),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: padding + 5)),
                                  CustomTextFormField(
                                      controller: value.passwordController,
                                      obscureText: true,
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      labelText: 'Password',
                                      hintText: 'xxxxxxxx',
                                      prefixIcon: Icons.vpn_key,
                                      validator: value.passwordValidator),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: padding + 5)),
                                  CustomTextFormField(
                                      obscureText: value.obscureText,
                                      controller:
                                          value.confirmPasswordController,
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.done,
                                      labelText: 'Confirm Password',
                                      hintText: 'xxxxxxxx',
                                      prefixIcon: Icons.vpn_key,
                                      suffixWidget: GestureDetector(
                                        onTap: () => value.showHidePassword(),
                                        child: Icon(value.obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      validator:
                                          value.confirmPasswordValidator),
                                ],
                              )),
                          Padding(padding: EdgeInsets.only(top: padding + 5)),
                          CustomAppButton(
                              buttonTitle: 'Create Password',
                              onTap: () => value.createPassword())
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        }));
  }
}
