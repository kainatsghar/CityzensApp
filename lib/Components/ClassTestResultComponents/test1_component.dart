import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomTestResultFormField/custom_test_result_form_field.dart';
import '../../Model/ClassTestResult/class_test_student_list_response.dart';
import '../../Provider/ClassTestResult/class_test_result_provider.dart';
import '../../Utils/app_colors.dart';

class Test1Component extends StatelessWidget {
  const Test1Component({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Consumer<ClassTestResultProvider>(
        builder: (context, value, _) {
          value.categoryId = 1;
          List<ClassTestStudent> studentList =
              value.classTestResultStudentResponse!.studentList!;
          return Column(
            children: [
              SizedBox(height: size.height * 0.015),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromARGB(255, 240, 240, 240),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'ADD MAX MARKS',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 204, 204, 204),
                      fontSize: 20,
                    ),
                    alignLabelWithHint: true, // Align label with hint
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  textAlign: TextAlign.center, // Center input value
                  keyboardType: TextInputType.number,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  controller:
                      TextEditingController(
                          text: value.totalMarks != 0
                              ? value.totalMarks.toString()
                              : '',
                        )
                        ..selection = TextSelection.collapsed(
                          offset: value.totalMarks != 0
                              ? value.totalMarks.toString().length
                              : 0,
                        ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: (val) {
                    int? total = val.isEmpty
                        ? 0
                        : int.tryParse(val) ?? value.totalMarks;
                    value.totalMarks = total;
                    // Handle value change
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.whiteColor,
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.4,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: AppColors.whiteColor,
                                width: 0,
                              ),
                            ),
                          ),
                          child: const Text(
                            'STUDENTS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.44,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: const Text(
                            'OBTAINED MARKS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    ...studentList.map(
                      (e) => Row(
                        children: [
                          Container(
                            width: size.width * 0.4,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                              ),
                            ),
                            child: Text(
                              e.studentName!.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.44,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.grey, width: 1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 0,
                                bottom: 10,
                                left: 25,
                              ),
                              child: CustomTestResultFormField(
                                inputType: TextInputType.number,
                                controller:
                                    TextEditingController(
                                        text: e.obtainedMarks.toString(),
                                      )
                                      ..selection = TextSelection.collapsed(
                                        offset: e.obtainedMarks
                                            .toString()
                                            .length,
                                      ),
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                onChange: (marks) {
                                  // Remove non-numeric characters
                                  marks = marks.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );
                                  int? obtainedMarks = marks.isEmpty
                                      ? 0
                                      : int.tryParse(marks) ?? e.obtainedMarks;
                                  value.updateObtainedMarks(
                                    studentList.indexOf(e),
                                    obtainedMarks!,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    CustomAppButton(
                      buttonTitle: 'SAVE',
                      onTap: () => {value.submitAllMarks()},
                    ),
                    SizedBox(height: size.height * 0.06),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
