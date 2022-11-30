import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';


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
    double textFontSize = 16.0, padding = 10.0, imageWidth = 3.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: 'Login'),
      body: LayoutBuilder(builder: (context, boxConstraints) {
        final mediaQueryData = MediaQuery.of(context);
        if (boxConstraints.maxWidth <= 320.0) {
          padding = 5.0;
          imageWidth = 3.3;
          textFontSize = 13.0;
        } else if (mediaQueryData.orientation == Orientation.landscape) {
          imageWidth = 6.8;
          textFontSize = 16;
          padding = 5.0;
        }
        return Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: SingleChildScrollView(
            child: Consumer<LoginProvider>(builder: (context, value, _) {
              return Column(
                children: <Widget>[
                  Image.asset('images/tcs_logo.png',
                      height: size.width / imageWidth,
                      width: size.width / imageWidth),
                  Padding(padding: EdgeInsets.only(top: padding)),
                  Form(
                    key: value.formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                            controller: value.userTypeController,
                            labelText: 'User Type',
                            readOnly: true,
                            onTap: () => value.userTypeBottomSheet(),
                            suffixWidget: Icon(Icons.arrow_drop_down)),
                        Padding(padding: EdgeInsets.only(top: padding)),
                        CustomTextFormField(
                            controller: value.userNameController,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            labelText: value.userNameLabel,
                            hintText: value.userNameHint,
                            prefixIcon: Icons.person,
                            validator: value.validator),
                        Padding(padding: EdgeInsets.only(top: padding + 5)),
                        CustomTextFormField(
                            controller: value.passwordController,
                            obscureText: value.obscureText,
                            inputType: TextInputType.text,
                            labelText: 'Password',
                            hintText: 'xxxxxxx',
                            prefixIcon: Icons.vpn_key,
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
                  Padding(padding: EdgeInsets.only(top: padding)),
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
                            AppNavRoutes.forgotPasswordRoute),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: padding + 10)),
                  CustomAppButton(
                      buttonTitle: 'Login', onTap: () => value.login()),
                  Padding(padding: EdgeInsets.only(top: padding + 5)),
                  Text('- OR -'),
                  Padding(padding: EdgeInsets.only(top: padding + 5)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('New user?'),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      InkWell(
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.registrationRoute),
                        child: Text(
                          'Register here',
                          style: TextStyle(
                              fontSize: textFontSize,
                              decoration: TextDecoration.underline,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                 /* Padding(padding: EdgeInsets.only(top: padding)),
                  FlatButton(
                    child: Text(
                      'Online Student Registration Form',
                      style: TextStyle(
                          fontSize: textFontSize,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () => AppNavigation.navigateTo(
                        AppNavRoutes.onlineStdRegRoute),
                  ),*/
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
