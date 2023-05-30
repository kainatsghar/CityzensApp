import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomTabBar extends StatelessWidget {
  final ScrollController scrollController;
  final List<Tab> tabs;
  final TabController controller;
  final List<Widget> widgets;
  final String appBarTitle;

  const CustomTabBar(
      {Key key,
      this.appBarTitle,
      this.scrollController,
      this.tabs,
      this.controller,
      this.widgets})
      : super(key: key);

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
                  backgroundColor: AppColors.whiteColor,
                  title: Text(appBarTitle,
                      style: TextStyle(
                          fontSize: 18.0, color: AppColors.primaryTitleColor)),
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/tcs_logo.png'))
                  ],
                  bottom: TabBar(
                      labelColor: AppColors.primaryTitleColor,
                      controller: controller,
                      unselectedLabelColor: AppColors.primaryTitleColor,
                      tabs: tabs,
                      indicatorColor: AppColors.secondaryColor))
            ],
        body: MediaQuery.removePadding(
            removeTop: true,
            child: TabBarView(
                controller: controller,
                children: widgets,
                physics: NeverScrollableScrollPhysics()),
            context: context));
  }
}
