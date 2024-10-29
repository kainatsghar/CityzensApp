import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/NotificationComponents/notification_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class LibraryNotificationScreen extends StatefulWidget {
  const LibraryNotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LibraryNotificationScreenState();
  }
}

class LibraryNotificationScreenState extends State<LibraryNotificationScreen> {
  late Future _notificationService;

  var provider = Provider.of<NotificationProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    _notificationService = provider.loadNotificationData('2');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
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
            }),
        onRefresh: () => provider.loadNotificationData('2'));
  }
}
