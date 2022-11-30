import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordProvider provider = Provider.of<ForgotPasswordProvider>(
      AppNavigation.currentContext,
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
    double textFontSize = 16.0, padding = 10.0, imageWidth = 2.5;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'Forgot Password'),
        body: LayoutBuilder(builder: (context, boxConstraints) {
          final mediaQueryData = MediaQuery.of(context);
          if (boxConstraints.maxWidth <= 320) {
            padding = 5.0;
            imageWidth = 2.8;
            textFontSize = 14.0;
          } else if (mediaQueryData.orientation == Orientation.landscape) {
            imageWidth = 6.0;
            textFontSize = 16;
            padding = 5.0;
          }
          return Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child: Consumer<ForgotPasswordProvider>(
                  builder: (context, value, _) {
                return Column(children: <Widget>[
                  Image.asset('images/tcs_logo.png',
                      height: size.width / imageWidth,
                      width: size.width / imageWidth),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, top: padding),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: value.forgotFormKey,
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
                              Padding(
                                  padding: EdgeInsets.only(top: padding + 5)),
                              CustomTextFormField(
                                  controller: value.phoneNumberController,
                                  inputType: TextInputType.number,
                                  inputAction: TextInputAction.done,
                                  labelText: 'Mobile Number',
                                  hintText: '03XXXXXXXXX',
                                  prefixIcon: Icons.phone_iphone,
                                  validator: value.validator),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: padding + 5)),
                        CustomAppButton(
                          buttonTitle: 'Next',
                          onTap: () => value.forgotPassword(),
                        ),
                        Padding(padding: EdgeInsets.only(top: padding + 5)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Note:',
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\u2022 Provided Mobile Number needs to be same used for TCS Mobile App registration.',
                              style: TextStyle(fontSize: textFontSize - 2.0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]);
              }),
            ),
          );
        }));
  }
}
