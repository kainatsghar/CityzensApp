import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../Utils/app_colors.dart';

class TeacherSectionComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              CustomLogoCover(),
              SizedBox(height: size.height * 0.03),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Form(
                  key: value.formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                          hintText:
                              HelperFunction.dateFormatter('${DateTime.now()}'),
                          isEnable: false,
                          readOnly: true,
                          prefixIcon: Icons.date_range),
                      SizedBox(height: size.height * 0.02),
                      CustomTextFormField(
                          hintText: 'Select Section',
                          controller: value.sectionController,
                          onTap: () => value.sectionBottomSheet(),
                          readOnly: true,
                          validator: HelperFunction.validator,
                          suffixWidget: ImageIcon(
                              AssetImage('images/dropdown_icon.png'),
                              color: AppColors.whiteColor)),
                      Visibility(
                        visible: value.classId == 19 || value.classId == 20,
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            CustomTextFormField(
                                hintText: 'Select Subject',
                                controller: value.subjectController,
                                onTap: () => value.subjectBottomSheet(),
                                readOnly: true,
                                validator: HelperFunction.validator,
                                suffixWidget: ImageIcon(
                                    AssetImage('images/dropdown_icon.png'),
                                    color: AppColors.whiteColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => value.navigateToMarkAttendance())
            ],
          ),
        );
      }),
    );
  }
}
