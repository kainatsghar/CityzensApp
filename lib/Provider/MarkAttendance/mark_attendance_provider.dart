import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/SaveAttendance/save_attendance_service.dart';
import 'package:tcs_app/Services/StudentList/student_list_service.dart';
import 'package:tcs_app/Services/TeacherSection/teacher_section_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/StudentAttendance/save_attendance_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';

class MarkAttendanceProvider with ChangeNotifier {
  final sectionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<AttendanceGraph> pieData = [];
  List<Options> sections = [];

  int selectedId = 0;
  String formattedDate = DateFormat('M/d/yyyy').format(DateTime.now());

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();

  StudentListResponse studentListResponse = StudentListResponse();

  String validator(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Required*";
    }
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext,
      listen: false);

  void setSectionData(TeacherSectionResponse response) {
    sectionResponse = response;
    sectionController.clear();
    sections = List.generate(
        sectionResponse.section.length,
        (index) => Options(
            title: sectionResponse.section[index].name,
            value: sectionResponse.section[index].classSectionId));
    notifyListeners();
  }

  Future loadStudentList() async {
    try {
      StudentListResponse response = await StudentListService.stdListRequest(
          classSectionId: '$selectedId',
          tokenId: localDataProvider.userData.tokenId,
          attendanceDate: formattedDate);
      setStudentList(response);
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  void changeStatus(String status, int index) {
    studentListResponse.studentList[index].day = status;
    notifyListeners();
  }

  void setStudentList(StudentListResponse listResponse) {
    studentListResponse = listResponse;
    notifyListeners();
  }

  void setSelectedSection(String sectionName) {
    selectedId = sections.singleWhere((e) => e.title == sectionName).value;
    sectionController.text = sectionName;
    AppNavigation.goBack();
    notifyListeners();
  }

  Future<TeacherSectionResponse> loadSections() async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
              userName: localDataProvider.userData.userName,
              token: localDataProvider.userData.tokenId);
      setSectionData(response);
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  Future<void> navigateToMarkAttendance() async {
    if (formKey.currentState.validate()) {
      FocusScope.of(AppNavigation.currentContext).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.attendanceRoute);
    }
  }

  Future<void> saveAttendance() async {
    DialogBuilder.showLoadingIndicator();
    try {
      List<DailyAttendance> attendanceList = List.generate(
          students.length,
          (i) => DailyAttendance(
              studentId: students[i].studentId,
              name: students[i].name,
              day: students[i].day));
      ResponseMessage responseMessage =
          await SaveAttendanceService.saveAttendanceRequest(
              SaveAttendanceRequest(
                  classSectionId: '$selectedId',
                  tokenId: localDataProvider.userData.tokenId,
                  attendanceDate: formattedDate,
                  dailyAttendance: attendanceList));

      if (responseMessage.isSuccessful) {
        setSaveAttendanceResponse(responseMessage);
        showSnackBar(responseMessage.message, color: AppColors.greenFontColor);
      } else {
        showSnackBar(responseMessage.message);
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  ResponseMessage saveAttendanceResponse = ResponseMessage();

  void setSaveAttendanceResponse(ResponseMessage responseMessage) {
    saveAttendanceResponse = responseMessage;
    generateAttendanceGraph();
    notifyListeners();
  }

  List<Student> get students => studentListResponse.studentList ?? [];

  void sectionBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Section',
            controller: sectionController,
            filterOptions: sections,
            onSelect: (v) => setSelectedSection(v)));
  }

  void generateAttendanceGraph() {
    pieData = [
      AttendanceGraph('Present',
          students.where((e) => e.day == 'P').toList().length, Colors.green),
      AttendanceGraph('Absent',
          students.where((e) => e.day == 'A').toList().length, Colors.red),
      AttendanceGraph('Leave',
          students.where((e) => e.day == 'L').toList().length, Colors.amber),
    ];
  }

  List<PieChartSectionData> getSections() => List.generate(
      pieData.length,
          (index) => PieChartSectionData(
          titleStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          radius: 40,
          titlePositionPercentageOffset: 1.6,
          color: pieData[index].color,
          value: double.parse('${pieData[index].attendanceCount}'),
          title: '${pieData[index].attendance}'));

  void clearClassSectionData() {
    selectedId = 0;
    sectionController.clear();
    sectionResponse = TeacherSectionResponse();
  }

  void clearAttendanceData() {
    saveAttendanceResponse = ResponseMessage();
    studentListResponse = StudentListResponse();
    pieData = [];
  }
}
