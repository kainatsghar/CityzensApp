import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/AddDiary/add_diary_service.dart';
import 'package:tcs_app/services/StudentDiary/student_diary_service.dart';
import 'package:tcs_app/services/TeacherDiary/teacher_diary_service.dart';

import '../../custom_widgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/AddDiary/add_diary_request.dart';
import '../../model/Diary/diary_response.dart';
import '../../model/TeacherActions/update_diary_request.dart';
import '../../model/TeacherActions/delete_action_request.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../../model/SectionSubject/section_subject_response.dart';
import '../../services/SectionSubject/section_subject_service.dart';
import '../../services/TeacherSection/teacher_section_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../model/Options/options.dart';
import '../../model/TeacherSection/teacher_section_response.dart';

class DiaryProvider with ChangeNotifier {
  DiaryResponse? diaryResponse;
  bool isEdit = false;
  final sectionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int? sectionId;
  int? subjectId;

  List<Options> sections = [];
  List<Options> subjects = [];

  String? fileName;
  String? base64String;

  String? selectedDate;

  DiaryProvider() {
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

  void setDiaryRecords(DiaryResponse response) {
    diaryResponse = response;
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

  Future<void> submitDiary() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await AddDiaryService.addDiary(
          AddDiaryRequest(
            subject: subjectController.text,
            sectionId: sectionId,
            classTeacherId: localDataProvider.userData!.userName,
            diaryDate: selectedDate,
            description: descriptionController.text,
            tokenId: localDataProvider.userData!.tokenId,
            fileName: fileName ?? '',
            filePath: base64String ?? '',
          ),
        );
        if (response.isSuccess!) {
          await loadTeacherDiary();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Diary Added Successfully',
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

  Future<void> updateDiary(DiaryRecords existingRecord) async {
    isEdit = true;
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        ResponseMessage response = await TeacherDiaryService.updateDiary(
          UpdateDiaryRequest(
            tokenId: localDataProvider.userData!.tokenId,
            id: existingRecord.id.toString(),
            subject: subjectController.text,
            description: descriptionController.text,
            diaryDate: selectedDate,
            classTeacherId: existingRecord.classTeacherId.toString(),
            sectionId: existingRecord.sectionId,
            fileName: fileName ?? '',
            base64String: base64String,
          ),
        );
        if (response.isSuccess!) {
          await loadTeacherDiary();
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Diary Updated Successfully',
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

  Future<void> deleteDiary(int id) async {
    DialogBuilder.showLoadingIndicator();
    try {
      ResponseMessage response = await TeacherDiaryService.deleteDiary(
        DeleteActionRequest(
          tokenId: localDataProvider.userData!.tokenId,
          id: id,
        ),
      );
      if (response.isSuccess!) {
        await loadTeacherDiary();
        showSnackBar(
          'Diary Deleted Successfully',
          color: AppColors.successGreenColor,
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
  /// IMPORTANT: Does NOT call notifyListeners — it must be called from
  /// addPostFrameCallback, where notifying the tree is unsafe.
  /// The caller (resolveIds) will fire the single notification.
  void initForEdit(DiaryRecords record) {
    isEdit = true;
    subjectController.text = record.subject ?? '';
    descriptionController.text = record.description ?? '';
    sectionController.text = record.sectionName ?? '';
    selectedDate = record.diaryDate;
    fileName = record.fileName;
    base64String = null;
    // No notifyListeners here — resolveIds will do it once.
  }

  /// Resolves sectionId/subjectId from names stored in controllers after
  /// initForEdit sets the text. Fires a SINGLE notifyListeners at the end
  /// so the TabSelector rebuilds with the correct initialItemName.
  void resolveIds(
    List<Section> availableSections,
    List<SectionSubject> availableSubjects,
  ) {
    if (sectionController.text.isNotEmpty) {
      final matchedSection = availableSections.cast<Section?>().firstWhere(
        (s) => s?.name == sectionController.text,
        orElse: () => null,
      );
      if (matchedSection != null) {
        sectionId = matchedSection.classSectionId;
      }
    }

    if (subjectController.text.isNotEmpty) {
      final matchedSubject = availableSubjects
          .cast<SectionSubject?>()
          .firstWhere(
            (s) => s?.subjectName == subjectController.text,
            orElse: () => null,
          );
      if (matchedSubject != null) {
        subjectId = matchedSubject.subjectId;
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

  Future<DiaryResponse> loadTeacherDiary() async {
    try {
      DiaryResponse response = await TeacherDiaryService.getDiaryRecords(
        userName: localDataProvider.userData!.userName!,
        tokenId: localDataProvider.userData!.tokenId!,
      );
      setDiaryRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<DiaryResponse> loadStudentDiary() async {
    try {
      DiaryResponse response = await StudentDiaryService.getDiaryRecords(
        userName: localDataProvider.studentId,
        tokenId: localDataProvider.userData!.tokenId!,
      );
      setDiaryRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  /// Clears all form state. Use from dispose() to avoid notifying
  /// a locked widget tree. Any active consumers will not be rebuilt
  /// (they are being disposed anyway).
  void clearData() {
    isEdit = false;
    sectionId = null;
    subjectId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
    fileName = null;
    base64String = null;
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Do NOT notify — callers (dispose) run during widget teardown.
    // Any screen that needs a fresh state will call clearData() on initState
    // or the data will be reset naturally when they navigate in.
  }

  void removeAttachment() {
    fileName = null;
    base64String = null;
    notifyListeners();
  }

  void setAttachment(String name, String base64) {
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

  void clearLibraryData() {
    diaryResponse = null;
  }
}
