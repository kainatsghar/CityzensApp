import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/CustomTimeTableFormField/custom_timetable_form_field.dart';
import '../../Model/TimeTable/timetable_response.dart';
import '../../Provider/TimeTable/timetable_provider.dart';

class TeacherTimeTableComponent extends StatefulWidget {
  const TeacherTimeTableComponent({super.key});

  @override
  State<TeacherTimeTableComponent> createState() =>
      _TeacherTimeTableComponentState();
}

class _TeacherTimeTableComponentState extends State<TeacherTimeTableComponent> {
  final Map<String, List<TextEditingController>> _controllers = {};

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  void dispose() {
    _controllers.forEach((day, controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    });
    super.dispose();
  }

  String getPeriodSubject(PeriodsResponse periods, int index) {
    switch (index) {
      case 0:
        return periods.subject1 ?? '';
      case 1:
        return periods.subject2 ?? '';
      case 2:
        return periods.subject3 ?? '';
      case 3:
        return periods.subject4 ?? '';
      case 4:
        return periods.subject5 ?? '';
      case 5:
        return periods.subject6 ?? '';
      case 6:
        return periods.subject7 ?? '';
      case 7:
        return periods.subject8 ?? '';
      case 8:
        return periods.subject9 ?? '';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<TimeTableProvider>(builder: (context, value, _) {
      var responseData = value.timeTableResponse;

      var days = responseData?.classTimeTableDTO?.dayLists ?? [];

      if (days.isEmpty) {
        value.isInitial = true;
        days = weekdays
            .map((day) =>
                DayListResponse(dayOfWeek: day, periods: [PeriodsResponse()]))
            .toList();
      }

      for (var day in weekdays) {
        _controllers.putIfAbsent(
            day, () => List.generate(9, (_) => TextEditingController()));
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const CustomCoverImage(
                title: 'TIMETABLE',
                imagePath: 'calendar.png',
              ),
              SizedBox(height: size.height * 0.03),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.22,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.white, width: 0),
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        child: const Text(
                          'DAY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkColor,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.728,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Center(
                            child: Text(
                              'PERIODS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDarkColor,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.22,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.white, width: 0),
                          ),
                        ),
                        child: const Text(
                          '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkColor,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      ...List.generate(
                        9,
                        (index) => Container(
                          width: size.width * 0.08,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey, width: 1),
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDarkColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...days.map((dayList) {
                    var dayName = dayList.dayOfWeek ?? '';
                    var periods = dayList.periods?.isNotEmpty == true
                        ? dayList.periods![0]
                        : PeriodsResponse();

                    _controllers.putIfAbsent(dayName,
                        () => List.generate(9, (_) => TextEditingController()));

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          width: size.width * 0.22,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.white, width: 0),
                            ),
                          ),
                          child: Card(
                            color: AppColors.primaryColor,
                            child: Center(
                              child: Text(
                                dayName.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ...List.generate(9, (index) {
                          String periodSubject =
                              getPeriodSubject(periods, index);

                          if (_controllers[dayName]![index].text.isEmpty) {
                            _controllers[dayName]![index].text = periodSubject;
                          }

                          return Container(
                            width: size.width * 0.08,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.grey, width: 1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Center(
                                child: CustomTimeTableFormField(
                                  inputType: TextInputType.text,
                                  controller: _controllers[dayName]![index],
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onChange: (newValue) {
                                    value.setValue(dayName, index, newValue);
                                  },
                                  isEnable: value.localDataProvider.userData!
                                              .userType ==
                                          'Teacher'
                                      ? true
                                      : false,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022 CLASS ASSEMBLY WILL TAKE PLACE EVERY MORNING",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 10,
                      color: AppColors.primaryDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\u2022 BREAK AFTER THE 4TH LESSON UNLESS INFORMED OTHERWISE',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 10,
                      color: AppColors.primaryDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Visibility(
                visible: value.localDataProvider.userData!.userType == 'Teacher'
                    ? true
                    : false,
                child: CustomAppButton(
                  buttonTitle: 'SAVE',
                  onTap: () => value.saveTimeTable(),
                ),
              ),
              SizedBox(height: size.height * 0.06),
            ],
          ),
        ),
      );
    });
  }
}
