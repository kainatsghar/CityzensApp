import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Model/Appointment/appointment_response.dart';
import '../../CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/AddAppointment/add_appointment_request.dart';
import '../../Services/AddAppointment/add_appointment_service.dart';
import '../../Services/Appointment/appointment_service.dart';
import '../../Services/ParentAppointment/parent_book_an_appointment_service.dart';
import '../../Routes/app_navigation.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../LocalData/local_data_provider.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentResponse? appointmentResponse;
  MeetingResponse? meetingResponse;
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? sectionId;

  int? selectedIndex;
  int? selectedTeacherType;
  String? selectedDate;
  int? selectedTime;
  int? selectedReason;

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? fileName;
  String? base64String;

  String addSuffixToDay(int day) {
    if (day >= 11 && day <= 13) {
      return '$day' 'TH';
    }
    switch (day % 10) {
      case 1:
        return '$day' 'ST';
      case 2:
        return '$day' 'ND';
      case 3:
        return '$day' 'RD';
      default:
        return '$day' 'TH';
    }
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false);

  void setAppointmentRecords(AppointmentResponse response) {
    appointmentResponse = response;
    notifyListeners();
  }

  void setAppointments(MeetingResponse response) {
    meetingResponse = response;
    notifyListeners();
  }

  void setSelectedDate(String date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(int time) {
    selectedTime = time;
    notifyListeners();
  }

  void setSelectedReason(int reason) {
    selectedReason = reason;
    notifyListeners();
  }

  void setSelectedType(int type) {
    selectedTeacherType = type;
    notifyListeners();
  }

  Future<void> submitAppointment() async {
    DialogBuilder.showLoadingIndicator();
    int? userId = localDataProvider.userData!.userType == 'Student'
        ? int.tryParse(localDataProvider.studentId)
        : localDataProvider.userData!.userType == 'Parent'
            ? int.tryParse(localDataProvider.studentId)
            : localDataProvider.userData!.id;

    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await AddAppointmentService.addAppointment(
            AddAppointmentRequest(
                studentId: userId,
                classSectionId: sectionId,
                meetingPersonId: selectedTeacherType,
                meetingTimeId: selectedTime,
                meetingReasonId: selectedReason,
                createdBy: localDataProvider.userData!.userName,
                modifiedBy: localDataProvider.userData!.userName,
                dayName: selectedDate));
        if (response.isSuccessful!) {
          await loadAppointmentConfig();
          Future.delayed(
              const Duration(seconds: 1), () => AppNavigation.goBack());
          showSnackBar('Appointment Added Successfully',
              color: AppColors.successGreenColor);
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

  void setReason(int index) {
    if (selectedIndex == index) {
      selectedIndex = null;
    } else {
      selectedIndex = index;
    }
  }

  Future<AppointmentResponse> loadAppointmentConfig() async {
    int? userId = localDataProvider.userData!.userType == 'Student'
        ? int.tryParse(localDataProvider.studentId)
        : localDataProvider.userData!.userType == 'Parent'
            ? int.tryParse(localDataProvider.studentId)
            : localDataProvider.userData!.id;
    try {
      AppointmentResponse response =
          await ParentBookanAppointmentService.getMeetingConfig(
              userName: userId ?? 0,
              tokenId: localDataProvider.userData!.tokenId!);
      setAppointmentRecords(response);
      loadExistingAppointmentsForConfig();
      //setSelectedType(2);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<MeetingResponse> loadExistingAppointmentsForConfig() async {
    int? userId = int.tryParse(localDataProvider.studentId);
    try {
      MeetingResponse response = await AppointmentService.getMeetings(
          userName: userId ?? 0, isStudent: true);
      setAppointments(response);
      setSelectedType(
          meetingResponse!.meetingDetails![0].meetingPersonId as int);
      setSelectedReason(
          meetingResponse!.meetingDetails![0].meetingReasonId as int);
      setSelectedTime(meetingResponse!.meetingDetails![0].meetingTimeId as int);
      setSelectedDate(meetingResponse!.meetingDetails![0].meetingDay
          .toString()
          .toUpperCase());

      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<MeetingResponse> loadAppointments() async {
    int? userId = localDataProvider.userData!.userType == 'Student'
        ? int.tryParse(localDataProvider.studentId)
        : localDataProvider.userData!.userType == 'Parent'
            ? int.tryParse(localDataProvider.studentId)
            : localDataProvider.userData!.userType == 'Teacher'
                ? int.tryParse(localDataProvider.userData!.userName.toString())
                : localDataProvider.userData!.id;
    try {
      MeetingResponse response = await AppointmentService.getMeetings(
          userName: userId ?? 0,
          isStudent:
              localDataProvider.userData!.userType == 'Parent' ? true : false);
      setAppointments(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    sectionId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();

    selectedIndex = null;
    selectedTeacherType = null;
    selectedDate = null;
    selectedTime = null;
    selectedReason = null;

    appointmentResponse = null;
  }

  void clearAppointmentData() {
    appointmentResponse = null;
  }
}
