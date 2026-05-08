import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/custom_widgets/UserTypeTabSelector/user_type_tab_selector.dart';
import 'package:tcs_app/provider/Registration/registration_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/input_formatters.dart';
import 'package:tcs_app/utils/validators.dart';

import 'package:tcs_app/custom_widgets/CustomNoteCard/custom_note_card.dart';
import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationProvider provider = Provider.of<RegistrationProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

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
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'USER REGISTRATION'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Consumer<RegistrationProvider>(
            builder: (context, value, _) {
              return Column(
                children: <Widget>[
                  const CustomLogoCover(),
                  SizedBox(height: size.height * 0.02),
                  CustomCard(
                    child: Form(
                      key: value.regFormKey,
                      child: Column(
                        children: <Widget>[
                          UserTypeTabSelector(
                            options: value.userTypeList,
                            initialIndex: value.userTypeList.indexWhere(
                              (t) => t.title == value.userTypeController.text,
                            ),
                            onChanged: (index) =>
                                provider.selectUserTypeInline(index),
                            height: 48,
                          ),
                          // CustomTextFormField(
                          //   controller: value.userTypeController,
                          //   readOnly: true,
                          //   onTap: () => value.userTypeBottomSheet(),
                          //   suffixWidget: const ImageIcon(
                          //     AssetImage('assets/images/dropdown_icon.png'),
                          //     color: AppColors.whiteColor,
                          //   ),
                          // ),
                          SizedBox(height: size.height * 0.02),
                          CustomTextFormField(
                            controller: value.userNameController,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintText: value.userNameLabel,
                            prefixIcon: Icons.person,
                            validator: value.validator,
                          ),
                          SizedBox(height: size.height * 0.02),
                          CustomTextFormField(
                            controller: value.phoneNumberController,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.done,
                            hintText: 'Mobile Number(03XX-XXXXXXX)',
                            prefixIcon: Icons.phone_iphone,
                            inputFormatter:
                                InputFormatters.mobileNumberFormatter(),
                            validator: Validators.validatorForMobileNo,
                          ),
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
                  const CustomNoteCard(
                    notes: [
                      "Please use the mobile number registered as 'Primary Number' with your respective TCS Branch.",
                      "For assistance, please reach out to your respective School Administrator or contact TCS Support.",
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        AppNavigation.navigateTo(AppNavRoutes.appFeedbackRoute);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: AppColors.primaryBlue.withValues(
                          alpha: 0.05,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primaryBlue,
                        size: 18,
                      ),
                      label: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  // InkWell(
                  // onTap:
                  // HelperFunction.sendEmail(AppConstants.appSupportEmail),
                  // child: Text(
                  //   AppConstants.appSupportEmail,
                  //   style: TextStyle(
                  //     fontSize: 15.0,
                  //     fontStyle: FontStyle.italic,
                  //     color: AppColors.primaryColor,
                  //     decoration: TextDecoration.underline,
                  //   ),
                  // ),
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
