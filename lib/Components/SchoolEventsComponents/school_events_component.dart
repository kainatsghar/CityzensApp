import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/SchoolEvents/school_event_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../Utils/app_constants.dart';

class SchoolEventsComponent extends StatelessWidget {
  const SchoolEventsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<SchoolEventProvider>(
      builder: (context, value, _) {
        var eventList = value.eventResponse?.eventList;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: eventList!.isEmpty
              ? const ShowCustomMessage(message: AppConstants.noRecordFound)
              : Column(
                  children: [
                    const CustomCoverImage(
                      title: 'SCHOOL EVENTS',
                      imagePath: 'calendar.png',
                    ),
                    SizedBox(height: size.height * 0.01),
                    Flexible(
                      child: ListView.builder(
                        itemCount: eventList.length,
                        itemBuilder: (context, index) {
                          var event = eventList[index];
                          String formattedDate = DateFormat(
                            'EEEE, d MMMM yyyy',
                          ).format(event.eventDate!);

                          return Column(
                            children: [
                              Container(
                                width: size.width * 0.8,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    formattedDate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryTitleColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    event.eventName ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
