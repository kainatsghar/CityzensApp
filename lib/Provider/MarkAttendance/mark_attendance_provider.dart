import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/SaveAttendance/save_attendance_service.dart';
import 'package:tcs_app/Services/SectionSubject/section_subject_service.dart';
import 'package:tcs_app/Services/StudentList/student_list_service.dart';
import 'package:tcs_app/Services/TeacherSection/teacher_section_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/StudentAttendance/save_attendance_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';

class MarkAttendanceProvider with ChangeNotifier {
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<AttendanceGraph> pieData = [];
  List<Options> sections = [];
  List<Options> subjects = [];

  int? sectionId;
  int? classId;
  int subjectId = 0;

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();
  SectionSubjectResponse subjectResponse = SectionSubjectResponse();

  StudentListResponse studentListResponse = StudentListResponse();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> navigateToMarkTimeTable() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.teacherTimeTableRoute);
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

  /// Set section ID and class ID from section object
  void setSectionId(int? id) {
    sectionId = id;
    notifyListeners();
  }

  /// Set class ID from section object
  void setClassId(int? id) {
    classId = id;
    notifyListeners();
  }

  /// Set subject ID and name from subject object
  void setSubjectId(int? id, String? name) {
    subjectId = id ?? 0;
    subjectController.text = name ?? '';
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

  Future<StudentListResponse> loadStudentList() async {
    try {
      StudentListResponse response = await StudentListService.stdListRequest(
        classSectionId: '$sectionId',
        subjectId: subjectId,
        tokenId: localDataProvider.userData!.tokenId!,
        attendanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      setStudentList(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> reloadStudentList() async {
    DialogBuilder.showLoadingIndicator();
    try {
      await loadStudentList();
    } catch (e) {
      rethrow;
    }
    DialogBuilder.hideOpenDialog();
  }

  void changeStatus(String status, int index) {
    studentListResponse.studentList![index].day = status;
    studentListResponse.studentList![index].attnTypeId = attendanceOptions
        .singleWhere((e) => e.title!.characters.first == status)
        .value;
    notifyListeners();
  }

  void setStudentList(StudentListResponse listResponse) {
    studentListResponse = listResponse;
    saveAttendanceResponse = ResponseMessage();
    for (int i = 0; i < studentListResponse.studentList!.length; i++) {
      if (studentListResponse.studentList![i].day == null ||
          studentListResponse.studentList![i].day!.isEmpty ||
          attendanceOptions.any(
            (e) =>
                e.title!.characters.first !=
                studentListResponse.studentList![i].day,
          )) {
        studentListResponse.studentList![i].day = 'P';
        studentListResponse.studentList![i].attnTypeId = 1;
      }
    }
    notifyListeners();
  }

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionId = sections.firstWhere((e) => e.title == sectionName).value;
    classId = sectionResponse.section!
        .firstWhere((e) => e.name == sectionName)
        .classId;
    subjectController.clear();
    subjectId = 0;
    sectionController.text = sectionName;
    if (classId == 19 || classId == 20) {
      DialogBuilder.showLoadingIndicator();
      await loadSubjects().whenComplete(() => DialogBuilder.hideOpenDialog());
    }
    notifyListeners();
  }

  void setSelectedSubject(String subjectName) {
    subjectId = subjects.singleWhere((e) => e.title == subjectName).value!;
    subjectController.text = subjectName;
    AppNavigation.goBack();
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

  Future<SectionSubjectResponse> loadSubjects() async {
    try {
      SectionSubjectResponse response =
          await SectionSubjectService.getSubjectsRequest(
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

  Future<void> navigateToMarkAttendance() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.markAttendanceRoute);
    }
  }

  Future<void> saveAttendance() async {
    DialogBuilder.showLoadingIndicator();
    try {
      List<Student> markedList = students
          .where((e) => e.attnTypeId != 0)
          .toList();
      if (markedList.length == students.length) {
        List<DailyAttendance> attendanceList = List.generate(
          markedList.length,
          (i) => DailyAttendance(
            studentId: markedList[i].studentId,
            name: markedList[i].name,
            day: markedList[i].day,
            attnTypeId: attendanceOptions
                .singleWhere(
                  (e) => e.title!.characters.first == markedList[i].day,
                )
                .value,
          ),
        );
        ResponseMessage? responseMessage =
            await SaveAttendanceService.saveAttendanceRequest(
              SaveAttendanceRequest(
                classSectionId: '$sectionId',
                tokenId: localDataProvider.userData!.tokenId,
                attendanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                subjectId: subjectId,
                dailyAttendance: attendanceList,
              ),
            );
        if (responseMessage.isSuccessful ?? false) {
          setSaveAttendanceResponse(responseMessage);
          showSnackBar(
            responseMessage.message,
            color: AppColors.successGreenColor,
          );
        } else {
          showSnackBar(responseMessage.message);
        }
      } else {
        showSnackBar(AppConstants.markAttendanceMessage);
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  ResponseMessage? saveAttendanceResponse = ResponseMessage();

  void setSaveAttendanceResponse(ResponseMessage responseMessage) {
    saveAttendanceResponse = responseMessage;
    generateAttendanceGraph();
    notifyListeners();
  }

  List<Student> get students => studentListResponse.studentList ?? [];

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

  List<Options> attendanceOptions = HelperFunction.attendanceOptions();

  void generateAttendanceGraph() {
    pieData = List.generate(
      attendanceOptions.length,
      (index) => AttendanceGraph(
        attendanceOptions[index].title!,
        students
            .where(
              (e) => e.day == attendanceOptions[index].title!.characters.first,
            )
            .toList()
            .length,
        attendanceOptions[index].color!,
      ),
    );
  }

  List<PieChartSectionData> getSections() => List.generate(
    pieData.length,
    (index) => PieChartSectionData(
      titleStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
      radius: 30,
      titlePositionPercentageOffset: 1.6,
      color: pieData[index].color,
      value: double.parse('${pieData[index].attendanceCount}'),
      title: '${pieData[index].attendanceCount}',
    ),
  );

  void clearClassSectionData() {
    sectionId = null;
    subjectId = 0;
    classId = null;
    sectionController.clear();
    subjectController.clear();
    sectionResponse = TeacherSectionResponse();
    subjectResponse = SectionSubjectResponse();
  }

  void clearAttendanceData() {
    saveAttendanceResponse = ResponseMessage();
    studentListResponse = StudentListResponse();
    pieData = [];
  }
}
