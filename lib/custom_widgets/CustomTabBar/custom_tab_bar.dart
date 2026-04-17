import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// Modern segmented tab bar — iOS-style pill selector with
/// smooth animated indicator, compact sizing, and zero overflow.
class CustomTabBar extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Tab>? tabs;
  final TabController? controller;
  final List<Widget>? widgets;
  final String? appBarTitle;

  const CustomTabBar({
    super.key,
    this.appBarTitle,
    this.scrollController,
    this.tabs,
    this.controller,
    this.widgets,
  });

  // ── Height Math (must be exact to avoid overflow) ──
  // Flutter Tab default = 46px, indicatorWeight = 2px,
  // container padding: 3*2=6, container margin: 4*2=8 → total = 62
  static const double _containerPadding = 3.0;
  static const double _containerMarginV = 4.0;
  // 46 (tab) + 2 (indicator) + 6 (padding) + 8 (margin) = 62
  static const double _bottomHeight = 62.0;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) => [
        SliverAppBar(
          floating: true,
          pinned: true,
          forceElevated: false,
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.whiteColor,
          title: Text(
            appBarTitle ?? '',
            style: const TextStyle(
              fontSize: 18.0,
              color: AppColors.primaryTitleColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 44,
                width: 44,
                child: Image.asset('assets/images/tcs_logo.png'),
              ),
            ),
          ],
          // ── Segmented Tab Selector ──
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(_bottomHeight),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: _containerMarginV,
              ),
              padding: const EdgeInsets.all(_containerPadding),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: controller,
                tabs: tabs ?? [],
                // ── Sizing ──
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                // ── Selected Tab ──
                labelColor: AppColors.whiteColor,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
                // ── Unselected Tab ──
                unselectedLabelColor: AppColors.primaryBlue.withOpacity(0.7),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
                // ── Active Indicator Pill ──
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: AppColors.primaryBlue,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 2,
                ),
              ),
            ),
          ),
        ),
      ],
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: widgets ?? [],
        ),
      ),
    );
  }
}
