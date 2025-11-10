import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/OutstandingFeeComponents/single_challan_item.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/challan_args.dart';
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
            responseData.sort((a, b) => b.issueDate!.compareTo(a.issueDate!));
          }
          return responseData == null || responseData.isEmpty
              ? ShowMessageOnImage(
                  message: 'No Pending Challan. \nCheck back later!',
                  imagePath: Assets.images.bgCircularColored.path,
                )
              : ListView(
                  children: [
                    value.outstandingChallans!.info == null
                        ? const SizedBox.shrink()
                        : CustomStudentInfo(
                            info: value.outstandingChallans!.info,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SingleChallanItem(
                            record: responseData.first,
                            arearMonths: responseData.length > 1
                                ? responseData.sublist(1).map((e) => e).toList()
                                : null,
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton.filled(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: responseData.first.challanNo!,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                  },
                                  icon: Row(
                                    children: [
                                      const Icon(Icons.copy),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'Challan No',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            '100827${responseData.first.challanNo!}',
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                  },
                                  icon: Row(
                                    children: [
                                      const Icon(Icons.copy),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'For 1Link',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            '${value.outstandingChallans!.info!.centerName == 'C052-(TCS) Bahria Town Campus' ? '1003330241' : '1003330195'}${responseData.first.challanNo!}',
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                  },
                                  icon: Row(
                                    children: [
                                      const Icon(Icons.copy),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'For 1Bill',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            CustomAppButton(
                              buttonTitle: 'Pay Now',
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.challanPaymentRoute,
                                arguments: ChallanArgs(
                                  fatherCnic: value
                                      .outstandingChallans!
                                      .info!
                                      .fatherCnic!,
                                  studentId: value
                                      .outstandingChallans!
                                      .info!
                                      .rollNo!
                                      .toString(),
                                  primaryContactNo: value
                                      .outstandingChallans!
                                      .info!
                                      .primaryContactNo!,
                                ),
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
