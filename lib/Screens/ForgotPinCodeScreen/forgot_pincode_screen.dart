import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ForgotPinCodeScreen extends StatefulWidget {
  ForgotPinCodeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForgotPinCodeScreenState();
  }
}

class ForgotPinCodeScreenState extends State<ForgotPinCodeScreen> {
  ForgotPasswordProvider provider = Provider.of<ForgotPasswordProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    provider.initializePinCodeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textFontSize = 16.0, padding = 10.0, imageWidth = 2.5;
    return Scaffold(
        appBar: CustomAppBar(title: 'Security Check'),
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
                return Column(
                  children: <Widget>[
                    Image.asset('images/tcs_logo.png',
                        height: size.width / imageWidth,
                        width: size.width / imageWidth),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5.0, right: 5.0, top: padding),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: value.pinCodeFormKey,
                            child: Column(
                              children: <Widget>[
                                CustomTextFormField(
                                    isEnable: false,
                                    labelText:
                                        '${value.userNameController.text}',
                                    prefixIcon: Icons.person),
                                Padding(
                                    padding: EdgeInsets.only(top: padding + 5)),
                                CustomTextFormField(
                                    inputType: TextInputType.number,
                                    controller: value.pinCodeController,
                                    labelText: 'PIN Code',
                                    hintText: 'xxxx',
                                    prefixIcon: Icons.security,
                                    validator: value.validator),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: padding + 5)),
                          CustomAppButton(
                              buttonTitle: 'Next',
                              onTap: () => value.verifyPinCode()),
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
                                '\u2022 TCS app will send you a message containing 4-digit PIN code you will use to verify your number.',
                                style: TextStyle(
                                    fontSize: textFontSize - 2.0, height: 1.5),
                              ),
                              Text(
                                '\u2022 Verification message might not reach you if promotional message are blocked from your service provider.',
                                style: TextStyle(
                                    fontSize: textFontSize - 2.0, height: 1.5),
                              ),
                            ],
                          ),
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
