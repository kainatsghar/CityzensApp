import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/Notifications/notification_service.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationProvider with ChangeNotifier {
  List<Notifications>? notifications;

  ScrollController? scrollController;
  TabController? controller;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(AppNavigation.currentContext!, listen: false);

  void setNotificationData(NotificationResponse response) {
    notifications = response.notifications;
    notifyListeners();
  }

  Future<void> loadURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void initializeData(TickerProvider tickerProvider) {
    controller = TabController(length: 3, vsync: tickerProvider);
  }

  Future<NotificationResponse> loadNotificationData(String group) async {
    try {
      NotificationResponse response = await NotificationService.notificationRequest(token: localDataProvider.userData!.tokenId!, userName: localDataProvider.studentId, group: group);
      setNotificationData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }
}
