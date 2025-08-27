import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_alevel_attendance_provider.dart';
// import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:provider/provider.dart';

import '../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../Utils/app_colors.dart';

class StudentALevelAttendanceSubjectComponent extends StatelessWidget {
  const StudentALevelAttendanceSubjectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<StudentALevelAttendanceProvider>(
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Form(
              key: value.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const CustomLogoCover(),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            hintText: 'Subject',
                            controller: value.subjectController,
                            onTap: () => value.subjectBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                              AssetImage('assets/images/dropdown_icon.png'),
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    CustomAppButton(
                      buttonTitle: 'Next',
                      onTap: () => value.navigateToAttendance(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
