import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/MultiChild/multi_child_service.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';

class ParentDashboardProvider with ChangeNotifier {
  MultiChildResponse? multiChildResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setMultiChildData(MultiChildResponse response) {
    multiChildResponse = response;
    notifyListeners();
  }

  Future<MultiChildResponse> loadMultiChildData() async {
    try {
      MultiChildResponse response = await MultiChildService.multiChildRequest(
        token: localDataProvider.userData!.tokenId!,
        userName: '${localDataProvider.userData!.id}',
      );
      setMultiChildData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }
}
