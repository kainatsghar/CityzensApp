import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/model/MarkUnverified/mark_unverified_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/UnverifiedReasons/unverified_reasons_response.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/MarkUnverified/mark_unverified_service.dart';
import 'package:tcs_app/services/TeacherSection/teacher_section_service.dart';
import 'package:tcs_app/services/UnverifiedReasons/unverified_reasons_service.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';

import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class MarkUnverifiedProvider with ChangeNotifier {
  final sectionController = TextEditingController();
  final studentIdController = TextEditingController();
  final studentNameController = TextEditingController();
  final reasonController = TextEditingController();
  final remarksController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Options> sections = [];
  List<Options> reasons = [];

  int? sectionId;
  int? reasonId;

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();
  UnverifiedReasonsResponse unverifiedReasons = UnverifiedReasonsResponse();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setSectionData(TeacherSectionResponse response) {
    sectionResponse = response;
    sectionController.clear();
    sectionId = null;
    sections = List.generate(
      sectionResponse.section!.length,
      (index) => Options(
        title: sectionResponse.section![index].name,
        value: sectionResponse.section![index].classSectionId,
      ),
    );
    notifyListeners();
  }

  void setReasonsData(UnverifiedReasonsResponse response) {
    unverifiedReasons = response;
    reasons = List.generate(
      unverifiedReasons.verificationReasons!.length,
      (index) => Options(
        title: unverifiedReasons.verificationReasons![index].reasonDescription!,
        value: unverifiedReasons.verificationReasons![index].reasonId!,
      ),
    );
    notifyListeners();
  }

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionController.text = sectionName;
    sectionId = sections.singleWhere((e) => e.title == sectionName).value;
    notifyListeners();
  }

  Future<void> setSelectedReason(String reason) async {
    AppNavigation.goBack();
    reasonController.text = reason;
    reasonId = reasons.singleWhere((e) => e.title == reason).value;
    notifyListeners();
  }

  Future<TeacherSectionResponse> loadSections() async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
            userName: localDataProvider.userData!.userName!,
            token: localDataProvider.userData!.tokenId!,
          );
      setSectionData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<UnverifiedReasonsResponse> loadReasons() async {
    try {
      UnverifiedReasonsResponse response =
          await UnverifiedReasonsService.getReasons(
            tokenId: localDataProvider.userData!.tokenId!,
          );
      setReasonsData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> markUnverified() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await MarkUnverifiedService.markUnverified(
          MarkUnverifiedRequest(
            employeeId: localDataProvider.userData!.userName,
            sectionId: sectionId,
            reasonId: reasonId,
            studentName: studentNameController.text,
            studentId: studentIdController.text,
            teacherRemarks: remarksController.text,
            tokenId: localDataProvider.userData!.tokenId,
          ),
        );

        // if (response.isSuccess) {
        if (response.isSuccess == true) {
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Unverified Student Added Successfully',
            color: AppColors.successGreenColor,
          );
        } else {
          showSnackBar(response.message);
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  void sectionBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Sections',
        controller: sectionController,
        filterOptions: sections,
        onSelect: (v) => setSelectedSection(v),
      ),
    );
  }

  void reasonsBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Reasons',
        controller: reasonController,
        filterOptions: reasons,
        onSelect: (v) => setSelectedReason(v),
      ),
    );
  }

  /// Clears only form input state. Call in initState() of mark unverified screens.
  /// Does NOT clear unverifiedReasons or sectionResponse (list data).
  void clearFormState() {
    sectionId = null;
    reasonId = null;
    remarksController.clear();
    sectionController.clear();
    studentIdController.clear();
    reasonController.clear();
    studentNameController.clear();
  }

  void clearData() {
    sectionId = null;
    reasonId = null;
    remarksController.clear();
    sectionController.clear();
    studentIdController.clear();
    reasonController.clear();
    studentNameController.clear();
    unverifiedReasons = UnverifiedReasonsResponse();
    sectionResponse = TeacherSectionResponse();
  }

  void setSectionId(int? id) {
    sectionId = id;
    notifyListeners();
  }

  void setReasonId(int? id) {
    reasonId = id;
    notifyListeners();
  }
}
