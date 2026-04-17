import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/FeeChallanComponents/single_receipt_item.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/utils/app_constants.dart';

class ReceiptFeeComponent extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const ReceiptFeeComponent({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeChallanProvider>(
      builder: (context, value, _) {
        // Loading state
        if (value.isLoading && value.challanReceiptResponse == null) {
          return const CustomLoader();
        }

        // Error state
        if (value.loadError != null && value.challanReceiptResponse == null) {
          return ShowError(errorText: value.loadError!);
        }

        final responseData = value.challanReceiptResponse?.receiptList;

        if (responseData == null || responseData.isEmpty) {
          return const ShowCustomMessage(
            message: AppConstants.noRecordFound,
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: responseData.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return value.challanReceiptResponse!.info == null
                    ? const SizedBox.shrink()
                    : CustomStudentInfo(
                        info: value.challanReceiptResponse!.info,
                      );
              }

              final recordIndex = index - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleReceiptItem(
                  record: responseData[recordIndex],
                  index: recordIndex,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
