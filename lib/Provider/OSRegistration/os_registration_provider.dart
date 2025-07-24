import 'package:flutter/material.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Model/OSRegistration/os_registration_response.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/OSRegistration/os_registration_service.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class OSRegistrationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController campusController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController previousSchoolController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController previousSchoolNameController = TextEditingController();
  TextEditingController schoolLocationController = TextEditingController();
  TextEditingController studiedFromClassController = TextEditingController();
  TextEditingController studiedToClassController = TextEditingController();
  TextEditingController leavingRxnController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  MaskedTextController fatherCNICController =
      MaskedTextController(mask: '00000-0000000-0');
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  List<Options> sessions = [];
  List<Options> cities = [];
  List<Options> countries = [];
  List<Options> cityCampuses = [];
  List<Options> campusClasses = [];

  int currentStep = 0;
  int? selectedCityId;
  int? selectedCampusId;
  int? selectedClassId;

  StepState getState(int i) {
    if (currentStep > i) {
      return StepState.complete;
    } else if (currentStep == i) {
      return StepState.editing;
    } else if (currentStep < i) {
      return StepState.disabled;
    } else {
      return StepState.indexed;
    }
  }

  void tapped(int step) {
    currentStep = step;
    notifyListeners();
  }

  void continued() {
    currentStep < 3 ? currentStep += 1 : null;
    notifyListeners();
  }

  void cancelled() {
    currentStep > 0 ? currentStep -= 1 : null;
    notifyListeners();
  }

  Future<List<OSRegistrationResponse>> loadSessions() async {
    try {
      List<OSRegistrationResponse> response =
          await OSRegistrationService.osInfoRequest(endpoint: 'AllSessions');
      setSessionsResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setSessionsResponse(List<OSRegistrationResponse> response) {
    sessions = List.generate(
        response.length,
        (index) =>
            Options(title: response[index].name!, value: response[index].id!));
    notifyListeners();
  }

  Future<List<OSRegistrationResponse>> loadCities() async {
    try {
      List<OSRegistrationResponse> response =
          await OSRegistrationService.osInfoRequest(endpoint: 'AllCities');
      setCitiesResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setCitiesResponse(List<OSRegistrationResponse> response) {
    cities = List.generate(
        response.length,
        (index) =>
            Options(title: response[index].name!, value: response[index].id!));
    notifyListeners();
  }

  Future<List<OSRegistrationResponse>> loadCountries() async {
    try {
      List<OSRegistrationResponse> response =
          await OSRegistrationService.osInfoRequest(endpoint: 'Countries');
      setCountriesResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setCountriesResponse(List<OSRegistrationResponse> response) {
    countries = List.generate(
        response.length,
        (index) =>
            Options(title: response[index].name!, value: response[index].id!));
    notifyListeners();
  }

  Future<void> loadCityCampus() async {
    DialogBuilder.showLoadingIndicator();
    try {
      List<OSRegistrationResponse> response =
          await OSRegistrationService.osInfoRequest(
              endpoint: 'CampusByCity',
              body: UserDataRequest(userName: '$selectedCityId'));
      setCityCampusResponse(response);
    } catch (ex) {
      showSnackBar('$ex');
    }
    DialogBuilder.hideOpenDialog();
  }

  void setCityCampusResponse(List<OSRegistrationResponse> response) {
    cityCampuses = List.generate(
        response.length,
        (index) =>
            Options(title: response[index].name!, value: response[index].id!));
    Future.delayed(Duration.zero, () => campusBottomSheet());
    notifyListeners();
  }

  Future<void> loadCampusClass() async {
    DialogBuilder.showLoadingIndicator();
    try {
      List<OSRegistrationResponse> response =
          await OSRegistrationService.osInfoRequest(
              endpoint: 'ClassByCampus',
              body: UserDataRequest(userName: '$selectedCampusId'));
      setCampusClassesResponse(response);
    } catch (ex) {
      showSnackBar('$ex');
    }
    DialogBuilder.hideOpenDialog();
  }

  void setCampusClassesResponse(List<OSRegistrationResponse> response) {
    campusClasses = List.generate(
        response.length,
        (index) =>
            Options(title: response[index].name!, value: response[index].id!));
    Future.delayed(Duration.zero, () => classBottomSheet());
    notifyListeners();
  }

  void genderBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Gender',
            controller: genderController,
            filterOptions: HelperFunction.genderOptions(),
            onSelect: (v) => onBottomSelection(genderController, v)));
  }

  void previousSchoolBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select',
            controller: previousSchoolController,
            filterOptions: HelperFunction.previousSchoolOptions(),
            onSelect: (v) => onBottomSelection(previousSchoolController, v)));
  }

  void sessionBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Session',
            controller: sessionController,
            filterOptions: sessions,
            onSelect: (v) => onBottomSelection(sessionController, v)));
  }

  void citiesBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select City',
            controller: cityController,
            filterOptions: cities,
            onSelect: (v) => setSelectedCity(v)));
  }

  void setSelectedCity(String v) {
    cityController.text = v;
    campusController.clear();
    classController.clear();
    selectedCampusId = null;
    selectedCityId = cities.singleWhere((element) => element.title == v).value;
    notifyListeners();
    AppNavigation.goBack();
  }

  void campusBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Campus',
            controller: campusController,
            filterOptions: cityCampuses,
            onSelect: (v) => setSelectedCampus(v)));
  }

  void setSelectedCampus(String v) {
    campusController.text = v;
    classController.clear();
    selectedCampusId =
        cityCampuses.singleWhere((element) => element.title == v).value;
    notifyListeners();
    AppNavigation.goBack();
  }

  void classBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Select Class',
            controller: classController,
            filterOptions: campusClasses,
            onSelect: (v) => setSelectedClass(v)));
  }

  void setSelectedClass(String v) {
    classController.text = v;
    selectedClassId =
        campusClasses.singleWhere((element) => element.title == v).value;
    notifyListeners();
    AppNavigation.goBack();
  }

  void nationalityBottomSheet() {
    showModalBottomSheet(
        context: AppNavigation.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) => CustomFilterBottomSheet(
            title: 'Nationality',
            controller: nationalityController,
            filterOptions: countries,
            onSelect: (v) => onBottomSelection(nationalityController, v)));
  }

  void onBottomSelection(TextEditingController controller, String v) {
    controller.text = v;
    notifyListeners();
    AppNavigation.goBack();
  }

  void initializeData() {
    currentStep = 0;
    selectedCityId;
    selectedCampusId;
    selectedClassId;
    nameController = TextEditingController();
    sessionController = TextEditingController();
    cityController = TextEditingController();
    campusController = TextEditingController();
    nationalityController = TextEditingController();
    classController = TextEditingController();
    lastNameController = TextEditingController();
    previousSchoolController = TextEditingController();
    genderController = TextEditingController();
    previousSchoolNameController = TextEditingController();
    schoolLocationController = TextEditingController();
    studiedFromClassController = TextEditingController();
    studiedToClassController = TextEditingController();
    leavingRxnController = TextEditingController();
    fatherNameController = TextEditingController();
    fatherCNICController = MaskedTextController(mask: '00000-0000000-0');
    fatherOccupationController = TextEditingController();
    mobileNumberController = TextEditingController();
    emailAddressController = TextEditingController();
  }
}
