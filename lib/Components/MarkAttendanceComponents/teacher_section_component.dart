import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class TeacherSectionComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Image.asset('images/tcs_logo.png',
                  height: size.width * 0.4, width: size.width * 0.4),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Attendance Date',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  )),
              CustomTextFormField(
                  labelText: HelperFunction.dateFormatter('${DateTime.now()}'),
                  isEnable: false,
                  readOnly: true,
                  prefixIcon: Icons.date_range),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Class Section',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  )),
              Form(
                key: value.formKey,
                child: CustomTextFormField(
                    hintText: 'Select',
                    controller: value.sectionController,
                    onTap: () => value.sectionBottomSheet(),
                    readOnly: true,
                    validator: value.validator,
                    suffixWidget:  ImageIcon(AssetImage('images/dropdown_icon.png'))),
              ),
              SizedBox(height: size.height * 0.04),
              CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => value.navigateToMarkAttendance())
            ],
          ),
        );
      }),
    );
  }
}
