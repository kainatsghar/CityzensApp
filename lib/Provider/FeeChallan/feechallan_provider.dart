import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/FeeChallan/feechallan_service.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

class FeeChallanProvider with ChangeNotifier {
  ScrollController? scrollController;
  TabController? controller;
  OutstandingChallanResponse? outstandingChallans;
  ChallanReceiptResponse? challanReceiptResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(AppNavigation.currentContext!, listen: false);

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

  Future<OutstandingChallanResponse> loadOutstandingRecords() async {
    try {
      OutstandingChallanResponse response = await FeeChallanService.outStandingChallanRequest(
          // token: localDataProvider.userData.tokenId,
          token: localDataProvider.userData!.tokenId ?? '',
          userName: localDataProvider.studentId);
      setOutstandingChallanData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<ChallanReceiptResponse> loadReceiptRecords() async {
    try {
      ChallanReceiptResponse response = await FeeChallanService.challanReceiptRequest(
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
