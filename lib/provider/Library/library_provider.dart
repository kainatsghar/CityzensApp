import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/Library/library_service.dart';
import 'package:tcs_app/model/Library/library_response.dart';

class LibraryProvider with ChangeNotifier {
  final Map<String, LibraryResponse> _libraryResponseCache = {};

  LibraryResponse? get libraryResponse =>
      _libraryResponseCache[localDataProvider.studentId];

  set libraryResponse(LibraryResponse? val) {
    if (val != null) {
      _libraryResponseCache[localDataProvider.studentId] = val;
    } else {
      _libraryResponseCache.remove(localDataProvider.studentId);
    }
  }

  ScrollController? scrollController;
  TabController? tabController;

  // Loading state for unified data fetch
  bool isLoading = true;
  String? loadError;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void initializeData(TickerProvider tickerProvider) {
    tabController = TabController(length: 2, vsync: tickerProvider);
  }

  void setLibraryData(LibraryResponse response) {
    libraryResponse = response;
    notifyListeners();
  }

  /// Loads both Library records AND library notifications concurrently.
  /// Called once on init and again on pull-to-refresh from any tab.
  Future<void> loadAllData({bool forceRefresh = false}) async {
    if (!forceRefresh && libraryResponse != null) {
      return;
    }

    isLoading = true;
    loadError = null;
    notifyListeners();

    final notificationProvider = Provider.of<NotificationProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );

    try {
      await Future.wait([
        loadLibraryRecords(),
        notificationProvider.loadNotificationData(NotificationGroup.library),
      ]);
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<LibraryResponse> loadLibraryRecords() async {
    try {
      LibraryResponse response = await LibraryService.libraryRequest(
        token: localDataProvider.userData!.tokenId!,
        userName: localDataProvider.studentId,
      );
      setLibraryData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    _libraryResponseCache.clear();
    isLoading = true;
    loadError = null;
  }
}
