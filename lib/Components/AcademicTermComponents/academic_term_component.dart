import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../Utils/app_colors.dart';

class AcademicTermComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<ResultsProvider>(builder: (context, value, _) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Form(
                key: value.formKey,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Image.asset('images/logo_cover.png',
                      fit: BoxFit.fitWidth,
                      height: size.height * 0.18,
                      width: size.width * 0.5),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
                    decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: [
                        CustomTextFormField(
                            hintText: 'Academic Year',
                            controller: value.academicYearController,
                            onTap: () => value.academicYearBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.whiteColor)),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                            hintText: 'Term',
                            controller: value.termController,
                            onTap: () => value.termBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.whiteColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomAppButton(
                      buttonTitle: 'Next',
                      onTap: () => value.navigateToResults())
                ]))));
      }),
    );
  }
}
