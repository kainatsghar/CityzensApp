import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Model/ClassTestResult/student_test_result_list_response.dart';
import 'package:tcs_app/Services/ClassTestResult/class_test_result_service.dart';
import 'package:tcs_app/model/Options/options.dart';

import '../../CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/AddClassTestResult/add_class_test_result_request.dart';
import '../../Model/ClassTestResult/class_test_student_list_response.dart';
import '../../Model/SectionSubject/section_subject_response.dart';
import '../../Routes/app_navigation.dart';
import '../../Routes/app_navigation_routes.dart';
import '../../Services/SectionSubject/section_subject_service.dart';
import '../../Services/TeacherSection/teacher_section_service.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../LocalData/local_data_provider.dart';

class ClassTestResultProvider with ChangeNotifier {
  ScrollController? scrollController;
  TabController? controller;
  List<Options> subjects = [];
  List<Options> sections = [];
  final subjectController = TextEditingController();
  final sectionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final testFormKey = GlobalKey<FormState>();

  int subjectId = 0;
  int categoryId = 0;
  int totalMarks = 0;
  int obtainedMarks = 0;
  int obtainMarks = 0;

  List<StudentMarks> studentMarks = [];
  List<ClassTestStudent> studentList =
      []; // Added to store student marks temporarily

  late String selectedSubjectName;

  int? sectionId;

  SectionSubjectResponse subjectResponse = SectionSubjectResponse();
  TeacherSectionResponse sectionResponse = TeacherSectionResponse();

  ClassTestResultStudentListResponse? classTestResultStudentResponse;
  AddClassTestResultRequest? addClassTestResultRequest;
  StudentTestResultListResponse? studentTestResultListResponse;

  List<Options> students = [];

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void initializeData(TickerProvider tickerProvider) {
    controller = TabController(length: 3, vsync: tickerProvider);
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

  void setSelectedSubject(String subjectName) {
    subjectId = subjects.singleWhere((e) => e.title == subjectName).value!;
    selectedSubjectName = subjects
        .singleWhere((e) => e.title == subjectName)
        .title!;
    subjectController.text = subjectName;
    AppNavigation.goBack();
    notifyListeners();
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

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionId = sections.singleWhere((e) => e.title == sectionName).value;
    subjectController.clear();
    sectionController.text = sectionName;
    DialogBuilder.showLoadingIndicator();
    await loadSubjects().whenComplete(() => DialogBuilder.hideOpenDialog());
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

  Future<void> navigateToAddClassResult() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.teacherAddClassResultRoute);
    }
  }

  Future<ClassTestResultStudentListResponse> loadStudentsBySubject() async {
    clearLibraryData();
    try {
      ClassTestResultStudentListResponse response =
          await ClassTestResultService.classTestResulStdListRequest(
            id: localDataProvider.userData!.userName!,
            subjectId: '$subjectId',
            sectionId: '$sectionId',
            categoryId: categoryId,
            totalMarks: totalMarks,
          );
      setClassTestStudentsData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setClassTestStudentsData(ClassTestResultStudentListResponse response) {
    classTestResultStudentResponse = response;
    totalMarks = classTestResultStudentResponse!.studentList![0].totalMarks!;

    notifyListeners();
  }

  Future<ClassTestResultStudentListResponse> loadStudentsTestResults() async {
    try {
      ClassTestResultStudentListResponse response =
          await ClassTestResultService.classTestResulStdListRequest(
            id: localDataProvider.userData!.userName!,
            subjectId: '$subjectId',
            sectionId: '$sectionId',
            categoryId: categoryId,
            totalMarks: totalMarks,
          );
      setStudentsTestResultData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setStudentsTestResultData(ClassTestResultStudentListResponse response) {
    classTestResultStudentResponse = response;

    notifyListeners();
  }

  void clearData() {
    sectionId = null;
    subjectController.clear();
    sectionController.clear();
    sections = [];
    subjects = [];
    studentMarks = [];
    studentList = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
    classTestResultStudentResponse = ClassTestResultStudentListResponse();
    addClassTestResultRequest = AddClassTestResultRequest();
  }

  void clearLibraryData() {
    classTestResultStudentResponse = null;
    totalMarks = 0;
  }

  Future<void> submitAllMarks() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate() &&
          testFormKey.currentState!.validate()) {
        //studentMarks.clear();

        if (classTestResultStudentResponse != null &&
            classTestResultStudentResponse!.studentList != null) {
          for (var element in classTestResultStudentResponse!.studentList!) {
            studentMarks.add(
              StudentMarks(
                studentId: element.studentId,
                obtainedMarks: element.obtainedMarks,
              ),
            );
          }

          FocusScope.of(
            AppNavigation.currentContext!,
          ).requestFocus(FocusNode());
          ResponseMessage response =
              await ClassTestResultService.addStudentMarks(
                AddClassTestResultRequest(
                  categoryId: categoryId,
                  subjectId: subjectId,
                  teacherId: int.tryParse(
                    localDataProvider.userData!.userName.toString(),
                  ),
                  studentMarks: studentMarks,
                  totalMarks: totalMarks,
                ),
              );
          if (response.isSuccessful!) {
            await loadStudentsBySubject();
            Future.delayed(
              const Duration(seconds: 1),
              () => AppNavigation.goBack(),
            );
            showSnackBar(
              'All Marks Added Successfully',
              color: AppColors.successGreenColor,
            );
          } else {
            showSnackBar(response.message);
          }
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  // Initialize obtained marks for each student
  void initializeObtainedMarks(AddClassTestResultRequest request) {
    if (request.studentMarks != null) {
      for (var student in request.studentMarks!) {
        student.obtainedMarks = 0;
      }
    }
  }

  // Update obtained marks for a specific student
  void updateObtainedMarks(int studentIndex, int obtainedMarks) {
    studentMarks = [];
    if (classTestResultStudentResponse != null &&
        classTestResultStudentResponse!.studentList != null &&
        studentIndex >= 0 &&
        studentIndex < classTestResultStudentResponse!.studentList!.length) {
      classTestResultStudentResponse!.studentList![studentIndex].obtainedMarks =
          obtainedMarks;
      notifyListeners();
    }
  }

  Future<StudentTestResultListResponse>
  loadStudentsTestResultswithMarks() async {
    int? userId = localDataProvider.userData!.userType == 'Student'
        ? int.tryParse(localDataProvider.studentId)
        : localDataProvider.userData!.userType == 'Parent'
        ? int.tryParse(localDataProvider.studentId)
        : int.tryParse(localDataProvider.userData!.userName.toString());
    try {
      StudentTestResultListResponse response =
          await ClassTestResultService.studentsTestResultListRequest(
            status: localDataProvider.userData!.userType == 'Student'
                ? 0
                : localDataProvider.userData!.userType == 'Parent'
                ? 0
                : 1,
            id: userId ?? 0,
          );
      setStudentsTestResultDataWithMarks(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setStudentsTestResultDataWithMarks(
    StudentTestResultListResponse response,
  ) {
    studentTestResultListResponse = response;

    notifyListeners();
  }
}
