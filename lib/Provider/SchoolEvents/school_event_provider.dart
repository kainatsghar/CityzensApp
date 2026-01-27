import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Model/AddSchoolEvent/add_school_event_request.dart';
import 'package:tcs_app/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/Model/SchoolEvents/school_events_response.dart';
import 'package:tcs_app/Services/TeacherEvent/teacher_event_service.dart';

import '../../custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../Routes/app_navigation.dart';
import '../../Services/AddSchoolEvent/add_school_event_service.dart';
import '../../Services/TeacherSection/teacher_section_service.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../LocalData/local_data_provider.dart';
import '../../model/Options/options.dart';
import '../../model/TeacherSection/teacher_section_response.dart';

class SchoolEventProvider with ChangeNotifier {
  SchoolEeventsResponse? eventResponse;
  final dateController = TextEditingController();
  final eventController = TextEditingController();
  final noteController = TextEditingController();
  final sectionController = TextEditingController();

  List<Options> sections = [];

  int? sectionId;
  int? classId;

  final formKey = GlobalKey<FormState>();

  TeacherSectionResponse sectionResponse = TeacherSectionResponse();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  late DateTime selectedDate;

  //String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.toString());

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
    sectionController.text = sectionName;
    notifyListeners();
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

  Future<TeacherSectionResponse> loadSections() async {
    try {
      TeacherSectionResponse response =
          await TeacherSectionService.sectionRequest(
            isDiary: false,
            userName: localDataProvider.userData!.userName!,
            token: localDataProvider.userData!.tokenId!,
          );
      setSectionData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> submitSchoolEvent() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        ResponseMessage response = await AddSchoolEventService.addSchoolEvent(
          AddSchoolEventRequest(
            classSectionId: sectionId.toString(),
            classTeacherId: int.tryParse(
              localDataProvider.userData!.userName.toString(),
            ),
            eventName: eventController.text.toString(),
            eventNote: noteController.text.toString(),
            eventDate: formattedDate,
          ),
        );
        if (response.isSuccessful!) {
          await loadEvents();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Event Added Successfully',
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

  void setEventRecords(SchoolEeventsResponse response) {
    eventResponse = response;
    notifyListeners();
  }

  Future<SchoolEeventsResponse> loadEvents() async {
    try {
      int? userId = localDataProvider.userData!.userType == 'Student'
          ? int.tryParse(localDataProvider.studentId)
          : localDataProvider.userData!.userType == 'Parent'
          ? int.tryParse(localDataProvider.studentId)
          : int.tryParse(localDataProvider.userData!.userName.toString());

      SchoolEeventsResponse response =
          await TeacherEventService.getEventRecords(
            //id: 586114
            id: userId ?? 0,
            isStudent: localDataProvider.userData!.userType == 'Student'
                ? true
                : localDataProvider.userData!.userType == 'Parent'
                ? true
                : false,
          );
      setEventRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    sectionId = null;
    dateController.clear();
    sectionController.clear();
    eventController.clear();
    noteController.clear();
    sections = [];
    sectionResponse = TeacherSectionResponse();
  }

  void clearLibraryData() {
    eventResponse = null;
  }
}
