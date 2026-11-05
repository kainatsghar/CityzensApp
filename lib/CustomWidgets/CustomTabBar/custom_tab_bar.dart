import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

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

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) => [
        SliverAppBar(
          floating: true,
          pinned: true,
          forceElevated: boxIsScrolled,
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: AppColors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            appBarTitle ?? '',
            style: AppThemes.sora(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 38,
                width: 38,
                child: Image.asset('assets/images/tcs_logo.png'),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.yellow,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.72),
            labelStyle: AppThemes.sora(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: AppThemes.sora(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            controller: controller,
            tabs: tabs!,
            indicatorColor: AppColors.yellow,
            indicatorWeight: 3,
          ),
        ),
      ],
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: widgets!,
        ),
      ),
    );
  }
}
