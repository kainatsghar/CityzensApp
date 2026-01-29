import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/model/UnverifiedReasons/unverified_reasons_response.dart';
import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../custom_widgets/TabSelector/tab_selector.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../../provider/Dashboard/dashboard_provider.dart';
import '../../provider/MarkUnverified/mark_unverified_provider.dart';
import '../../utils/app_colors.dart';

class MarkUnverifiedComponent extends StatelessWidget {
  const MarkUnverifiedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Consumer2<MarkUnverifiedProvider, DashboardProvider>(
        builder: (context, value, dashboardValue, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                CustomCard(
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: value.studentIdController,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          hintText: 'Roll Number',
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          controller: value.studentNameController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          hintText: 'Student Name',
                          validator: value.validator,
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Text(
                          'Select Section',
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TabSelector<Section>(
                          items: dashboardValue.getSectionsWithDiary(false),
                          getDisplayText: (section) => section.name ?? 'N/A',
                          onItemSelected: (section) {
                            value.sectionController.text = section.name ?? '';
                            value.setSectionId(section.classSectionId ?? 0);
                          },
                          initialItemName: value.sectionController.text,
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Text(
                          'Select Reason',
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TabSelector<VerificationReason>(
                          items: dashboardValue.getUnverifiedReasons(),
                          getDisplayText: (reason) =>
                              reason.reasonDescription ?? 'N/A',
                          onItemSelected: (reason) {
                            value.reasonController.text =
                                reason.reasonDescription ?? '';
                            value.setReasonId(reason.reasonId ?? 0);
                          },
                          initialItemName: value.reasonController.text,
                        ),
                        // CustomTextFormField(
                        //   hintText: 'Select Reason',
                        //   controller: value.reasonController,
                        //   onTap: () => value.reasonsBottomSheet(),
                        //   readOnly: true,
                        //   validator: value.validator,
                        //   suffixWidget: const ImageIcon(
                        //     AssetImage('assets/images/dropdown_icon.png'),
                        //     color: AppColors.whiteColor,
                        //   ),
                        // ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          controller: value.remarksController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          maxLines: 3,
                          hintText: 'Remarks',
                          validator: value.validator,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                CustomAppButton(
                  buttonTitle: 'Save',
                  onTap: () => value.markUnverified(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
