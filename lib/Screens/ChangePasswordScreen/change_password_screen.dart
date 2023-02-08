import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var provider = Provider.of<DashboardProvider>(AppNavigation.currentContext,
      listen: false);

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
    double padding = 10.0, imageWidth = 3.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'Change Password'),
        body: LayoutBuilder(builder: (context, boxConstraints) {
          final mediaQueryData = MediaQuery.of(context);
          if (boxConstraints.maxWidth <= 320) {
            padding = 5.0;
            imageWidth = 3.2;
          } else if (mediaQueryData.orientation == Orientation.landscape) {
            imageWidth = 6.5;
            padding = 5.0;
          }
          return Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset('images/tcs_logo.png',
                      height: size.width / imageWidth,
                      width: size.width / imageWidth),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, top: padding),
                    child: Consumer<DashboardProvider>(
                        builder: (context, value, _) {
                      return Column(
                        children: <Widget>[
                          Form(
                              key: value.changePasswordFormKey,
                              child: Column(
                                children: <Widget>[
                                  CustomTextFormField(
                                      isEnable: false,
                                      labelText:
                                          '${value.userNameController.text}',
                                      prefixIcon: Icons.person),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: padding + 5)),
                                  CustomTextFormField(
                                      controller: value.oldPassController,
                                      obscureText: true,
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      labelText: 'Old Password',
                                      hintText: 'xxxxxxxx',
                                      prefixIcon: Icons.vpn_key,
                                      validator: value.validator),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: padding + 5)),
                                  CustomTextFormField(
                                      controller: value.newPassController,
                                      obscureText: true,
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      labelText: 'New Password',
                                      hintText: 'xxxxxxxx',
                                      prefixIcon: Icons.vpn_key,
                                      validator: value.passwordValidator),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: padding + 5)),
                                  CustomTextFormField(
                                      obscureText: value.obscureText,
                                      controller: value.confirmPassController,
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
                              buttonTitle: 'Change Password',
                              onTap: () => value.changePassword())
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
