// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field_v2.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../Utils/app_colors.dart';

class IndividualEducationPlanComponent extends StatelessWidget {
  const IndividualEducationPlanComponent({super.key});

  // AcademicTermComponent({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<ResultsProvider>(builder: (context, value, _) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
                key: value.formKey,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  //const CustomLogoCover(),
                  const CustomCoverImage(
                      title: 'INDIVIDUAL\nEDUCATION PLAN',
                      imagePath: 'planner.png'),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10.0),
                    child: Column(
                      children: [
                        CustomTextFormFieldv2(
                            hintText: 'Academic Year'.toUpperCase(),
                            controller: value.academicYearController,
                            onTap: () => value.academicYearBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.primaryDarkColor)),
                        SizedBox(height: size.height * 0.01),
                        CustomTextFormFieldv2(
                            hintText: 'Term'.toUpperCase(),
                            controller: value.termController,
                            onTap: () => value.termBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.primaryDarkColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  // if (value.termSelected &&
                  //     value.resultsResponse.pdfResultslist?.isNotEmpty ==
                  //         true &&
                  //     value.resultsResponse.pdfResultslist![0].url != null)
                  GestureDetector(
                    onTap: () {
                      // Add logic to download PDF here
                    },
                    child: GestureDetector(
                      onTap: () {
                        //Handle null URL case using null-aware operator
                        String url =
                            value.resultsResponse.pdfResultslist![0].url!;
                        value.launchFile(url);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomAppButton(
                              buttonTitle: 'DOWNLOAD IEP',
                              onTap: () => {},
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomAppButton(
                              buttonTitle: 'ACHKOWLEDGE\nIEP/UNDERTAKING',
                              onTap: () => {},
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  )
                  // else
                  //   const ShowCustomMessage(message: AppConstants.noRecordFound)
                ]))));
      }),
    );
  }
}
