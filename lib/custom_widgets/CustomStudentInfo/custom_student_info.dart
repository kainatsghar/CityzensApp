import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomStudentInfo extends StatelessWidget {
  final dynamic info;

  const CustomStudentInfo({super.key, this.info});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      color: AppColors.primaryLightBlue,
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                info.name,
                style: const TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: size.width * 0.25,
              width: size.width * 0.25,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: CustomUserImage(userId: '${info.rollNo}'),
            ),
            Column(
              children: [
                StudentInfoRowItems(
                  firstTitle: 'BRANCH',
                  firstValue: info.centerName.toString(),
                  secondTitle: 'ROLL NUMBER',
                  secondValue: info.rollNo.toString(),
                ),
                SizedBox(height: 8.0),
                StudentInfoRowItems(
                  firstTitle: 'REGION',
                  firstValue: info.regionName.toString(),
                  secondTitle: 'CLASS',
                  secondValue: info.className.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentInfoRowItems extends StatelessWidget {
  const StudentInfoRowItems({
    super.key,
    required this.firstTitle,
    required this.firstValue,
    required this.secondTitle,
    required this.secondValue,
  });

  final String firstTitle;
  final String firstValue;
  final String secondTitle;
  final String secondValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final titleTextStyle = TextStyle(
      color: AppColors.primaryTitleColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    final valueTextStyle = const TextStyle(color: Colors.black54, fontSize: 12);
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: (size.width * 0.43) - 8,
            child: Column(
              children: [
                Text(firstTitle, style: titleTextStyle),
                const SizedBox(height: 2.0),
                Text(
                  firstValue,
                  textAlign: TextAlign.center,
                  style: valueTextStyle,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                  width: 0,
                  color: AppColors.blackColor,
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(
            width: (size.width * 0.43) - 8,
            child: Column(
              children: [
                Text(secondTitle, style: titleTextStyle),
                const SizedBox(height: 2.0),
                Text(secondValue, style: valueTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
