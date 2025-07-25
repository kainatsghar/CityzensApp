import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';
import '../../Provider/ParentDashboard/parent_dashboard_provider.dart';

class MultiChildComponent extends StatelessWidget {
  const MultiChildComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Consumer2<ParentDashboardProvider, LocalDataProvider>(
        builder: (context, value, localData, _) {
          var children = value.multiChildResponse!.children;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                Flexible(
                  child: ListView.builder(
                    itemCount: children!.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: ListTile(
                          leading: CustomUserImage(
                            imageSize: size.width * 0.15,
                            userId: '${children[index].studentId}',
                          ),
                          title: Text(
                            children[index].studentName!.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTitleColor,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Text('${children[index].studentId}'),
                              ),
                              Text(children[index].className!),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.secondaryColor,
                          ),
                          onTap: () {
                            localData.setStudentId(
                              '${children[index].studentId}',
                            );
                            localData.setSGradeId(children[index].classId);
                            AppNavigation.navigateTo(
                              AppNavRoutes.studentDashboardRoute,
                              arguments: ScreenArguments(
                                userName: children[index].studentName,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
