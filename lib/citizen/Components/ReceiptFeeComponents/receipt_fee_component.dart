import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/citizen/Model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/citizen/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class ReceiptFeeComponent extends StatelessWidget {
  const ReceiptFeeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeChallanProvider>(
      builder: (context, value, _) {
        final List<FeechallanHistory>? responseData =
            value.challanReceiptResponse?.receiptList;

        if (responseData == null || responseData.isEmpty) {
          return const Center(
            child: ShowCustomMessage(message: AppConstants.noRecordFound),
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // S9 Header Label
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 10),
                child: Text(
                  'PAID RECEIPTS',
                  style: AppThemes.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.blue,
                  ),
                ),
              ),

              // Receipts List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: responseData.length,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final FeechallanHistory record = responseData[index];
                  return _buildReceiptCard(record);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceiptCard(FeechallanHistory record) {
    final String paidDate =
        record.receiptDate != null && record.receiptDate!.isNotEmpty
            ? HelperFunction.dateFormatter(record.receiptDate!)
            : '—';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 52, 102, 0.06),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color(0xFF0E8A5F),
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Period + Date & Amount + Paid Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.periodName ?? 'Receipt',
                        style: AppThemes.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Paid on $paidDate',
                        style: AppThemes.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      HelperFunction().formatCurrency(record.amount ?? 0.0),
                      style: AppThemes.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF3EA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'PAID',
                        style: AppThemes.sora(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: const Color(0xFF0E8A5F),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 2: Receipt Number & Entry Type
            Container(
              padding: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFEEF1F5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Receipt ',
                      style: AppThemes.roboto(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                      children: [
                        TextSpan(
                          text: record.receiptNo ?? '—',
                          style: AppThemes.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    record.challanType ?? 'Periodic Billing',
                    style: AppThemes.roboto(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
