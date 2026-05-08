import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/FeeChallanComponents/single_challan_item.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/routes/challan_args.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class OutstandingFeeComponent extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const OutstandingFeeComponent({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FeeChallanProvider, StudentDashboardProvider>(
      builder: (context, value, dashboardProvider, _) {
        // Loading state
        if (value.isLoading && value.outstandingChallans == null) {
          return const CustomLoader();
        }

        // Error state
        if (value.loadError != null && value.outstandingChallans == null) {
          return ShowError(errorText: value.loadError!);
        }

        // Data loaded
        var responseData = value.outstandingChallans?.outstandingList;

        // Sort by issue date descending (newest first)
        if (responseData != null && responseData.isNotEmpty) {
          responseData.sort((a, b) => b.issueDate!.compareTo(a.issueDate!));
        }

        // Empty state
        if (responseData == null || responseData.isEmpty) {
          return ShowMessageOnImage(
            message: 'No Pending Challan. \nCheck back later!',
            imagePath: Assets.images.bgCircularColored.path,
          );
        }

        final studentInfo = value.outstandingChallans!.info!;

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh ?? () async {},
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Student info header ──
                      if (value.outstandingChallans!.info != null)
                        Builder(
                          builder: (context) {
                            final apiInfo = value.outstandingChallans!.info;
                            final profile = dashboardProvider
                                .activeChildData?.profile?.profile?.firstOrNull;

                            if (apiInfo?.className == null && profile != null) {
                              final fallbackInfo = {
                                'rollNo': profile.studentId,
                                'name': profile.name,
                                'className': profile.className,
                                'centerName': profile.center,
                              };
                              return CustomStudentInfo(
                                info: _FeeInfoWrapper(fallbackInfo),
                              );
                            }
                            return CustomStudentInfo(info: apiInfo);
                          },
                        ),

                      // ── Challan card & surcharge note ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SingleChallanItem(
                              record: responseData.first,
                              arrearMonths: responseData.length > 1
                                  ? responseData.sublist(1)
                                  : null,
                              studentInfo: studentInfo,
                            ),
                            const SizedBox(height: 4),
                            _buildSurchargeNotice(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Sticky Pay Now button ──
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: CustomAppButton(
                  buttonTitle: 'Pay Now',
                  onTap: () => AppNavigation.navigateTo(
                    AppNavRoutes.challanPaymentRoute,
                    arguments: ChallanArgs(
                      fatherCnic: studentInfo.fatherCnic!,
                      studentId: studentInfo.rollNo!.toString(),
                      primaryContactNo: studentInfo.primaryContactNo!,
                      isNewPaymentFlowEnabled: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSurchargeNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningOrange.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.warningOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Late payment surcharge @Rs 50/- per day (to be calculated and charged by the bank)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeInfoWrapper {
  final Map<String, dynamic> _data;
  _FeeInfoWrapper(this._data);

  get rollNo => _data['rollNo'];
  get name => _data['name'];
  get className => _data['className'];
  get centerName => _data['centerName'];
}
