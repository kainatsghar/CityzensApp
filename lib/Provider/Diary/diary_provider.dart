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

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
            diaryDate: formattedDate,
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

  void setSelectedSubject(String subjectName) {
    subjectController.text = subjectName;
    AppNavigation.goBack();
    notifyListeners();
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

  void clearData() {
    sectionId = null;
    subjectId = null;
    subjectController.clear();
    sectionController.clear();
    descriptionController.clear();
    sections = [];
    subjects = [];
    subjectResponse = SectionSubjectResponse();
    sectionResponse = TeacherSectionResponse();
  }

  void setSectionId(int? id) {
    sectionId = id;
    notifyListeners();
  }

  void setSubjectId(int? id, String? name) {
    subjectId = id;
    subjectController.text = name ?? '';
    notifyListeners();
  }

  void clearLibraryData() {
    diaryResponse = null;
  }
}
