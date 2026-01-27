import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

import '../../custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/AddCircular/add_circular_request.dart';
import '../../Model/ResponseMessage/response_message.dart';
import '../../Model/SectionSubject/section_subject_response.dart';
import '../../Services/AddCircular/add_circular_service.dart';
import '../../Services/SectionSubject/section_subject_service.dart';
import '../../Services/TeacherSection/teacher_section_service.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../../model/Options/options.dart';
import '../../model/TeacherSection/teacher_section_response.dart';

class CircularProvider with ChangeNotifier {
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? sectionId;

  List<Options> sections = [];
  List<Options> subjects = [];

  String? fileName;
  String? base64String;

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();
  SectionSubjectResponse subjectResponse = SectionSubjectResponse();

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

  void setSubjectsData(SectionSubjectResponse response) {
    subjectResponse = response;
    subjectController.clear();
    subjects = List.generate(
      subjectResponse.sectionSubject!.length,
      (index) => Options(
        title: subjectResponse.sectionSubject![index].subjectName!,
        value: subjectResponse.sectionSubject![index].subjectId!,
      ),
    );
    notifyListeners();
  }

  Future<TeacherSectionResponse> loadSections() async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
            isDiary: true,
            userName: localDataProvider.userData!.userName!,
            token: localDataProvider.userData!.tokenId!,
          );
      setSectionData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<SectionSubjectResponse> loadSubjects() async {
    try {
      SectionSubjectResponse response =
          await SectionSubjectService.getSubjectsRequest(
            isDiary: true,
            classSectionId: '$sectionId',
            teacherId: localDataProvider.userData!.userName!,
            token: localDataProvider.userData!.tokenId!,
          );
      setSubjectsData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionId = sections.singleWhere((e) => e.title == sectionName).value;
    subjectController.clear();
    sectionController.text = sectionName;
    DialogBuilder.showLoadingIndicator();
    await loadSubjects().whenComplete(() => DialogBuilder.hideOpenDialog());
    notifyListeners();
  }

  Future<void> submitCircular() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await AddCircularService.addCircular(
          AddCircularRequest(
            title: titleController.text,
            body: descriptionController.text,
            subject: subjectController.text,
            sectionId: sectionId,
            classTeacherId: localDataProvider.userData!.userName,
            tokenId: localDataProvider.userData!.tokenId,
            fileName: fileName ?? '',
            filePath: base64String ?? '',
          ),
        );
        if (response.isSuccess!) {
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Circular Added Successfully',
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

  void setSelectedSubject(String subjectName) {
    subjectController.text = subjectName;
    AppNavigation.goBack();
    notifyListeners();
  }

  void sectionBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Select Section',
        controller: sectionController,
        filterOptions: sections,
        onSelect: (v) => setSelectedSection(v),
      ),
    );
  }

  void subjectBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => CustomFilterBottomSheet(
        title: 'Select Subject',
        controller: subjectController,
        filterOptions: subjects,
        onSelect: (v) => setSelectedSubject(v),
      ),
    );
  }

  void clearData() {
    sectionId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    titleController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
  }
}
