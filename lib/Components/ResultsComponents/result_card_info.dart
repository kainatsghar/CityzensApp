import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/Results/results_response.dart';

class ResultCardInfo extends StatelessWidget {
  final StudentInfo stdInfo;
  final String session;
  final String term;

  const ResultCardInfo({
    super.key,
    required this.stdInfo,
    required this.term,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
              child: Text(
                '${stdInfo.name}',
                style: const TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.width * 0.25,
              width: size.width * 0.25,
              child: CustomUserImage(userId: '${stdInfo.rollNo}'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: Text(
                '${stdInfo.centerName}',
                style: const TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: size.width * 0.43,
                  child: Column(
                    children: [
                      const Text(
                        'REGION',
                        style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '${stdInfo.regionName}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: 15.0,
                    color: AppColors.blackColor,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.43,
                  child: Column(
                    children: [
                      const Text(
                        'ROLL NUMBER',
                        style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '${stdInfo.rollNo}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.43,
                    child: Column(
                      children: [
                        const Text(
                          'CLASS',
                          style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '${stdInfo.className}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      width: 15.0,
                      color: AppColors.blackColor,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.43,
                    child: Column(
                      children: [
                        const Text(
                          'SECTION',
                          style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '${stdInfo.section}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.43,
                    child: Column(
                      children: [
                        const Text(
                          'SESSION',
                          style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          session,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      width: 15.0,
                      color: AppColors.blackColor,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.43,
                    child: Column(
                      children: [
                        const Text(
                          'TERM',
                          style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          term,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
