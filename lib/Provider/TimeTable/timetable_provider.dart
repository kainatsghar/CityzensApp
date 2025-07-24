import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Services/TeacherSection/teacher_section_service.dart';
import '../../CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/AddTimeTable/add_timetable_request.dart';
import '../../Model/TimeTable/timetable_response.dart';
import '../../Routes/app_navigation_routes.dart';
import '../../Services/AddTimetable/add_timetable_service.dart';
import '../../Services/TimeTable/timetable_service.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../../Routes/app_navigation.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../../model/Options/options.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../LocalData/local_data_provider.dart';

class TimeTableProvider with ChangeNotifier {
  TimeTableResponse? timeTableResponse;
  final sectionController = TextEditingController();
  late final formKey = GlobalKey<FormState>();

  bool? isInitial;

  int? sectionId;
  int? classId;

  List<Options> sections = [];

  Map<String, Map<int, String>> timetablelistValues = {};

  List<DayList> timetableValues = [];
  List<Periods> periodslist = [];

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false);

  void setSectionData(TeacherSectionResponse response) {
    sectionResponse = response;
    sectionController.clear();
    sectionId = null;
    sections = List.generate(
        sectionResponse.section!.length,
        (index) => Options(
              title: sectionResponse.section![index].name,
              value: sectionResponse.section![index].classSectionId,
            ));
    notifyListeners();
  }

  void setValue(String day, int periodIndex, String marks) {
    if (isInitial == true) {
      timetablelistValues.update(
        day,
        (value) => {
          ...value,
          periodIndex + 1: marks,
        },
        ifAbsent: () => {
          periodIndex + 1: marks,
        },
      );
    } else {
      if (timeTableResponse == null ||
          timeTableResponse!.classTimeTableDTO == null ||
          timeTableResponse!.classTimeTableDTO!.dayLists == null) {
        return;
      }

      var dayList = timeTableResponse!.classTimeTableDTO!.dayLists!.firstWhere(
        (dayList) => dayList.dayOfWeek == day,
        orElse: () =>
            DayListResponse(dayOfWeek: day, periods: [PeriodsResponse()]),
      );

      dayList.periods ??= [PeriodsResponse()];

      if (dayList.periods!.isEmpty) {
        dayList.periods!.add(PeriodsResponse());
      }

      switch (periodIndex) {
        case 0:
          dayList.periods![0].subject1 = marks;
          break;
        case 1:
          dayList.periods![0].subject2 = marks;
          break;
        case 2:
          dayList.periods![0].subject3 = marks;
          break;
        case 3:
          dayList.periods![0].subject4 = marks;
          break;
        case 4:
          dayList.periods![0].subject5 = marks;
          break;
        case 5:
          dayList.periods![0].subject6 = marks;
          break;
        case 6:
          dayList.periods![0].subject7 = marks;
          break;
        case 7:
          dayList.periods![0].subject8 = marks;
          break;
        case 8:
          dayList.periods![0].subject9 = marks;
          break;
        default:
          return;
      }

      if (!timeTableResponse!.classTimeTableDTO!.dayLists!
          .any((dayList) => dayList.dayOfWeek == day)) {
        timeTableResponse!.classTimeTableDTO!.dayLists!.add(dayList);
      }

      if (!timeTableResponse!.classTimeTableDTO!.dayLists!
          .any((dayList) => dayList.dayOfWeek == day)) {
        timeTableResponse!.classTimeTableDTO!.dayLists!.add(dayList);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void setTimeTableRecords(TimeTableResponse response) {
    timeTableResponse = response;
    notifyListeners();
  }

  Future<void> setSelectedSection(String sectionName) async {
    AppNavigation.goBack();
    sectionId = sections.firstWhere((e) => e.title == sectionName).value;
    classId = sectionResponse.section!
        .firstWhere((e) => e.name == sectionName)
        .classId;

    sectionController.text = sectionName;

    notifyListeners();
  }

  Future<TeacherSectionResponse> loadSections() async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
              userName: localDataProvider.userData!.userName!,
              token: localDataProvider.userData!.tokenId!);
      setSectionData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> navigateToMarkTimeTable() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
      AppNavigation.navigateTo(AppNavRoutes.teacherTimeTableRoute);
    }
  }

  Future<void> saveTimeTable() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());

        List<DayListResponse> currentDayLists =
            timeTableResponse?.classTimeTableDTO?.dayLists ?? [];

        Map<String, DayListResponse> currentDayMap = {
          for (var dayList in currentDayLists) dayList.dayOfWeek ?? '': dayList,
        };

        final List<String> weekdays = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday'
        ];

        for (var day in weekdays) {
          var existingPeriods =
              currentDayMap[day]?.periods ?? [PeriodsResponse()];

          if (existingPeriods.isEmpty) {
            existingPeriods.add(PeriodsResponse());
          }

          for (int i = 0; i < 9; i++) {
            // ignore: unnecessary_null_comparison
            if (existingPeriods[0] == null) {
              existingPeriods[0] = PeriodsResponse();
            }

            if (timetablelistValues[day]?.containsKey(i + 1) ?? false) {
              String subject = timetablelistValues[day]![i + 1] ?? '';
              switch (i + 1) {
                case 1:
                  existingPeriods[0].subject1 = subject;
                  break;
                case 2:
                  existingPeriods[0].subject2 = subject;
                  break;
                case 3:
                  existingPeriods[0].subject3 = subject;
                  break;
                case 4:
                  existingPeriods[0].subject4 = subject;
                  break;
                case 5:
                  existingPeriods[0].subject5 = subject;
                  break;
                case 6:
                  existingPeriods[0].subject6 = subject;
                  break;
                case 7:
                  existingPeriods[0].subject7 = subject;
                  break;
                case 8:
                  existingPeriods[0].subject8 = subject;
                  break;
                case 9:
                  existingPeriods[0].subject9 = subject;
                  break;
                default:
                  break;
              }
            } else {
              switch (i + 1) {
                case 1:
                  existingPeriods[0].subject1 ??= '';
                  break;
                case 2:
                  existingPeriods[0].subject2 ??= '';
                  break;
                case 3:
                  existingPeriods[0].subject3 ??= '';
                  break;
                case 4:
                  existingPeriods[0].subject4 ??= '';
                  break;
                case 5:
                  existingPeriods[0].subject5 ??= '';
                  break;
                case 6:
                  existingPeriods[0].subject6 ??= '';
                  break;
                case 7:
                  existingPeriods[0].subject7 ??= '';
                  break;
                case 8:
                  existingPeriods[0].subject8 ??= '';
                  break;
                case 9:
                  existingPeriods[0].subject9 ??= '';
                  break;
                default:
                  break;
              }
            }
          }

          currentDayMap[day] =
              DayListResponse(dayOfWeek: day, periods: existingPeriods);
        }

        int? id = int.tryParse(localDataProvider.userData!.userName ?? '');

        List<DayListResponse> updatedDayLists = currentDayMap.values.toList();

        AddTimeTableRequest request = AddTimeTableRequest(
          termId: 1,
          classSectionId: sectionId,
          classTeacherId: id,
          createdBy: id,
          dayLists: updatedDayLists.map((dayListResponse) {
            return DayList(
              dayOfWeek: dayListResponse.dayOfWeek,
              periods: dayListResponse.periods?.map((periodResponse) {
                return Periods(
                  subject1: periodResponse.subject1,
                  subject2: periodResponse.subject2,
                  subject3: periodResponse.subject3,
                  subject4: periodResponse.subject4,
                  subject5: periodResponse.subject5,
                  subject6: periodResponse.subject6,
                  subject7: periodResponse.subject7,
                  subject8: periodResponse.subject8,
                  subject9: periodResponse.subject9,
                );
              }).toList(),
            );
          }).toList(),
        );

        ResponseMessage response =
            await AddTimetableService.addTimetable(request);

        if (response.isSuccessful!) {
          await loadTimeTable();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'TimeTable Added Successfully',
            color: AppColors.successGreenColor,
          );
        } else {
          showSnackBar(response.message);
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  void sectionBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Section',
            controller: sectionController,
            filterOptions: sections,
            onSelect: (v) => setSelectedSection(v)));
  }

  Future<TimeTableResponse> loadTimeTable() async {
    try {
      int? userId = localDataProvider.userData!.userType == 'Student'
          ? int.tryParse(localDataProvider.studentId)
          : localDataProvider.userData!.userType == 'Parent'
              ? int.tryParse(localDataProvider.studentId)
              : int.tryParse(localDataProvider.userData!.userName ?? '');

      TimeTableResponse response = await TimeTableService.getTimeTableRecords(
          classSectionId: sectionId,
          id: userId ?? 0,
          isTeacher:
              localDataProvider.userData!.userType == "Teacher" ? true : false);
      setTimeTableRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearClassSectionData() {
    sectionId = null;
    classId = null;
    sections = [];
    sectionController.clear();
    sectionResponse = TeacherSectionResponse();
  }

  void clearData() {
    timetablelistValues = {};
    timetableValues = [];
    periodslist = [];
    isInitial = false;
  }
}
