import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/TabSelector/tab_selector.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';
import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../provider/Dashboard/dashboard_provider.dart';
import '../../provider/Diary/diary_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper_function.dart';

class AddDiaryComponent extends StatefulWidget {
  const AddDiaryComponent({super.key});

  @override
  State<AddDiaryComponent> createState() => _AddDiaryComponentState();
}

class _AddDiaryComponentState extends State<AddDiaryComponent> {
  List<File?> files = [];
  String? fileName;
  String? base64;

  void uploadAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
        fileName = files.first!.path.split('/').last;
      });

      if (files.isNotEmpty) {
        File file = files.first!;
        base64 = await fileToBase64(file);
      }
    }
  }

  Future<String> fileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<DiaryProvider>(
        builder: (context, value, _) {
          value.base64String = base64;
          value.fileName = fileName;
          return SingleChildScrollView(
            child: Column(
              children: [
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.01),
                Stack(
                  children: [
                    Positioned(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: files.length.toInt() != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.45,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Card(
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            files.length.toInt() == 0
                                                ? ''
                                                : fileName.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: InkWell(
                                          onTap: () => uploadAttachment(),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Image.asset(
                                                'assets/images/attachment.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          'UPLOAD\nATTACHMENT',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: () => uploadAttachment(),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/attachment.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'UPLOAD\nATTACHMENT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                CustomCard(
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Section',
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Consumer<DashboardProvider>(
                          builder: (context, dashboardValue, _) {
                            return TabSelector<Section>(
                              items: dashboardValue.getSectionsWithDiary(true),
                              getDisplayText: (section) =>
                                  section.name ?? 'N/A',
                              onItemSelected: (section) {
                                value.sectionController.text =
                                    section.name ?? '';
                                value.setSectionId(section.classSectionId ?? 0);
                                // Reset subject when section changes
                                value.subjectController.clear();
                                value.setSubjectId(null, null);
                              },
                              initialItemName: value.sectionController.text,
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Text(
                          'Select Subject',
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Consumer<DashboardProvider>(
                          builder: (context, dashboardValue, _) {
                            return TabSelector<SectionSubject>(
                              key: ValueKey(value.sectionId),
                              items: dashboardValue.getSubjectsForSection(
                                classSectionId: value.sectionId ?? 0,
                                isDiary: true,
                              ),
                              getDisplayText: (subject) =>
                                  subject.subjectName ?? 'N/A',
                              onItemSelected: (subject) {
                                value.setSubjectId(
                                  subject.subjectId,
                                  subject.subjectName,
                                );
                              },
                              initialItemName: value.subjectController.text,
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                          controller: value.descriptionController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          maxLines: 3,
                          hintText: 'Description',
                          validator: HelperFunction.validator,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                CustomAppButton(
                  buttonTitle: 'Save',
                  onTap: () => value.submitDiary(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
