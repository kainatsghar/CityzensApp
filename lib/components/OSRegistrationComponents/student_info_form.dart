import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/utils/helper_function.dart';

class StudentInfoForm extends StatelessWidget {
  const StudentInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OSRegistrationProvider>(
      builder: (context, value, child) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: value.formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextFormField(
                  isDense: true,
                  controller: value.nameController,
                  labelText: 'First Name',
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                isDense: true,
                controller: value.lastNameController,
                labelText: 'Last Name',
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ],
                validator: HelperFunction.validator,
                inputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                isDense: true,
                controller: value.genderController,
                hintText: 'Gender',
                readOnly: true,
                validator: HelperFunction.validator,
                onTap: () => value.genderBottomSheet(),
                suffixWidget: const ImageIcon(
                  AssetImage('assets/images/dropdown_icon.png'),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: value.dobController,
                hintText: 'Date of Birth',
                readOnly: true,
                isDense: true,
                onTap: () => HelperFunction.openDatePicker(
                  filterDate: value.dobController,
                ),
                validator: HelperFunction.validator,
                suffixWidget: const Icon(Icons.calendar_month, size: 25),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: value.nationalityController,
                hintText: 'Nationality',
                readOnly: true,
                isDense: true,
                onTap: () => value.nationalityBottomSheet(),
                validator: HelperFunction.validator,
                suffixWidget: const ImageIcon(
                  AssetImage('assets/images/dropdown_icon.png'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
