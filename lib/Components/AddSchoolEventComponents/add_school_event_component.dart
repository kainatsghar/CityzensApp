import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/provider/SchoolEvents/school_event_provider.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper_function.dart';

class AddSchoolEventComponent extends StatefulWidget {
  const AddSchoolEventComponent({super.key});

  @override
  State<AddSchoolEventComponent> createState() =>
      _AddSchoolEventComponentState();
}

class _AddSchoolEventComponentState extends State<AddSchoolEventComponent> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2200),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<SchoolEventProvider>(
        builder: (context, value, _) {
          value.selectedDate = selectedDate;
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
                          hintText: HelperFunction.dateFormatter(
                            '$selectedDate',
                          ),
                          onTap: () => selectDate(context),
                          isEnable: true,
                          readOnly: true,
                          prefixIcon: Icons.date_range,
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          hintText: 'Event',
                          controller: value.eventController,
                          validator: HelperFunction.validator,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          hintText: 'Note (Optional)',
                          controller: value.noteController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                CustomAppButton(
                  buttonTitle: 'Save',
                  onTap: () => value.submitSchoolEvent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
