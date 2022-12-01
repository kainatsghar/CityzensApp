import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class PreviousSchoolFrom extends StatelessWidget {
  const PreviousSchoolFrom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OSRegistrationProvider>(
        builder: (context, value, child) => Form(
                child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomTextFormField(
                      isDense: true,
                      controller: value.previousSchoolNameController,
                      labelText: 'School Name',
                      validator: HelperFunction.validator,
                      inputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words)),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.schoolLocationController,
                  labelText: 'School Location',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.studiedFromClassController,
                  labelText: 'Studied From Class',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.studiedToClassController,
                  labelText: 'Studied To Class',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  maxLines: 3,
                  controller: value.leavingRxnController,
                  labelText: 'Reason For Leaving',
                  validator: HelperFunction.validator,
                  inputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words),
            ])));
  }
}
