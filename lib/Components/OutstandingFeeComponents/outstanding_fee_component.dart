import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/OutstandingFeeComponents/single_challan_item.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class OutstandingFeeComponent extends StatelessWidget {
  const OutstandingFeeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FeeChallanProvider>(
        builder: (context, value, _) {
          var responseData = value.outstandingChallans!.outstandingList;
          return responseData == null || responseData.isEmpty
              ? ShowMessageOnImage(
                  message: 'No Pending Challan. \nCheck back later!',
                  imagePath: Assets.images.bgCircularColored.path,
                )
              : ListView.builder(
                  itemCount:
                      value.outstandingChallans!.outstandingList!.length + 1,
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
                      return SingleChallanItem(record: responseData[index]);
                    }
                  },
                );
        },
      ),
    );
  }
}
