import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomStudentInfo extends StatelessWidget {
  final dynamic info;

  const CustomStudentInfo({super.key, this.info});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
        child: Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.all(5.0),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                child: Text(info.name,
                    style: const TextStyle(
                        color: AppColors.primaryTitleColor,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                  height: size.width * 0.25,
                  width: size.width * 0.25,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: CustomUserImage(userId: '${info.rollNo}')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: (size.width * 0.43) - 8,
                    child: Column(
                      children: [
                        const Text('BRANCH',
                            style: TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2.0),
                        Text(info.centerName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 30,
                      child: VerticalDivider(
                          width: 0, color: AppColors.blackColor, thickness: 1)),
                  SizedBox(
                    width: (size.width * 0.43) - 8,
                    child: Column(
                      children: [
                        const Text('ROLL NUMBER',
                            style: TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 2.0),
                        Text(
                          '${info.rollNo}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: (size.width * 0.43) - 8,
                        child: Column(
                          children: [
                            const Text(
                              'REGION',
                              style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              info.regionName,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 30,
                          child: VerticalDivider(
                              width: 0,
                              color: AppColors.blackColor,
                              thickness: 1)),
                      SizedBox(
                        width: (size.width * 0.43) - 8,
                        child: Column(
                          children: [
                            const Text('CLASS',
                                style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(info.className,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      )
                    ]),
              )
            ])));
  }
}
