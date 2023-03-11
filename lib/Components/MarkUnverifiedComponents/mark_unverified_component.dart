import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import '../../Provider/MarkUnverified/mark_unverified_provider.dart';

class MarkUnverifiedComponent extends StatelessWidget {
  const MarkUnverifiedComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.all(20),
        child: Consumer<MarkUnverifiedProvider>(builder: (context, value, _) {
          return Form(
            key: value.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('images/logo_horizontal.png',
                      height: size.width * 0.2, width: size.width * 0.55),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      controller: value.studentIdController,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      labelText: 'Roll Number'),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      controller: value.studentNameController,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      labelText: 'Student Name',
                      validator: value.validator),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      labelText: 'Select Section',
                      hintText: 'Select',
                      controller: value.sectionController,
                      onTap: () => value.sectionBottomSheet(),
                      readOnly: true,
                      validator: value.validator,
                      suffixWidget:
                          ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      labelText: 'Select Reason',
                      hintText: 'Select',
                      controller: value.reasonController,
                      onTap: () => value.reasonsBottomSheet(),
                      readOnly: true,
                      validator: value.validator,
                      suffixWidget:
                          ImageIcon(AssetImage('images/dropdown_icon.png'))),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                      controller: value.remarksController,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      maxLines: 3,
                      labelText: 'Remarks',
                      validator: value.validator),
                  SizedBox(height: size.height * 0.04),
                  CustomAppButton(
                      buttonTitle: 'Save', onTap: () => value.markUnverified())
                ],
              ),
            ),
          );
        }));
  }
}
