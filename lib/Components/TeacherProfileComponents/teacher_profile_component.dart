import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomProfileItem/custom_profile_item.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class TeacherProfileComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Consumer<TeacherProfileProvider>(builder: (context, value, _) {
      return value.profileResponse == null
          ? ShowError(errorText: AppConstants.noRecordFound)
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Column(children: <Widget>[
                  CustomUserImage(
                      userId: '${value.profileResponse.employeeCode}',
                      disableUploadImage: false),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                          HelperFunction.noNullStringText(
                              '${value.profileResponse.teacherName}'),
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0))),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                          HelperFunction.noNullStringText(
                              '${value.profileResponse.branch}'),
                          style: TextStyle(color: Colors.black54))),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'ERP Number',
                            value: HelperFunction.noNullStringText(
                                '${value.profileResponse.employeeCode}')),
                        SizedBox(
                            height: 30,
                            child: VerticalDivider(
                                width: 1.0,
                                color: AppColors.blackColor,
                                thickness: 1)),
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'Designation',
                            value: '${value.profileResponse.designation}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'Marital Status',
                            value:
                                '${value.profileResponse.maritalStatus == 'M' ? 'Married' : 'Single'}'),
                        SizedBox(
                            height: 30,
                            child: VerticalDivider(
                                width: 1.0,
                                color: AppColors.blackColor,
                                thickness: 1)),
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'Religion',
                            value: value.profileResponse.religion),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'Region',
                            value: '${value.profileResponse.region}'),
                        SizedBox(
                            height: 30,
                            child: VerticalDivider(
                                width: 1.0,
                                color: AppColors.blackColor,
                                thickness: 1)),
                        CustomProfileItem(
                            width: size.width / 2.5,
                            title: 'City',
                            value: value.profileResponse.city),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CustomProfileItem(
                          width: size.width,
                          title: 'Address',
                          value: '${value.profileResponse.address}')),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CustomProfileItem(
                        width: size.width,
                        title: 'CNIC Number',
                        value: '${value.profileResponse.cnicNumber}'),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CustomProfileItem(
                        width: size.width,
                        title: 'Email Address',
                        value: '${value.profileResponse.email}'),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CustomProfileItem(
                        width: size.width,
                        title: 'Contact Number',
                        value: '${value.profileResponse.employeeCell}'),
                  ),
                ]),
              ),
            );
    }));
  }
}
