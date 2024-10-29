import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

import 'challan_notification_screen.dart';
import 'library_notification_screen.dart';
import 'message_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  var provider = Provider.of<NotificationProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    provider.initializeData(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(builder: (context, value, _) {
        return CustomTabBar(
            scrollController: value.scrollController,
            appBarTitle: 'CIRCULARS',
            tabs: const [
              Tab(child: Text('MESSAGE')),
              Tab(child: Text('LIBRARY')),
              Tab(child: Text('CHALLAN'))
            ],
            widgets: const <Widget>[
              MessageScreen(),
              LibraryNotificationScreen(),
              ChallanNotificationScreen()
            ],
            controller: value.controller);
      }),
    );
  }
}
