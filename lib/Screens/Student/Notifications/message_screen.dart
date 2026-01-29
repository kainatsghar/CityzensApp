import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/NotificationComponents/notification_component.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MessageScreenState();
  }
}

class MessageScreenState extends State<MessageScreen> {
  late Future _notificationService;

  var provider = Provider.of<NotificationProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _notificationService = provider.loadNotificationData(
      NotificationGroup.circulars,
    );
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
        },
      ),
      onRefresh: () =>
          provider.loadNotificationData(NotificationGroup.circulars),
    );
  }
}
