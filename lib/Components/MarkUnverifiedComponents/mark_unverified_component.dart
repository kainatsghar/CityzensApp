import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../Provider/MarkUnverified/mark_unverified_provider.dart';
import '../../Utils/app_colors.dart';

class MarkUnverifiedComponent extends StatelessWidget {
  const MarkUnverifiedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Consumer<MarkUnverifiedProvider>(
        builder: (context, value, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                CustomCard(
                  child: Form(
                    key: value.formKey,
                    child: Column(
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
                        CustomTextFormField(
                          hintText: 'Select Section',
                          controller: value.sectionController,
                          onTap: () => value.sectionBottomSheet(),
                          readOnly: true,
                          validator: value.validator,
                          suffixWidget: const ImageIcon(
                            AssetImage('assets/images/dropdown_icon.png'),
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          hintText: 'Select Reason',
                          controller: value.reasonController,
                          onTap: () => value.reasonsBottomSheet(),
                          readOnly: true,
                          validator: value.validator,
                          suffixWidget: const ImageIcon(
                            AssetImage('assets/images/dropdown_icon.png'),
                            color: AppColors.whiteColor,
                          ),
                        ),
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
