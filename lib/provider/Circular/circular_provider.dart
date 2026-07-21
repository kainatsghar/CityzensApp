import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import '../../custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/AddCircular/add_circular_request.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../../model/SectionSubject/section_subject_response.dart';
import '../../services/AddCircular/add_circular_service.dart';
import '../../services/SectionSubject/section_subject_service.dart';
import '../../services/TeacherSection/teacher_section_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../model/Options/options.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../../model/CircularAnnouncement/circular_announcement_response.dart';
import '../../services/CircularAnnouncement/circular_announcement_service.dart';
import '../../model/TeacherActions/update_announcement_request.dart';
import '../../model/TeacherActions/delete_action_request.dart';

class CircularProvider with ChangeNotifier {
  CircularAnnouncementResponse? circularResponse;
  bool isEdit = false;

  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? sectionId;
  int? subjectId;

  List<Options> sections = [];
  List<Options> subjects = [];

  String? fileName;
  String? base64String;

  String? selectedDate;

  CircularProvider() {
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void setSelectedDate(DateTime date) {
    selectedDate = DateFormat('yyyy-MM-dd').format(date);
    notifyListeners();
  }

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
    final newSectionId = sections
        .singleWhere((e) => e.title == sectionName)
        .value;

    // BUG FIX: Only reset subject and reload if section actually changed
    if (sectionId != newSectionId) {
      sectionId = newSectionId;
      subjectController.clear();
      sectionController.text = sectionName;
      DialogBuilder.showLoadingIndicator();
      await loadSubjects().whenComplete(() => DialogBuilder.hideOpenDialog());
      notifyListeners();
    }
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
            announcementDate: selectedDate,
          ),
        );
        if (response.isSuccess!) {
          await loadTeacherCircular();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Circular Added Successfully',
            color: AppColors.successGreen,
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

  Future<void> updateCircular(
    CircularAnnouncementRecords existingRecord,
  ) async {
    isEdit = true;
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response =
            await CircularAnnouncementService.updateAnnouncement(
              UpdateAnnouncementRequest(
                tokenId: localDataProvider.userData!.tokenId,
                id: existingRecord.id,
                subject:
                    titleController.text, // "Subject" field for Announcement
                description: descriptionController.text,
                announcementDate: selectedDate,
                classTeacherId: localDataProvider.userData!.userName,
                sectionId: existingRecord.sectionId,
                fileName: fileName ?? '',
                base64String: base64String,
              ),
            );
        if (response.isSuccess!) {
          await loadTeacherCircular();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Circular Updated Successfully',
            color: AppColors.successGreen,
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

  Future<void> deleteCircular(int id) async {
    DialogBuilder.showLoadingIndicator();
    try {
      ResponseMessage response =
          await CircularAnnouncementService.deleteAnnouncement(
            DeleteActionRequest(
              tokenId: localDataProvider.userData!.tokenId,
              id: id,
            ),
          );
      if (response.isSuccess!) {
        await loadTeacherCircular();
        showSnackBar(
          'Circular Deleted Successfully',
          color: AppColors.successGreen,
        );
      } else {
        showSnackBar(response.message);
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  /// Populates form fields for edit mode.
  /// IMPORTANT: Does NOT call notifyListeners — resolveIds fires the notification.
  void initForEdit(CircularAnnouncementRecords record) {
    isEdit = true;
    titleController.text = record.title ?? '';
    descriptionController.text = record.description ?? '';
    sectionController.text = record.sectionName ?? '';
    sectionId = record.sectionId;
    fileName = record.fileName;
    selectedDate = record.announcementDate;
    base64String = null;
    // No notifyListeners here — resolveIds will do it once.
  }

  /// Resolves sectionId from the section name, then fires a SINGLE notifyListeners.
  void resolveIds(List<Section> availableSections) {
    if (sectionId != null) {
      final matchedSection = availableSections.cast<Section?>().firstWhere(
        (s) => s?.classSectionId == sectionId,
        orElse: () => null,
      );
      if (matchedSection != null) {
        sectionController.text = matchedSection.name ?? '';
      }
    } else if (sectionController.text.isNotEmpty) {
      final matchedSection = availableSections.cast<Section?>().firstWhere(
        (s) => s?.name == sectionController.text,
        orElse: () => null,
      );
      if (matchedSection != null) {
        sectionId = matchedSection.classSectionId;
      }
    }
    // Single notification fires after all mutations are complete.
    notifyListeners();
  }

  void setSelectedSubject(String subjectName) {
    subjectController.text = subjectName;
    AppNavigation.goBack();
    notifyListeners();
  }

  void sectionBottomSheet() {
    if (isEdit) return;
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

  /// Clears only form input state. Call in initState() of form screens.
  /// Does NOT clear circularResponse (list data).
  void clearFormState() {
    isEdit = false;
    sectionId = null;
    subjectId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    titleController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
    fileName = null;
    base64String = null;
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Clears all form state. Safe to call from dispose().
  void clearData() {
    isEdit = false;
    sectionId = null;
    subjectId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    titleController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
    fileName = null;
    base64String = null;

    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Do NOT notify — called from dispose(), widget tree may be locked.
  }

  void removeAttachment() {
    fileName = null;
    base64String = null;
    notifyListeners();
  }

  void setAttachment(String name, String base64, [String? path]) {
    fileName = name;
    base64String = base64;
    notifyListeners();
  }

  void setSectionId(int? id) {
    if (sectionId == id) return;
    sectionId = id;
    notifyListeners();
  }

  void setSubjectId(int? id, String? name) {
    if (subjectId == id && subjectController.text == (name ?? '')) return;
    subjectId = id;
    subjectController.text = name ?? '';
    notifyListeners();
  }

  void setCircularRecords(CircularAnnouncementResponse response) {
    circularResponse = response;
    notifyListeners();
  }

  Future<CircularAnnouncementResponse> loadTeacherCircular() async {
    try {
      CircularAnnouncementResponse response =
          await CircularAnnouncementService.getCircularAnnouncement(
            classTeacherId: localDataProvider.userData!.userName!,
            tokenId: localDataProvider.userData!.tokenId!,
          );
      setCircularRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearLibraryData() {
    circularResponse = null;
  }
}
