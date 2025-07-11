import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../Utils/app_colors.dart';

class ForgotPinCodeScreen extends StatefulWidget {
  const ForgotPinCodeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ForgotPinCodeScreenState();
  }
}

class ForgotPinCodeScreenState extends State<ForgotPinCodeScreen> {
  ForgotPasswordProvider provider = Provider.of<ForgotPasswordProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    provider.initializePinCodeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: 'SECURITY CHECK'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child:
                Consumer<ForgotPasswordProvider>(builder: (context, value, _) {
              return Column(children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 25.0),
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Form(
                    key: value.pinCodeFormKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                            isEnable: false,
                            hintText: value.userNameController!.text,
                            prefixIcon: Icons.person),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                            inputType: TextInputType.number,
                            controller: value.pinCodeController,
                            hintText: 'PIN Code',
                            prefixIcon: Icons.security,
                            validator: value.validator),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                CustomAppButton(
                    buttonTitle: 'Next', onTap: () => value.verifyPinCode()),
                SizedBox(height: size.height * 0.02),
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Note:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '\u2022 TCS app will send you a message containing 4-digit PIN code you will use to verify your number.',
                          style: TextStyle(height: 1.5)),
                      Text(
                          '\u2022 Verification message might not reach you if promotional message are blocked from your service provider.',
                          style: TextStyle(height: 1.5))
                    ])
              ]);
            }),
          ),
        ));
  }
}
