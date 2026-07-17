import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/AcademicTerm/academic_term_service.dart';
import 'package:tcs_app/services/Results/result_pdf_cache_service.dart';
import 'package:tcs_app/services/Results/result_pdf_download_service.dart';
import 'package:tcs_app/services/Results/result_service.dart';
import 'package:tcs_app/model/AcademicTerm/academic_term_response.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/Results/results_response.dart';
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';

class ResultsProvider with ChangeNotifier {
  final academicYearController = TextEditingController(); //
  final termController = TextEditingController();
  final pdfClassFilterController = TextEditingController();
  int selectAcademicYear = 0, selectedTerm = 0;
  String? selectedPDFClassName;
  final formKey = GlobalKey<FormState>(); //
  TabController? controller;
  ScrollController? scrollController;

  List<EyeResult> eyeResult = [];
  List<AcademicTerm> academicYears = [];
  List<AcademicTerm> terms = [];

  bool termSelected = false;
  String url = "";

  ResultsResponse resultsResponse = ResultsResponse();
  AllPDFResultsResponse? allPDFResultsResponse;
  final Map<String, AllPDFResultsResponse> _allResultsCache = {};

  /// Cache keys currently on disk.
  final Set<String> downloadedPdfKeys = {};

  /// Cache keys currently downloading.
  final Set<String> downloadingPdfKeys = {};

  /// Last download error message per cache key (for RETRY UX).
  final Map<String, String> pdfDownloadErrors = {};

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

  void setSelectedPDFClassName(String v) {
    selectedPDFClassName = v;
    pdfClassFilterController.text = v;
    notifyListeners();
  }

  void initializeData(TickerProvider tickerProvider) {
    controller = TabController(length: 2, vsync: tickerProvider);
  }

  final Map<String, AcademicTermResponse> _termCache = {};

  Future<AcademicTermResponse> loadAcademicTerm({
    bool forceRefresh = false,
  }) async {
    final studentId = localDataProvider.studentId;

    if (!forceRefresh && _termCache.containsKey(studentId)) {
      final cachedResponse = _termCache[studentId]!;
      setResponse(cachedResponse);
      return cachedResponse;
    }

    try {
      AcademicTermResponse response =
          await AcademicTermService.academicTermRequest(
            userName: studentId,
            token: localDataProvider.userData!.tokenId!,
          );
      _termCache[studentId] = response;
      setResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  final Map<String, dynamic> _cachedResultsMap = {};

  Future<dynamic> loadResults({bool forceRefresh = false}) async {
    final cacheKey =
        '${localDataProvider.studentId}-$selectAcademicYear-$selectedTerm';

    if (!forceRefresh && _cachedResultsMap.containsKey(cacheKey)) {
      final cachedResponse = _cachedResultsMap[cacheKey];
      setResultsResponse(ResultsResponse.fromJson(cachedResponse));
      setEyeResultResponse(cachedResponse['EyeResult']);
      return cachedResponse;
    }

    try {
      var response = await ResultService.resultsRequest(
        userName: localDataProvider.studentId,
        token: localDataProvider.userData!.tokenId!,
        academicYearId: selectAcademicYear,
        termId: selectedTerm,
      );
      _cachedResultsMap[cacheKey] = response;
      setResultsResponse(ResultsResponse.fromJson(response));
      setEyeResultResponse(response['EyeResult']);
      await refreshDownloadedPdfKeys();
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<AllPDFResultsResponse> loadAllPDFResults({
    bool forceRefresh = false,
  }) async {
    final studentId = localDataProvider.studentId;

    if (!forceRefresh && _allResultsCache.containsKey(studentId)) {
      allPDFResultsResponse = _allResultsCache[studentId];
      await refreshDownloadedPdfKeys();
      Future.microtask(() => notifyListeners());
      return allPDFResultsResponse!;
    }

    try {
      var response = await ResultService.allPDFResultsRequest(
        studentId: studentId,
        token: localDataProvider.userData!.tokenId!,
      );
      final parsed = AllPDFResultsResponse.fromJson(response);
      _allResultsCache[studentId] = parsed;
      allPDFResultsResponse = parsed;
      await refreshDownloadedPdfKeys();
      notifyListeners();
      return parsed;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> refreshDownloadedPdfKeys() async {
    downloadedPdfKeys
      ..clear()
      ..addAll(await ResultPdfCacheService.downloadedKeys());
  }

  bool isPdfDownloaded(PDFResultItem item) =>
      downloadedPdfKeys.contains(ResultPdfCacheService.buildKey(item));

  bool isPdfDownloading(PDFResultItem item) =>
      downloadingPdfKeys.contains(ResultPdfCacheService.buildKey(item));

  String? pdfDownloadError(PDFResultItem item) =>
      pdfDownloadErrors[ResultPdfCacheService.buildKey(item)];

  /// Downloads the backend PDF (or reuses cache) then optionally opens it.
  ///
  /// Throws [NoServerPdfException] when the backend has no PDF for this result,
  /// so the caller can fall back to the system print flow. That case is not
  /// recorded as a download error.
  Future<SavedResultPdf?> downloadResultPdf(
    PDFResultItem item, {
    bool forceRedownload = false,
    bool openAfterDownload = true,
  }) async {
    final key = ResultPdfCacheService.buildKey(item);
    if (downloadingPdfKeys.contains(key)) return null;

    downloadingPdfKeys.add(key);
    pdfDownloadErrors.remove(key);
    notifyListeners();

    try {
      final saved = await ResultPdfDownloadService.download(
        item,
        forceRedownload: forceRedownload,
      );
      downloadedPdfKeys.add(key);
      if (openAfterDownload) {
        await OpenFilex.open(saved.localPath);
      }
      return saved;
    } on NoServerPdfException {
      rethrow;
    } catch (e) {
      pdfDownloadErrors[key] = e.toString();
      rethrow;
    } finally {
      downloadingPdfKeys.remove(key);
      notifyListeners();
    }
  }

  Future<void> openCachedResultPdf(PDFResultItem item) async {
    final key = ResultPdfCacheService.buildKey(item);
    final file = await ResultPdfCacheService.getLocalFile(key);
    if (file == null) {
      downloadedPdfKeys.remove(key);
      notifyListeners();
      throw Exception('Saved PDF not found. Please download again.');
    }
    await OpenFilex.open(file.path);
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

  void pdfClassBottomSheet(List<String> classes) {
    pdfClassFilterController.text = selectedPDFClassName ?? '';
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Select Class',
        controller: pdfClassFilterController,
        filterOptions: classes.map((c) => Options(title: c, value: 0)).toList(),
        onSelect: (v) {
          setSelectedPDFClassName(v);
          AppNavigation.goBack();
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

  /// Clears only form selection state. Call in initState() of results screens.
  /// Does NOT clear resultsResponse.
  void clearFormState() {
    selectedTerm = 0;
    selectAcademicYear = 0;
    academicYearController.clear();
    termController.clear();
    pdfClassFilterController.clear();
    selectedPDFClassName = null;
    terms = [];
    academicYears = [];
    termSelected = false;
  }

  void clearData() {
    selectedTerm = 0;
    selectAcademicYear = 0;
    academicYearController.clear();
    termController.clear();
    pdfClassFilterController.clear();
    selectedPDFClassName = null;
    terms = [];
    academicYears = [];
    termSelected = false;
    resultsResponse = ResultsResponse();
    allPDFResultsResponse = null;
    _cachedResultsMap.clear();
    _termCache.clear();
    _allResultsCache.clear();
    downloadingPdfKeys.clear();
    pdfDownloadErrors.clear();
    downloadedPdfKeys.clear();
    final studentId = localDataProvider.studentId;
    if (studentId.isNotEmpty) {
      ResultPdfCacheService.deleteForStudent(studentId);
    }
  }
}
