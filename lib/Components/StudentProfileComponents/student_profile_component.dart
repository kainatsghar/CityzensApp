import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomProfileItem/custom_profile_item.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class StudentProfileComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<StudentProfileProvider>(builder: (context, value, _) {
        var profile = value.profileResponse.profile;
        return profile.isEmpty || profile == null
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.03),
                  child: Column(
                    children: <Widget>[
                      CustomUserImage(
                          userId: '${profile.first.studentId}',
                          disableUploadImage: false),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(profile.first.name,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0))),
                      Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(profile.first.center,
                              style: TextStyle(color: Colors.black54))),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CustomProfileItem(
                                width: size.width / 2.5,
                                title: 'Roll Number',
                                value: '${profile.first.studentId}'),
                            SizedBox(
                                height: 30,
                                child: VerticalDivider(
                                    width: 1.0,
                                    color: AppColors.blackColor,
                                    thickness: 1)),
                            CustomProfileItem(
                                width: size.width / 2.5,
                                title: 'Class Name',
                                value: '${profile.first.className}'),
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
                                title: 'Region Name',
                                value: '${profile.first.region}'),
                            SizedBox(
                                height: 30,
                                child: VerticalDivider(
                                    width: 1.0,
                                    color: AppColors.blackColor,
                                    thickness: 1)),
                            CustomProfileItem(
                                width: size.width / 2.5,
                                title: 'Date of Birth',
                                value: HelperFunction.dateFormatter(
                                    '${profile.first.dateOfBirth}')),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CustomProfileItem(
                            width: size.width,
                            title: 'Address',
                            value: '${profile.first.address}'),
                      ),
                      SizedBox(height: 5.0),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CustomProfileItem(
                            width: size.width,
                            title: 'City Name',
                            value: '${profile.first.city}'),
                      ),
                      SizedBox(height: 5.0),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CustomProfileItem(
                            width: size.width,
                            title: 'Contact Number',
                            value: '${profile.first.contactNo}'),
                      ),
                    ],
                  ),
                ));
      }),
    );
  }
}
