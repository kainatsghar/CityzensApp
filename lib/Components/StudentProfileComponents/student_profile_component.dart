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
  const StudentProfileComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<StudentProfileProvider>(builder: (context, value, _) {
        var profile = value.profileResponse!.profile;
        // return profile.isEmpty || profile == null
        return profile!.isEmpty
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.03,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                              HelperFunction.noNullStringText(
                                      profile.first.name)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0))),
                      CustomUserImage(
                          userId: HelperFunction.noNullStringText(
                              '${profile.first.studentId}'),
                          disableUploadImage: false),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: CustomProfileItem(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              title: 'CAMPUS NAME',
                              value: '${profile.first.center}')),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                title: 'ROLL NUMBER',
                                value: '${profile.first.studentId}'),
                          ),
                          const SizedBox(
                              height: 30,
                              child: VerticalDivider(
                                  width: 15.0,
                                  color: AppColors.blackColor,
                                  thickness: 1)),
                          Expanded(
                            child: CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                title: 'CLASS NAME',
                                value: '${profile.first.className}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                title: 'REGION NAME',
                                value: '${profile.first.region}'),
                          ),
                          const SizedBox(
                              height: 30,
                              child: VerticalDivider(
                                  width: 15.0,
                                  color: AppColors.blackColor,
                                  thickness: 1)),
                          Expanded(
                            child: CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                title: 'DATE OF BIRTH',
                                value: HelperFunction.dateFormatter(
                                    '${profile.first.dateOfBirth}')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                            CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                width: size.width,
                                title: 'ADDRESS',
                                maxLines: 3,
                                value: '${profile.first.address}'),
                            const SizedBox(height: 2.0),
                            CustomProfileItem(
                                width: size.width,
                                title: 'CITY NAME',
                                maxLines: 2,
                                value: '${profile.first.city}'),
                            const SizedBox(height: 2.0),
                            CustomProfileItem(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                width: size.width,
                                title: 'CONTACT NUMBER',
                                maxLines: 2,
                                value: '${profile.first.contactNo}')
                          ]))
                    ])));
      }),
    );
  }
}
