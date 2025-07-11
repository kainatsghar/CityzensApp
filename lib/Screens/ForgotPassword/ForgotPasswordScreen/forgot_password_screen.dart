import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../../Utils/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordProvider provider = Provider.of<ForgotPasswordProvider>(
      AppNavigation.currentContext!,
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: 'FORGOT PASSWORD'),
        body: SingleChildScrollView(
          child: Consumer<ForgotPasswordProvider>(builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 25.0),
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Form(
                    key: value.forgotFormKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                            controller: value.userTypeController,
                            readOnly: true,
                            onTap: () => value.userTypeBottomSheet(),
                            suffixWidget: const ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.whiteColor)),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                            controller: value.userNameController!,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintText: value.userNameLabel,
                            prefixIcon: Icons.person,
                            validator: value.validator),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                            controller: value.phoneNumberController,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.done,
                            hintText: 'Mobile Number',
                            prefixIcon: Icons.phone_iphone,
                            validator: value.validator),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                CustomAppButton(
                    buttonTitle: 'Next', onTap: () => value.forgotPassword()),
                SizedBox(height: size.height * 0.02),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Note:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.0),
                    Text(
                        '\u2022 Provided Mobile Number needs to be same used for TCS Mobile App registration.')
                  ],
                ),
              ]),
            );
          }),
        ));
  }
}
