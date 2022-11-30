import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/Library/library_service.dart';
import 'package:tcs_app/model/Library/library_response.dart';

class LibraryProvider with ChangeNotifier {
  LibraryResponse libraryResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext,
      listen: false);

  void setLibraryData(LibraryResponse response) {
    libraryResponse = response;
    notifyListeners();
  }

  Future<LibraryResponse> loadLibraryRecords() async {
    try {
      LibraryResponse response =
      await LibraryService.libraryRequest(
          token: localDataProvider.userData.tokenId,
          userName: localDataProvider.studentId);
      setLibraryData(response);
      return response;
    } catch (ex) {
      throw ex;
    }
  }
}