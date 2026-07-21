import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../provider/Appointment/appointment_provider.dart';
import '../../utils/app_constants.dart';

class ParentAppointmentComponent extends StatefulWidget {
  const ParentAppointmentComponent({super.key});

  @override
  State<ParentAppointmentComponent> createState() =>
      _ParentAppointmentComponentState();
}

class _ParentAppointmentComponentState
    extends State<ParentAppointmentComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<AppointmentProvider>(
      builder: (context, value, _) {
        var responseData = value.meetingResponse;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: responseData == null
                ? const ShowCustomMessage(message: AppConstants.noRecordFound)
                : Column(
                    children: [
                      const CustomCoverImage(
                        title: 'APPOINTMENT',
                        imagePath: 'meeting.png',
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: SizedBox(
                                //width: size.width * 0.2,
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      responseData.meetingDetails?.length,
                                  itemBuilder: (_, index) {
                                    var meeting =
                                        responseData.meetingDetails![index];
                                    String meetingDateStr = meeting.meetingDate
                                        .toString();
                                    // Assuming meetingDate is a string
                                    DateTime meetingDateTime = DateTime.parse(
                                      meetingDateStr,
                                    );
                                    String formattedDate = DateFormat(
                                      "dd'TH' MMMM yyyy",
                                    ).format(meetingDateTime);
                                    String day = DateFormat(
                                      "d",
                                    ).format(meetingDateTime);
                                    String dayOfWeek = DateFormat.EEEE()
                                        .format(meetingDateTime)
                                        .toUpperCase();

                                    value.addSuffixToDay(int.parse(day));

                                    return SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // Added

                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        dayOfWeek,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.05,
                                                      child: Card(
                                                        color: AppColors.primaryDarkBlue,
                                                        child: Center(
                                                          child: Text(
                                                            //'DATE: 14TH MAY 2024',
                                                            'DATE: $formattedDate',
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.05,
                                                      child: Card(
                                                        color: AppColors.primaryDarkBlue,
                                                        child: Center(
                                                          child: Text(
                                                            responseData
                                                                    .meetingDetails?[index]
                                                                    .meetingTime ??
                                                                '',
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // Added
                                                  children: [
                                                    Center(
                                                      child: CircleAvatar(
                                                        backgroundColor: AppColors.successGreen,
                                                        child: Text(
                                                          //'1',
                                                          //responseData.meetingDetails?[index].studentName ?? '',
                                                          (index + 1)
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // Added

                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'STUDENT NAME:',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.primaryBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.0),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: size.width * 0.43,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Card(
                                                      color: AppColors
                                                          .secondaryColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Center(
                                                          // Center align the text
                                                          child: Text(
                                                            responseData
                                                                    .meetingDetails?[index]
                                                                    .studentName ??
                                                                '',
                                                            textAlign: TextAlign
                                                                .center, // Center align the text horizontally
                                                            style: const TextStyle(
                                                              color: AppColors.primaryBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.43,
                                                  child: const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start, // Added

                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'ROLL NUMBER:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppColors.primaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.0),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.43,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start, // Added

                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.05,
                                                        child: Card(
                                                          color: AppColors
                                                              .secondaryColor,
                                                          child: Center(
                                                            child: Text(
                                                              responseData
                                                                      .meetingDetails?[index]
                                                                      .studentId
                                                                      .toString() ??
                                                                  '',
                                                              style: const TextStyle(
                                                                color: AppColors.primaryBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.43,
                                                  child: const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'CLASS:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppColors.primaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.0),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.43,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start, // Added

                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.05,
                                                        child: Card(
                                                          color: AppColors
                                                              .secondaryColor,
                                                          child: Center(
                                                            child: Text(
                                                              responseData
                                                                      .meetingDetails?[index]
                                                                      .classSection ??
                                                                  '',
                                                              style: const TextStyle(
                                                                color: AppColors.primaryBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.43,
                                                  child: const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'REASON:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppColors.primaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.0),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.05,
                                                        child: Card(
                                                          color: AppColors
                                                              .secondaryColor,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Center(
                                                              // Center align the text
                                                              child: Text(
                                                                responseData
                                                                        .meetingDetails?[index]
                                                                        .meetingReason ??
                                                                    '',
                                                                textAlign: TextAlign
                                                                    .center, // Center align the text horizontally
                                                                style: const TextStyle(
                                                                  color: AppColors.primaryBlue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ), // Adjust the height as needed
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
