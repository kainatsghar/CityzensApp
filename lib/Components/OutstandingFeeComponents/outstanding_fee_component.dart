import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/OutstandingFeeComponents/single_challan_item.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
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
            responseData.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
          }
          return responseData == null || responseData.isEmpty
              ? ShowMessageOnImage(
                  message: 'No Pending Challan. \nCheck back later!',
                  imagePath: Assets.images.bgCircularColored.path,
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            value.outstandingChallans!.outstandingList!.length +
                            1,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return value.outstandingChallans!.info == null
                                ? const SizedBox.shrink()
                                : CustomStudentInfo(
                                    info: value.outstandingChallans!.info,
                                  );
                          } else {
                            index -= 1;
                            return SingleChallanItem(
                              record: responseData[index],
                            );
                          }
                        },
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.symmetric(vertical: 16.0),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.secondaryColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Payment By Due Date',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                // color: Colors.white,
                              ),
                            ),
                            Text(
                              'PKR ${responseData.fold<double>(0, (sum, item) => (sum + item.outstandingFee!))}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                // color: Colors.white,
                              ),
                            ),
                            CustomAppButton(
                              buttonTitle: 'Pay Now',
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.challanPaymentRoute,
                              ),
                            ),
                          ],
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
