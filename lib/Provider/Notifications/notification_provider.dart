import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/Notifications/notification_service.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationProvider with ChangeNotifier {
  List<Notifications>? notifications;
  NotificationGroup currentNotificationGroup = NotificationGroup.challan;

  // ScrollController? scrollController;
  // TabController? controller;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setNotificationData(NotificationResponse response) {
    notifications = response.notifications?.reversed.toList();
    notifyListeners();
  }

  Future<void> loadURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // void initializeData(TickerProvider tickerProvider) {
  //   controller = TabController(length: 2, vsync: tickerProvider);
  // }

  Future<NotificationResponse> loadNotificationData(
    NotificationGroup group,
  ) async {
    try {
      currentNotificationGroup = group;
      NotificationResponse response =
          await NotificationService.notificationRequest(
            token: localDataProvider.userData!.tokenId!,
            userName: localDataProvider.studentId,
            group: group.groupId,
          );
      setNotificationData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    notifications = null;
    currentNotificationGroup = NotificationGroup.challan;
    notifyListeners();
  }
}

enum NotificationGroup {
  challan('1'),
  library('2'),
  circulars('3');

  final String groupId; // custom field

  const NotificationGroup(this.groupId); // const constructor
}
