import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import '../../Provider/Circular/circular_provider.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/helper_function.dart';

class AddCircularComponent extends StatefulWidget {
  const AddCircularComponent({super.key});

  @override
  State<AddCircularComponent> createState() => _AddDiaryComponentState();
}

class _AddDiaryComponentState extends State<AddCircularComponent> {
  List<File?> files = [];
  String? fileName;
  String? base64;

  @override
  void initState() {
    super.initState();
    fileName = ''; // Set fileName to empty string when the page loads
    base64 = ''; // Set base64 to empty string when the page loads
  }

  void uploadAttachment() async {
    fileName = "";
    base64 = "";
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
    //saveBase64StringToFile(base64Encode(fileBytes));
    return base64Encode(fileBytes);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Consumer<CircularProvider>(builder: (context, value, _) {
          value.base64String = base64;
          value.fileName = fileName;
          return SingleChildScrollView(
            child: Column(
              children: [
                const CustomCoverImage(
                    title: 'CIRCULARS', imagePath: 'notification_icon.png'),
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
                                          child: Text(files.length.toInt() == 0
                                              ? ''
                                              : fileName.toString()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          onTap: () => uploadAttachment(),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'images/attachment.png',
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
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'images/attachment.png',
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
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 25.0),
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                            hintText: 'Select Section',
                            controller: value.sectionController,
                            onTap: () => value.sectionBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.whiteColor)),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                            hintText: 'Select Subject',
                            controller: value.subjectController,
                            onTap: () => value.subjectBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                                AssetImage('images/dropdown_icon.png'),
                                color: AppColors.whiteColor)),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                            controller: value.titleController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            maxLines: 1,
                            hintText: 'Title',
                            validator: HelperFunction.validator),
                        SizedBox(height: size.height * 0.02),
                        CustomTextFormField(
                            controller: value.descriptionController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            maxLines: 3,
                            hintText: 'Description',
                            validator: HelperFunction.validator),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                CustomAppButton(
                    buttonTitle: 'Save', onTap: () => value.submitCircular())
              ],
            ),
          );
        }),
      ),
    );
  }
}
