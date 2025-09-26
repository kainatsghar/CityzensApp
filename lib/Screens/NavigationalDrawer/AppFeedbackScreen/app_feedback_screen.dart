import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Provider/SupportForm/support_form_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/input_formatters.dart';
import 'package:tcs_app/Utils/validators.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key});

  @override
  State<StatefulWidget> createState() => AppFeedbackScreenState();
}

class AppFeedbackScreenState extends State<AppFeedbackScreen> {
  var provider = Provider.of<SupportFormProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.initializeData();
    if (provider.userType.isNotEmpty) {
      provider.clearData();
      provider.initializeUserData();
    }
    provider.loadDeviceInfo();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'APP FEEDBACK'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 16.0,
          ),
          child: Column(
            children: <Widget>[
              const CustomLogoCover(),
              SizedBox(height: size.height * 0.03),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Form(
                  key: provider.formKey,
                  child: Column(
                    children: <Widget>[
                      // User Name
                      CustomTextFormField(
                        controller: provider.nameController,
                        prefixIcon: Icons.person,
                        hintText: "User Name",
                        validator: (val) => Validators.validator(val),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // User Type (read-only)
                      if (provider.userType.isNotEmpty) ...[
                        CustomTextFormField(
                          hintText: provider.userType,
                          prefixIcon: Icons.account_circle,
                          isEnable: false,
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],

                      // ID
                      CustomTextFormField(
                        controller: provider.idController,
                        prefixIcon: Icons.badge,
                        hintText: "Roll No / ERP / CNIC",
                        validator: (val) => Validators.validator(val),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Class (Students only)
                      if (provider.userType ==
                          HelperFunction.userType(AppUserType.student)) ...[
                        Column(
                          children: [
                            CustomTextFormField(
                              controller: provider.classController,

                              prefixIcon: Icons.school,
                              hintText: "Class",
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                      ],

                      if (provider.userType !=
                          HelperFunction.userType(AppUserType.parent)) ...[
                        // Campus
                        CustomTextFormField(
                          controller: provider.campusController,

                          prefixIcon: Icons.business,
                          hintText: "Campus",
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],

                      if (provider.userType !=
                          HelperFunction.userType(AppUserType.parent)) ...[
                        // Region
                        CustomTextFormField(
                          controller: provider.regionController,

                          prefixIcon: Icons.location_city,
                          hintText: "Region",
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],

                      // Contact Email
                      CustomTextFormField(
                        controller: provider.emailController,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        hintText: "Contact Email",
                        validator: Validators.validatorForEmail,
                      ),
                      SizedBox(height: size.height * 0.02),
                      // Contact No
                      CustomTextFormField(
                        controller: provider.mobileContactController,
                        inputType: TextInputType.phone,
                        hintText: 'Mobile Number(03XX-XXXXXXX)',
                        prefixIcon: Icons.phone_iphone,
                        inputFormatter: InputFormatters.mobileNumberFormatter(),
                        validator: Validators.validatorForMobileNo,
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Feedback Type Dropdown
                      DropdownButtonFormField<String>(
                        // padding: EdgeInsets.zero,
                        initialValue: provider.selectedFeedbackType,
                        borderRadius: BorderRadius.circular(8.0),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 3.0),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                            ),
                            child: Icon(
                              Icons.feedback,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: provider.feedbackTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            provider.updateFeedbackType(value);
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Title
                      CustomTextFormField(
                        controller: provider.titleController,
                        hintText: "Title",
                        prefixIcon: Icons.title,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Details
                      CustomTextFormField(
                        controller: provider.detailsController,
                        hintText: "Details",
                        // prefixIcon: Icons.description,
                        maxLines: 4,
                        inputType: TextInputType.multiline,
                        inputAction: TextInputAction.newline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Details are required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Children Info (for Parents only)
                      if (provider.userType == "Parent" &&
                          provider.multiChildResponse != null)
                        Column(
                          children: provider.multiChildResponse!.children!
                              .map(
                                (c) => Card(
                                  color: AppColors.whiteColor.withValues(
                                    alpha: 0.8,
                                  ),
                                  child: ListTile(
                                    leading: CustomUserImage(
                                      imageSize: size.width * 0.15,
                                      userId: '${c.studentId}',
                                    ),
                                    title: Text(
                                      "${c.studentName} (${c.studentId}) - ${c.className} (${c.centerName}, ${c.regionName})",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Note:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\u2023 Please attach screenshots or documents if necessary in the email that will be generated.',
                      style: TextStyle(height: 1.5),
                    ),
                    Text(
                      "\u2023 Please provide valid contact details so that we can get back to you.",
                      style: TextStyle(height: 1.5),
                    ),
                    Text(
                      '\u2023 Your feedback is important to us and will be kept confidential.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Submit button
              CustomAppButton(
                buttonTitle: 'Generate Email',
                onTap: () => provider.sendSupportEmail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
