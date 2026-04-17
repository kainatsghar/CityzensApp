import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/Splash/splash_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/FeeChallan/feechallan_service.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

class FeeChallanProvider with ChangeNotifier {
  ScrollController? scrollController;
  TabController? controller;
  OutstandingChallanResponse? outstandingChallans;
  ChallanReceiptResponse? challanReceiptResponse;

  // Loading state for unified data fetch
  bool isLoading = true;
  String? loadError;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  final splashProvider = Provider.of<SplashProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void initializeData(TickerProvider tickerProvider) {
    controller = TabController(length: 2, vsync: tickerProvider);
  }

  void setOutstandingChallanData(OutstandingChallanResponse response) {
    outstandingChallans = response;
    notifyListeners();
  }

  void setChallanReceiptsData(ChallanReceiptResponse response) {
    challanReceiptResponse = response;
    notifyListeners();
  }

  /// Loads both Outstanding and Receipts data concurrently.
  /// Called once on init and again on pull-to-refresh from any tab.
  Future<void> loadAllData() async {
    isLoading = true;
    loadError = null;
    notifyListeners();

    try {
      await Future.wait([
        loadOutstandingRecords(),
        loadReceiptRecords(),
      ]);
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<OutstandingChallanResponse> loadOutstandingRecords() async {
    try {
      OutstandingChallanResponse response =
          await FeeChallanService.outStandingChallanRequest(
            // token: localDataProvider.userData.tokenId,
            token: localDataProvider.userData!.tokenId ?? '',
            userName: localDataProvider.studentId,
          );

      setOutstandingChallanData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<ChallanReceiptResponse> loadReceiptRecords() async {
    try {
      ChallanReceiptResponse response =
          await FeeChallanService.challanReceiptRequest(
            token: localDataProvider.userData!.tokenId,
            userName: localDataProvider.studentId,
          );
      setChallanReceiptsData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }
}
