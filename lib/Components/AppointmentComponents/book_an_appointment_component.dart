import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import '../../Provider/Appointment/appointment_provider.dart';
import '../../Utils/app_constants.dart';

class BookAnAppointmentComponent extends StatelessWidget {
  const BookAnAppointmentComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Consumer<AppointmentProvider>(builder: (context, value, _) {
        var responseData = value.appointmentResponse;
        var days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: responseData == null
                ? const ShowCustomMessage(message: AppConstants.noRecordFound)
                : Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        const CustomCoverImage(
                            title: 'APPOINTMENT', imagePath: 'booking.png'),
                        SizedBox(height: size.height * 0.01),
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.all(5.0),
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: size.width * 0.36,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // Added

                                      children: [
                                        Text('STUDENT NAME:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.bold)),
                                        //SizedBox(height: 2.0),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.53,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // Added

                                      children: [
                                        SizedBox(
                                          //height: size.height * 0.04,
                                          width: size.width * 0.8,
                                          child: Card(
                                            color: const Color.fromARGB(
                                                255, 235, 234, 234),
                                            child: Center(
                                              child: Text(
                                                  responseData
                                                          .profile!.fullName ??
                                                      '',
                                                  style:
                                                      const TextStyle(
                                                          color:
                                                              Color.fromARGB(
                                                                  255,
                                                                  83,
                                                                  83,
                                                                  83),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                            ),
                                          ),
                                        ),
                                        //const SizedBox(height: 2.0),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: size.width * 0.36,
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start, // Added

                                          children: [
                                            Text(
                                              'ROLL NUMBER:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 2.0),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.53,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start, // Added

                                          children: [
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: Card(
                                                color: const Color.fromARGB(
                                                    255, 235, 234, 234),
                                                child: Center(
                                                  child: Text(
                                                      responseData
                                                          .profile!.studentId
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 83, 83, 83),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: size.width * 0.36,
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'CLASS:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 2.0),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.53,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start, // Added

                                          children: [
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: Card(
                                                color: const Color.fromARGB(
                                                    255, 235, 234, 234),
                                                child: Center(
                                                  child: Text(
                                                      responseData.profile!
                                                              .className ??
                                                          '',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 83, 83, 83),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                          ],
                                        ),
                                      )
                                    ]),
                              )
                            ])),
                        SizedBox(height: size.height * 0.01),
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Added
                            children: [
                              Text(
                                'Who would you like to have a meeting with ?',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign:
                                    TextAlign.start, // Added textAlign property
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Stack(
                          children: [
                            Divider(
                              color: AppColors
                                  .primaryColor, // Set the color of the line
                              height: 20, // Set the height of the line
                              thickness: 4, // Set the thickness of the line
                              indent: size.width *
                                  0.1, // Set the indent of the line
                              endIndent: size.width *
                                  0.1, // Set the endIndent of the line
                            ),
                            Positioned(
                              //bottom: 0,
                              top: 1,
                              left: size.width * 0.5 -
                                  30, // Adjust the position of the arrow
                              child: const Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 32,
                                color: AppColors
                                    .primaryColor, // Set the color of the arrow
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: SizedBox(
                            width: size.width *
                                0.8, // Set the width of the selection card
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  responseData.appointmentTeacherTypes?.length,
                              itemBuilder: (_, index) {
                                int appointmentType = responseData
                                        .appointmentTeacherTypes?[index].id ??
                                    0;
                                return SizedBox(
                                  height: size.height * 0.05,
                                  child: GestureDetector(
                                    onTap: () {
                                      value.setSelectedType(appointmentType);
                                    },
                                    child: Card(
                                      elevation: 2,
                                      color: value.selectedTeacherType ==
                                              appointmentType
                                          ? AppColors.primaryDarkColor
                                          : AppColors.secondaryColor,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          responseData
                                                  .appointmentTeacherTypes?[
                                                      index]
                                                  .type ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: value.selectedTeacherType ==
                                                    appointmentType
                                                ? AppColors.whiteColor
                                                : AppColors.primaryDarkColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Added
                            children: [
                              Text(
                                'Please select date and time.',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign:
                                    TextAlign.start, // Added textAlign property
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, right: 10.0, left: 10.0),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'DAY',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'TIME',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Positioned(
                                    //bottom: 0,
                                    top: 1,
                                    left: size.width * 0.5 -
                                        40, // Adjust the position of the arrow
                                    child: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 32,
                                      color: AppColors
                                          .primaryColor, // Set the color of the arrow
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width *
                                        0.4, // Set the width of the selection card
                                    child: ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: days.length,
                                      itemBuilder: (_, index) {
                                        final appointmentDay =
                                            days[index].toUpperCase();
                                        return SizedBox(
                                          height: size.height * 0.04,
                                          child: GestureDetector(
                                            onTap: () {
                                              value.setSelectedDate(
                                                  appointmentDay);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              elevation: 2,
                                              color: value.selectedDate ==
                                                      appointmentDay
                                                  ? AppColors.primaryDarkColor
                                                  : AppColors.secondaryColor,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  days[index].toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: value.selectedDate ==
                                                            appointmentDay
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                            .primaryDarkColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width *
                                        0.4, // Set the width of the selection card
                                    child: ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: responseData
                                          .appointmentTimeSlots?.length,
                                      itemBuilder: (_, index) {
                                        int appointmenttimeSlot = responseData
                                                .appointmentTimeSlots?[index]
                                                .id ??
                                            0;
                                        return SizedBox(
                                          height: size.height * 0.04,
                                          child: GestureDetector(
                                            onTap: () {
                                              value.setSelectedTime(
                                                  appointmenttimeSlot);
                                            },
                                            child: Card(
                                              elevation: 0,
                                              color: value.selectedTime ==
                                                      appointmenttimeSlot
                                                  ? AppColors.primaryDarkColor
                                                  : AppColors.whiteColor,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  responseData
                                                          .appointmentTimeSlots?[
                                                              index]
                                                          .time ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: value.selectedTime ==
                                                            appointmenttimeSlot
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Added
                            children: [
                              Text(
                                'What would you like to discuss?',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign:
                                    TextAlign.start, // Added textAlign property
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Stack(
                          children: [
                            Divider(
                              color: AppColors
                                  .primaryColor, // Set the color of the line
                              height: 20, // Set the height of the line
                              thickness: 4, // Set the thickness of the line
                              indent: size.width *
                                  0.1, // Set the indent of the line
                              endIndent: size.width *
                                  0.1, // Set the endIndent of the line
                            ),
                            Positioned(
                              //bottom: 0,
                              top: 1,
                              left: size.width * 0.5 -
                                  30, // Adjust the position of the arrow
                              child: const Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 32,
                                color: AppColors
                                    .primaryColor, // Set the color of the arrow
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: SizedBox(
                            width: size.width *
                                0.8, // Set the width of the selection card
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  responseData.appointmentReasons?.length,
                              itemBuilder: (_, index) {
                                int appointmentReason = responseData
                                        .appointmentReasons?[index].id ??
                                    0;
                                return SizedBox(
                                  height: size.height * 0.05,
                                  child: GestureDetector(
                                    onTap: () {
                                      value
                                          .setSelectedReason(appointmentReason);
                                    },
                                    child: Card(
                                      elevation: 2,
                                      color: value.selectedReason ==
                                              appointmentReason
                                          ? AppColors.primaryDarkColor
                                          : AppColors.secondaryColor,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          responseData
                                                  .appointmentReasons?[index]
                                                  .reason ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: value.selectedReason ==
                                                    appointmentReason
                                                ? AppColors.whiteColor
                                                : AppColors.primaryDarkColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAppButton(
                            buttonTitle: 'SAVE',
                            onTap: () => {value.submitAppointment()},
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
