import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';

import '../../Provider/ParentDashboard/parent_dashboard_provider.dart';

class MultiChildComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child:
        Consumer2<ParentDashboardProvider, LocalDataProvider>(
            builder: (context, value, localData, _) {
      var children = value.multiChildResponse.children;
      return ListView.builder(
          itemCount: children.length,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (BuildContext context, int index) => Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                      leading: CustomUserImage(
                          imageSize: size.width * 0.15,
                          userId: '${children[index].studentId}'),
                      title: Text(children[index].studentName.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text('${children[index].studentId}')),
                            Text(children[index].className)
                          ]),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        localData.setStudentId('${children[index].studentId}');
                        AppNavigation.navigateTo(
                            AppNavRoutes.studentDashboardRoute);
                      }))));
    }));
  }
}
