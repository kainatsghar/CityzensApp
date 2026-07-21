import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/SaveAttendance/save_attendance_service.dart';
import 'package:tcs_app/services/SectionSubject/section_subject_service.dart';
import 'package:tcs_app/services/StudentList/student_list_service.dart';
import 'package:tcs_app/services/TeacherSection/teacher_section_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/StudentAttendance/save_attendance_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';

class MarkAttendanceProvider with ChangeNotifier {
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  bool isDirty = false;
  bool isUpdateMode = false;

  bool get isViewOnly => !isToday(selectedDate);
  bool get isWeekend =>
      selectedDate.weekday == DateTime.saturday ||
      selectedDate.weekday == DateTime.sunday;

  bool get isTimeLocked {
    if (AppConstants.baseUrl == AppConstants.apiTestBaseURL) return false;
    if (classId == 19 || classId == 20) return false;
    return DateTime.now().hour >= 10;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setDirty(bool value) {
    if (isDirty != value) {
      isDirty = value;
      notifyListeners();
    }
  }

  Map<String, int> getLiveStatistics() {
    int present = 0, absent = 0, leave = 0, unreconciled = 0;
    for (var student in students) {
      if (student.attnTypeId == 1) {
        present++;
      } else if (student.attnTypeId == 2) {
        absent++;
      } else if (student.attnTypeId == 3) {
        leave++;
      } else if (student.attnTypeId == 35) {
        unreconciled++;
      }
    }
    return {
      'Present': present,
      'Absent': absent,
      'Leave': leave,
      'Unreconciled': unreconciled,
    };
  }

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
    if (sectionId == id) return;
    sectionId = id;
    notifyListeners();
  }

  /// Set class ID from section object
  void setClassId(int? id) {
    if (classId == id) return;
    classId = id;
    notifyListeners();
  }

  /// Set subject ID and name from subject object
  void setSubjectId(int? id, String? name) {
    if (subjectId == (id ?? 0) && subjectController.text == (name ?? '')) {
      return;
    }
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
        attendanceDate: DateFormat('yyyy-MM-dd').format(selectedDate),
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
    if (isViewOnly) return;
    studentListResponse.studentList![index].day = status;
    studentListResponse.studentList![index].attnTypeId = attendanceOptions
        .singleWhere((e) => e.title!.characters.first == status)
        .value;
    setDirty(true);
    notifyListeners();
  }

  void setStudentList(StudentListResponse listResponse) {
    studentListResponse = listResponse;
    saveAttendanceResponse = ResponseMessage();
    isUpdateMode = false;
    isDirty = false;

    // Check if any student already has attendance marked from API
    bool anyMarked = false;
    if (studentListResponse.studentList != null) {
      for (int i = 0; i < studentListResponse.studentList!.length; i++) {
        if (studentListResponse.studentList![i].attnTypeId != 0) {
          anyMarked = true;
          break;
        }
      }
    }
    isUpdateMode = anyMarked;

    if (isToday(selectedDate) && studentListResponse.studentList != null) {
      for (int i = 0; i < studentListResponse.studentList!.length; i++) {
        if (studentListResponse.studentList![i].attnTypeId == 0) {
          studentListResponse.studentList![i].day = 'P';
          studentListResponse.studentList![i].attnTypeId = 1;
        }
      }
    }
    notifyListeners();
  }

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    final newSectionId = sections
        .firstWhere((e) => e.title == sectionName)
        .value;

    // BUG FIX: Only reset subject and reload if section actually changed
    if (sectionId != newSectionId) {
      sectionId = newSectionId;
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
                attendanceDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                subjectId: subjectId,
                dailyAttendance: attendanceList,
              ),
            );
        if (responseMessage.isSuccessful ?? false) {
          isUpdateMode = true; // After successful save, it becomes update mode
          isDirty = false;
          setSaveAttendanceResponse(responseMessage);
          showSnackBar(
            responseMessage.message,
            color: AppColors.successGreen,
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

  Future<void> selectSection(Section s, DashboardProvider dashboard) async {
    if (sectionId == s.classSectionId) return;
    sectionId = s.classSectionId;
    classId = s.classId;
    sectionController.text = s.name ?? '';
    subjectId = 0;
    subjectController.clear();

    // 1. Resolve and select subjects from local cache instantly
    final localSubjects = dashboard.getSubjectsForSection(
      classSectionId: sectionId ?? 0,
      isDiary: false,
    );
    if (localSubjects != null && localSubjects.isNotEmpty) {
      subjects = List.generate(
        localSubjects.length,
        (index) => Options(
          title: localSubjects[index].subjectName!,
          value: localSubjects[index].subjectId!,
        ),
      );
      if (classId == 19 || classId == 20) {
        subjectId = localSubjects[0].subjectId ?? 0;
        subjectController.text = localSubjects[0].subjectName ?? '';
      }
    } else {
      subjects = [];
    }

    // Notify listeners instantly so the selection and its subjects appear in 0ms
    notifyListeners();

    // 2. Perform background network sync in a non-blocking fashion
    if (classId == 19 || classId == 20) {
      try {
        SectionSubjectService.getSubjectsRequest(
          classSectionId: '$sectionId',
          teacherId: localDataProvider.userData!.userName!,
          token: localDataProvider.userData!.tokenId!,
        ).then((response) {
          subjectResponse = response;
          subjects = List.generate(
            subjectResponse.sectionSubject!.length,
            (index) => Options(
              title: subjectResponse.sectionSubject![index].subjectName!,
              value: subjectResponse.sectionSubject![index].subjectId!,
            ),
          );
          notifyListeners();
        });
      } catch (_) {}
    }
  }

  void clearData() {
    selectedDate = DateTime.now();
    isDirty = false;
    isUpdateMode = false;
    sectionId = null;
    classId = null;
    subjectId = 0;
    sectionController.clear();
    subjectController.clear();
    sectionResponse = TeacherSectionResponse();
    subjectResponse = SectionSubjectResponse();
    studentListResponse = StudentListResponse();
    pieData = [];
    sections = [];
    subjects = [];
  }
}
