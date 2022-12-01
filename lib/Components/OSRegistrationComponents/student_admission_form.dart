import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class StudentAdmissionForm extends StatelessWidget {
  const StudentAdmissionForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OSRegistrationProvider>(
        builder: (context, value, child) => Form(
                child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('When is admission required?',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  )),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.sessionController,
                  hintText: 'Session',
                  readOnly: true,
                  validator: HelperFunction.validator,
                  onTap: () => value.sessionBottomSheet(),
                  suffixWidget:
                      ImageIcon(AssetImage('images/dropdown_icon.png'))),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.cityController,
                  hintText: 'City',
                  readOnly: true,
                  validator: HelperFunction.validator,
                  onTap: () => value.citiesBottomSheet(),
                  suffixWidget:
                      ImageIcon(AssetImage('images/dropdown_icon.png'))),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Select your desired campus',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.campusController,
                  isEnable: value.selectedCityId == null ? false : true,
                  hintText: 'Campus',
                  readOnly: true,
                  validator: HelperFunction.validator,
                  onTap: () => value.loadCityCampus(),
                  suffixWidget:
                      ImageIcon(AssetImage('images/dropdown_icon.png'))),
              SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('To which class admission is required?',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54))),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.classController,
                  isEnable: value.selectedCampusId == null ? false : true,
                  hintText: 'Class',
                  readOnly: true,
                  validator: HelperFunction.validator,
                  onTap: () => value.loadCampusClass(),
                  suffixWidget:
                      ImageIcon(AssetImage('images/dropdown_icon.png'))),
              SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Registration Fee Payable: Rs 600-750.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor)),
                        TextSpan(
                            text:
                                ' Bank convenience fee will be charged on card payments.')
                      ],
                    ),
                  )),
              SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Has the child attended any school before?',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54))),
              SizedBox(height: 12),
              CustomTextFormField(
                  isDense: true,
                  controller: value.previousSchoolController,
                  hintText: 'Select',
                  readOnly: true,
                  validator: HelperFunction.validator,
                  onTap: () => value.previousSchoolBottomSheet(),
                  suffixWidget:
                      ImageIcon(AssetImage('images/dropdown_icon.png'))),
            ])));
  }
}
