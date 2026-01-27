import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../Provider/ClassTestResult/class_test_result_provider.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/helper_function.dart';

class TeacherAddClassResultComponent extends StatelessWidget {
  const TeacherAddClassResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Consumer<ClassTestResultProvider>(
        builder: (context, value, _) {
          return Column(
            children: [
              const CustomCoverImage(
                title: 'CLASS TEST RESULTS',
                imagePath: 'class_result_c.png',
              ),
              SizedBox(height: size.height * 0.03),
              CustomCard(
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
                      SizedBox(height: size.height * 0.02),
                      CustomTextFormField(
                        hintText: 'Select Subject',
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
              ),
              SizedBox(height: size.height * 0.03),
              CustomAppButton(
                buttonTitle: 'Next',
                onTap: () => {value.navigateToAddClassResult()},
              ),
            ],
          );
        },
      ),
    );
  }
}
