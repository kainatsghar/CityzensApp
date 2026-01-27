import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/NotificationComponents/notification_component.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ChallanNotificationScreen extends StatefulWidget {
  const ChallanNotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChallanNotificationScreenState();
  }
}

class ChallanNotificationScreenState extends State<ChallanNotificationScreen> {
  late Future _notificationService;

  var provider = Provider.of<NotificationProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _notificationService = provider.loadNotificationData(
      NotificationGroup.challan,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _notificationService,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CustomLoader();
          default:
            if (snapshot.hasData) {
              return const NotificationComponent();
            } else {
              return ShowError(errorText: '${snapshot.error}');
            }
        }
      },
    );
  }
}
