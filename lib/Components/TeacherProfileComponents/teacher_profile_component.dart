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
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.03,
                    horizontal: size.width * 0.035),
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                          HelperFunction.noNullStringText(
                              '${value.profileResponse.teacherName}'.toUpperCase()),
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0))),
                  CustomUserImage(
                      userId: '${value.profileResponse.employeeCode}',
                      disableUploadImage: false),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: CustomProfileItem(
                          width: size.width,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          title: 'BRANCH NAME',
                          value: '${value.profileResponse.branch}')),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            title: 'ERP NUMBER',
                            value: '${value.profileResponse.employeeCode}'),
                      ),
                      SizedBox(
                          height: 30,
                          child: VerticalDivider(
                              width: 15.0,
                              color: AppColors.blackColor,
                              thickness: 1)),
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            title: 'DESIGNATION',
                            value: '${value.profileResponse.designation}'),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            title: 'MARITAL STATUS',
                            value:
                                '${value.profileResponse.maritalStatus == 'M' ? 'Married' : 'Single'}'),
                      ),
                      SizedBox(
                          height: 30,
                          child: VerticalDivider(
                              width: 15.0,
                              color: AppColors.blackColor,
                              thickness: 1)),
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            title: 'RELIGION',
                            value: value.profileResponse.religion),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            title: 'REGION',
                            value: '${value.profileResponse.region}'),
                      ),
                      SizedBox(
                          height: 30,
                          child: VerticalDivider(
                              width: 15.0,
                              color: AppColors.blackColor,
                              thickness: 1)),
                      Expanded(
                        child: CustomProfileItem(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            title: 'CITY',
                            value: value.profileResponse.city),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  CustomProfileItem(
                      width: size.width,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      title: 'ADDRESS',
                      value: '${value.profileResponse.address}'),
                  SizedBox(height: 5.0),
                  CustomProfileItem(
                      width: size.width,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      title: 'CNIC NUMBER',
                      value: '${value.profileResponse.cnicNumber}'),
                  SizedBox(height: 5.0),
                  CustomProfileItem(
                      width: size.width,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      title: 'EMAIL ADDRESS',
                      value: '${value.profileResponse.email}'),
                  SizedBox(height: 5.0),
                  CustomProfileItem(
                      width: size.width,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      title: 'CONTACT NUMBER',
                      value: '${value.profileResponse.employeeCell}'),
                ]),
              ),
            );
    }));
  }
}
