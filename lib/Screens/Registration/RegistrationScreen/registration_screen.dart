import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Registration/registration_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationProvider provider = Provider.of<RegistrationProvider>(
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
    Size size = MediaQuery.of(context).size;
    double textFontSize = 16.0, padding = 10.0, imageWidth = 3.0;
    return Scaffold(
        appBar: CustomAppBar(title: 'User Registration'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Consumer<RegistrationProvider>(builder: (context, value, _) {
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
                    child: Form(
                      key: value.regFormKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextFormField(
                              controller: value.userTypeController,
                              readOnly: true,
                              onTap: () => value.userTypeBottomSheet(),
                              suffixWidget: ImageIcon(
                                  AssetImage('images/dropdown_icon.png'),
                                  color: AppColors.whiteColor)),
                          SizedBox(height: size.height * 0.02),
                          CustomTextFormField(
                              controller: value.userNameController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              hintText: value.userNameLabel,
                              prefixIcon: Icons.person,
                              validator: value.validator),
                          SizedBox(height: size.height * 0.02),
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
                  SizedBox(height: size.height * 0.02),
                  CustomAppButton(
                    buttonTitle: 'Next',
                    onTap: () => value.userRegistration(),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Note:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "\u2022 Please use the mobile number registered as 'Primary Number' with your respective TCS Branch.",
                          style: TextStyle(height: 1.5)),
                      Text(
                          '\u2022 For assistance, please reach out to your respective School Administrator or email us on:',
                          style: TextStyle(height: 1.5)),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  InkWell(
                    onTap: value.launchEmail,
                    child: Text(
                      'appfeedback@csn.edu.pk',
                      style: TextStyle(
                          fontSize: textFontSize,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
