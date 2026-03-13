import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/OutstandingFeeComponents/single_challan_item.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/routes/challan_args.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class OutstandingFeeComponent extends StatelessWidget {
  const OutstandingFeeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FeeChallanProvider>(
        builder: (context, value, _) {
          var responseData = value.outstandingChallans!.outstandingList;
          if (responseData != null && responseData.isNotEmpty) {
            responseData.sort((a, b) => b.issueDate!.compareTo(a.issueDate!));
          }
          return responseData == null || responseData.isEmpty
              ? ShowMessageOnImage(
                  message: 'No Pending Challan. \nCheck back later!',
                  imagePath: Assets.images.bgCircularColored.path,
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            value.outstandingChallans!.info == null
                                ? const SizedBox.shrink()
                                : CustomStudentInfo(
                                    info: value.outstandingChallans!.info,
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                children: [
                                  SingleChallanItem(
                                    record: responseData.first,
                                    arearMonths: responseData.length > 1
                                        ? responseData
                                              .sublist(1)
                                              .map((e) => e)
                                              .toList()
                                        : null,
                                    studentInfo:
                                        value.outstandingChallans!.info!,
                                  ),
                                  SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info,
                                          size: 16.0,
                                          color: AppColors.primaryTitleColor,
                                        ),
                                        SizedBox(width: 4.0),
                                        Expanded(
                                          child: Text(
                                            'Late payment surcharge @Rs 50/- per day (to be calculated and charged by the bank)',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                              // color: AppColors.primaryTitleColor,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: CustomAppButton(
                        buttonTitle: 'Pay Now',
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.challanPaymentRoute,
                          arguments: ChallanArgs(
                            fatherCnic:
                                value.outstandingChallans!.info!.fatherCnic!,
                            studentId: value.outstandingChallans!.info!.rollNo!
                                .toString(),
                            primaryContactNo: value
                                .outstandingChallans!
                                .info!
                                .primaryContactNo!,
                            isNewPaymentFlowEnabled:
                                value.isNewPaymentFlowEnabled,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
