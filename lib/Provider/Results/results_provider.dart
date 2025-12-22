import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/AcademicTerm/academic_term_service.dart';
import 'package:tcs_app/Services/Results/result_service.dart';
import 'package:tcs_app/model/AcademicTerm/academic_term_response.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/Results/results_response.dart';

class ResultsProvider with ChangeNotifier {
  final academicYearController = TextEditingController(); //
  final termController = TextEditingController();
  int selectAcademicYear = 0, selectedTerm = 0;
  final formKey = GlobalKey<FormState>(); //
  TabController? controller;
  ScrollController? scrollController;

  List<EyeResult> eyeResult = [];
  List<AcademicTerm> academicYears = [];
  List<AcademicTerm> terms = [];

  bool termSelected = false;
  String url = "";

  ResultsResponse resultsResponse = ResultsResponse();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setSelectedAcademicYear(String v) {
    selectAcademicYear = academicYears.singleWhere((e) => e.name == v).id!;
    academicYearController.text = v;
    AppNavigation.goBack();
    notifyListeners();
  }

  void setEyeResultResponse(Map eyeData) {
    eyeResult = eyeData.entries
        .map(
          (entry) => EyeResult(
            entry.key,
            List.generate(
              entry.value.length,
              (i) => SubjectDetails.fromJson(entry.value[i]),
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  void setSelectedTerm(String v) {
    selectedTerm = terms.singleWhere((e) => e.name == v).id!;
    termController.text = v;
    termSelected = true;
    AppNavigation.goBack();
    notifyListeners();
  }

  void initializeData(TickerProvider tickerProvider) {
    controller = TabController(length: 2, vsync: tickerProvider);
  }

  Future<AcademicTermResponse> loadAcademicTerm() async {
    try {
      AcademicTermResponse response =
          await AcademicTermService.academicTermRequest(
            userName: localDataProvider.studentId,
            token: localDataProvider.userData!.tokenId!,
          );
      setResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<dynamic> loadResults() async {
    try {
      var response = await ResultService.resultsRequest(
        userName: localDataProvider.studentId,
        token: localDataProvider.userData!.tokenId!,
        academicYearId: selectAcademicYear,
        termId: selectedTerm,
      );
      setResultsResponse(ResultsResponse.fromJson(response));
      setEyeResultResponse(response['EyeResult']);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setResultsResponse(ResultsResponse response) {
    resultsResponse = response;
    //url = response.pdfResultslist![0].url!;
    notifyListeners();
  }

  void setResponse(AcademicTermResponse? listResponse) {
    terms = listResponse?.term ?? [];
    academicYears = listResponse?.session ?? [];
    notifyListeners();
  }

  void academicYearBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Academic Years',
        controller: academicYearController,
        filterOptions: List.generate(
          academicYears.length,
          (i) =>
              Options(title: academicYears[i].name, value: academicYears[i].id),
        ),
        onSelect: (v) => setSelectedAcademicYear(v),
      ),
    );
  }

  // void termBottomSheet() {
  //   showModalBottomSheet(
  //       context: AppNavigation.currentContext!,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext bc) => CustomFilterBottomSheet(
  //           title: 'Terms',
  //           controller: termController,
  //           filterOptions: List.generate(terms.length,
  //               (i) => Options(title: terms[i].name, value: terms[i].id)),
  //           onSelect: (v) => setSelectedTerm(v)));
  //   navigateToResults();
  // }

  void termBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Terms',
        controller: termController,
        filterOptions: List.generate(
          terms.length,
          (i) => Options(title: terms[i].name, value: terms[i].id),
        ),
        onSelect: (v) {
          setSelectedTerm(v);
          loadResults(); // Call the API when a term is selected
        },
      ),
    );
  }

  Future<void> navigateToResults() async {
    //
    if (formKey.currentState!.validate()) {
      FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.resultsRoute);
    }
  }

  void clearData() {
    selectedTerm = 0;
    selectAcademicYear = 0;
    academicYearController.clear();
    termController.clear();
    terms = [];
    academicYears = [];
    termSelected = false;
  }
}
