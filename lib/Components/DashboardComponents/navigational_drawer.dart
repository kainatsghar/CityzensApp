import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomListTile/custom_list_tile.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomDivider/custom_divider.dart';

class NavigationalDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LocalDataProvider>(
        builder: (context, value, _) => Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.1),
                    CustomUserImage(
                        userId: value.userData.userName, imageSize: 110),
                    SizedBox(height: size.height * 0.01),
                    Text(
                        value.userData.userType == 'Student'
                            ? 'Roll No: ${value.studentId}'
                            : value.userData.userType == 'Parent'
                                ? 'CNIC No: ${value.userData.userName}'
                                : 'ERP No: ${value.userData.userName}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: size.height * 0.01),
                    value.userData.userType == 'Student'
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 3.0),
                          child: Text(
                              '${HelperFunction.noNullStringText('${value.userData.info.name}')}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600)),
                        )
                        : value.userData.userType == 'Teacher'
                            ? Text(
                                '${HelperFunction.noNullStringText('${value.userData.name}')}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600))
                            : SizedBox.shrink(),
                    SizedBox(height: size.height * 0.01),
                    CustomDivider(
                        horizontalPadding: size.width * 0.05,
                        color: AppColors.whiteColor),
                    CustomListTile(
                        title: 'About Us',
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.aboutUsRoute)),
                    CustomDivider(),
                    CustomListTile(
                        title: 'App Feedback',
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.appFeedbackRoute)),
                    CustomDivider(),
                    value.userData.userType != 'Teacher'
                        ? Column(
                            children: [
                              CustomListTile(
                                  title: 'Change Password',
                                  onTap: () => AppNavigation.navigateTo(
                                      AppNavRoutes.changePasswordRoute)),
                              CustomDivider()
                            ],
                          )
                        : SizedBox.shrink(),
                    value.userData.userType == 'Parent'
                        ? Column(
                            children: [
                              CustomListTile(
                                  title: 'Challan Payment',
                                  onTap: () => AppNavigation.navigateTo(
                                      AppNavRoutes.challanPaymentRoute)),
                              CustomDivider(),
                            ],
                          )
                        : SizedBox.shrink(),
                    CustomListTile(
                        title: 'Logout', onTap: () => value.logout(context)),
                  ],
                ),
              ),
            ));
  }
}
