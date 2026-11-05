import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/citizen/Screens/Student/Feechallans/outstanding_fee_screen.dart';
import 'package:tcs_app/citizen/Screens/Student/Feechallans/receipt_fee_screen.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class FeeChallanScreen extends StatefulWidget {
  const FeeChallanScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeeChallanScreenState();
  }
}

class FeeChallanScreenState extends State<FeeChallanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  FeeChallanProvider get provider =>
      Provider.of<FeeChallanProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    provider.controller = _tabController;
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // S9 Blue Header with Integrated Segmented Switch
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Fees',
                          style: AppThemes.sora(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Segmented Tabs: Outstanding & Receipts
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _tabController.animateTo(0),
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _tabController.index == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                'Outstanding',
                                style: AppThemes.sora(
                                  fontSize: 13,
                                  fontWeight: _tabController.index == 0
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: _tabController.index == 0
                                      ? AppColors.blue
                                      : Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: InkWell(
                            onTap: () => _tabController.animateTo(1),
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _tabController.index == 1
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                'Receipts',
                                style: AppThemes.sora(
                                  fontSize: 13,
                                  fontWeight: _tabController.index == 1
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: _tabController.index == 1
                                      ? AppColors.blue
                                      : Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // S9 Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                OutstandingFeeScreen(),
                ReceiptFeeScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
