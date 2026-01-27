import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field_v2.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';

class AcademicTermComponent extends StatelessWidget {
  const AcademicTermComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: value.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //const CustomLogoCover(),
                    const CustomCoverImage(
                      title: 'RESULTS',
                      imagePath: 'class_result_c.png',
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          CustomTextFormFieldV2(
                            hintText: 'Academic Year'.toUpperCase(),
                            controller: value.academicYearController,
                            onTap: () => value.academicYearBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                              AssetImage('assets/images/dropdown_icon.png'),
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          CustomTextFormFieldV2(
                            hintText: 'Term'.toUpperCase(),
                            controller: value.termController,
                            onTap: () => value.termBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                              AssetImage('assets/images/dropdown_icon.png'),
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    if (value.termSelected &&
                        value.resultsResponse.pdfResultslist?.isNotEmpty ==
                            true &&
                        value.resultsResponse.pdfResultslist![0].url != null)
                      GestureDetector(
                        onTap: () {
                          //Handle null URL case using null-aware operator
                          String url =
                              value.resultsResponse.pdfResultslist![0].url!;
                          HelperFunction.launchURL(url);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/pdf_download_icon.png',
                              width: 100, // adjust width as needed
                              height: 100, // adjust height as needed
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'CLICK TO VIEW RESULT',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const ShowCustomMessage(
                        message: AppConstants.noRecordFound,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
