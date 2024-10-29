import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class GuardianInfoForm extends StatelessWidget {
  const GuardianInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OSRegistrationProvider>(
        builder: (context, value, child) => Form(
                child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomTextFormField(
                      isDense: true,
                      controller: value.genderController,
                      labelText: 'Father’s/Guardian’s Name',
                      validator: HelperFunction.validator,
                      inputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words)),
              const SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.fatherCNICController,
                  labelText: 'Father’s/Guardian’s CNIC No',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              const SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.fatherOccupationController,
                  labelText: 'Father’s/Guardian’s Occupation',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              const SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.mobileNumberController,
                  labelText: 'Father’s/Guardian’s Mobile Number',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                  inputType: TextInputType.number),
              const SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.emailAddressController,
                  labelText: 'Father’s/Guardian’s Email Address',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress),
            ])));
  }
}
