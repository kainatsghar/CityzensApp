import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import '../../Provider/Diary/diary_provider.dart';
import '../../Utils/helper_function.dart';

class AddDiaryComponent extends StatelessWidget {
  const AddDiaryComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<DiaryProvider>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: Form(
              key: value.formKey,
              child: Column(
                children: [
                  Image.asset('images/logo_horizontal.png',
                      height: size.width * 0.2, width: size.width * 0.55),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      hintText: 'Select',
                      labelText: 'Select Section',
                      controller: value.sectionController,
                      onTap: () => value.sectionBottomSheet(),
                      readOnly: true,
                      validator: HelperFunction.validator,
                      suffixWidget:
                          ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      hintText: 'Select',
                      labelText: 'Select Subject',
                      controller: value.subjectController,
                      onTap: () => value.subjectBottomSheet(),
                      readOnly: true,
                      validator: HelperFunction.validator,
                      suffixWidget:
                          ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      controller: value.descriptionController,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      maxLines: 3,
                      labelText: 'Description',
                      validator: HelperFunction.validator),
                  SizedBox(height: size.height * 0.04),
                  CustomAppButton(
                      buttonTitle: 'Save', onTap: () => value.submitDiary())
                ],
              ),
            ),
          );
        }));
  }
}
