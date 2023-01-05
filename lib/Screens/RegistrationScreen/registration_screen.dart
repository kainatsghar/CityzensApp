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
        body: LayoutBuilder(builder: (context, boxConstraints) {
          final mediaQueryData = MediaQuery.of(context);
          if (boxConstraints.maxWidth <= 320) {
            padding = 5.0;
            imageWidth = 3.2;
            textFontSize = 14.0;
          } else if (mediaQueryData.orientation == Orientation.landscape) {
            imageWidth = 6.0;
            textFontSize = 16;
            padding = 5.0;
          }
          return Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child:
                  Consumer<RegistrationProvider>(builder: (context, value, _) {
                return Column(
                  children: <Widget>[
                    Image.asset('images/tcs_logo.png',
                        height: size.width / imageWidth,
                        width: size.width / imageWidth),
                    SizedBox(height: padding),
                    Form(
                      key: value.regFormKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextFormField(
                              controller: value.userTypeController,
                              labelText: 'User Type',
                              readOnly: true,
                              onTap: () => value.userTypeBottomSheet(),
                              suffixWidget:  ImageIcon(AssetImage('images/dropdown_icon.png'))),
                         SizedBox(height: padding),
                          CustomTextFormField(
                              controller: value.userNameController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              labelText: value.userNameLabel,
                              hintText: value.userNameHint,
                              prefixIcon: Icons.person,
                              validator: value.validator),
                          SizedBox(height: padding + 5),
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
                    SizedBox(height: padding + 5),
                    CustomAppButton(
                      buttonTitle: 'Next',
                      onTap: () => value.userRegistration(),
                    ),
                    SizedBox(height: padding),
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
                          "\u2022 Please use the mobile number registered as 'Primary Number' with your respective TCS Branch.",
                          style: TextStyle(
                              fontSize: textFontSize - 2.0, height: 1.5),
                        ),
                        Text(
                          '\u2022 For assistance, please reach out to your respective School Administrator or email us on:',
                          style: TextStyle(
                              fontSize: textFontSize - 2.0, height: 1.5),
                        ),
                      ],
                    ),
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
          );
        }));
  }
}
