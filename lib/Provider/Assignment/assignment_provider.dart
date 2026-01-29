import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/AddAssignment/add_assignment_request.dart';
import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/services/AddAssignment/add_assignment_service.dart';
import 'package:tcs_app/services/StudentAssignment/student_assignment_service.dart';
import 'package:tcs_app/services/TeacherAssignment/teacher_assignment_service.dart';
import 'package:tcs_app/services/TeacherSection/teacher_section_service.dart';
import '../../custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/SectionSubject/section_subject_response.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../../routes/app_navigation.dart';
import '../../services/SectionSubject/section_subject_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../model/Options/options.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../LocalData/local_data_provider.dart';

class AssignmentProvider with ChangeNotifier {
  AssignmentResponse? assignmentResponse;
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? sectionId;
  int? subjectId;

  List<Options> sections = [];
  List<Options> subjects = [];

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  void setAssignmentRecords(AssignmentResponse response) {
    assignmentResponse = response;
    notifyListeners();
  }

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionId = sections.singleWhere((e) => e.title == sectionName).value;
    subjectController.clear();
    sectionController.text = sectionName;
    DialogBuilder.showLoadingIndicator();
    await loadSubjects().whenComplete(() => DialogBuilder.hideOpenDialog());
    notifyListeners();
  }

  Future<void> submitAssignment() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await AddAssignmentService.addAssignment(
          AddAssignmentRequest(
            subject: subjectController.text,
            sectionId: sectionId,
            classTeacherId: localDataProvider.userData!.userName,
            classWorkDate: formattedDate,
            description: descriptionController.text,
            tokenId: localDataProvider.userData!.tokenId,
            fileName: fileName ?? '',
            filePath: base64String ?? '',
          ),
        );
        if (response.isSuccess!) {
          await loadTeacherAssignment();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Assignment Added Successfully',
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

  Future<AssignmentResponse> loadTeacherAssignment() async {
    try {
      AssignmentResponse response =
          await TeacherAssignmentService.getAssignmentRecords(
            userName: localDataProvider.userData!.userName!,
            tokenId: localDataProvider.userData!.tokenId!,
          );
      setAssignmentRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<AssignmentResponse> loadStudentDiary() async {
    try {
      AssignmentResponse response =
          await StudentAssignmentService.getAssignmentRecords(
            userName: localDataProvider.studentId,
            tokenId: localDataProvider.userData!.tokenId!,
          );
      setAssignmentRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    sectionId = null;
    subjectId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
  }

  void setSectionId(int? id) {
    sectionId = id;
    notifyListeners();
  }

  void setSubjectId(int? id, String? name) {
    subjectId = id;
    subjectController.text = name ?? '';
    notifyListeners();
  }

  void clearLibraryData() {
    assignmentResponse = null;
  }
}
