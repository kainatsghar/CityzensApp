import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../Provider/TimeTable/timetable_provider.dart';
import '../../Utils/app_colors.dart';

class TeacherTimeTableSectionComponent extends StatelessWidget {
  const TeacherTimeTableSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Consumer<TimeTableProvider>(
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hintText: 'Select Section',
                          controller: value.sectionController,
                          onTap: () => value.sectionBottomSheet(),
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
                ),
                SizedBox(height: size.height * 0.03),
                CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => value.navigateToMarkTimeTable(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
