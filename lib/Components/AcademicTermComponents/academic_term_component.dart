import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class AcademicTermComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<ResultsProvider>(builder: (context, value, _) {
        return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
                key: value.formKey,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Image.asset('images/tcs_logo.png',
                      height: size.width * 0.4, width: size.width * 0.4),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Academic Year',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      )),
                  CustomTextFormField(
                      hintText: 'Select',
                      controller: value.academicYearController,
                      onTap: () => value.academicYearBottomSheet(),
                      readOnly: true,
                      validator: HelperFunction.validator,
                      suffixWidget:  ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Term',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      )),
                  CustomTextFormField(
                      hintText: 'Select',
                      controller: value.termController,
                      onTap: () => value.termBottomSheet(),
                      readOnly: true,
                      validator: HelperFunction.validator,
                      suffixWidget: ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  SizedBox(height: size.height * 0.04),
                  CustomAppButton(
                      buttonTitle: 'Next',
                      onTap: () => value.navigateToResults())
                ]))));
      }),
    );
  }
}
