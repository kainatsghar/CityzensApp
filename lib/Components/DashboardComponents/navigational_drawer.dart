import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomListTile/custom_list_tile.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';

class NavigationalDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDataProvider>(
        builder: (context, value, _) => Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(value.userData.userType == 'Student'
                          ? 'Roll No: ${value.studentId}'
                          : value.userData.userType == 'Parent'
                              ? 'CNIC No: ${value.userData.userName}'
                              : 'ERP No: ${value.userData.userName}'),
                      accountEmail: value.userData.userType == 'Student'
                          ? Text('Name: ${value.userData.info.name}')
                          : value.userData.userType == 'Teacher'
                              ? Text('Name: ${value.userData.name}')
                              : SizedBox.shrink(),
                      currentAccountPicture:
                          CustomUserImage(userId: value.userData.userName),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/header.jpg'),
                              fit: BoxFit.fill)),
                    ),
                    CustomListTile(
                        title: 'About Us',
                        icon: Icons.home,
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.aboutUsRoute)),
                    Divider(),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text('Others',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                            textAlign: TextAlign.left)),
                    CustomListTile(
                        title: 'App Feedback',
                        icon: Icons.thumb_up,
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.appFeedbackRoute)),
                    CustomListTile(
                        title: 'About App',
                        icon: Icons.phone_android,
                        onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.aboutAppRoute)),
                    value.userData.userType != 'Teacher'
                        ? CustomListTile(
                            title: 'Change Password',
                            icon: Icons.vpn_key,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.changePasswordRoute))
                        : SizedBox.shrink(),
                    CustomListTile(
                        title: 'Logout',
                        icon: Icons.lock,
                        onTap: () => value.logout(context)),
                  ],
                ),
              ),
            ));
  }
}
