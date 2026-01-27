import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomExpansionTile/custom_expansion_tile.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../Model/Diary/diary_response.dart';
import '../../Provider/Diary/diary_provider.dart';
import '../../Provider/LocalData/local_data_provider.dart';
import '../../Routes/app_navigation.dart';

class DiaryRecordComponent extends StatefulWidget {
  const DiaryRecordComponent({super.key});

  @override
  State<DiaryRecordComponent> createState() => _DiaryRecordComponentState();
}

class _DiaryRecordComponentState extends State<DiaryRecordComponent> {
  var localData = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  // Future<void> _launchFile(String fileName) async {
  //   final url =
  //       'https://app.csn.edu.pk:8090/MobileAppAttachments/DailyDiary/$fileName';
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileAppAttachments/DailyDiary/$fileName',
    );

    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<DiaryProvider>(
      builder: (context, value, _) {
        List<DiaryRecords> diaryRecords = value.diaryResponse!.diaryRecords!;
        return Padding(
          padding: const EdgeInsets.all(10),
          // child: diaryRecords == null || diaryRecords.isEmpty
          child: diaryRecords.isEmpty
              ? const ShowMessageOnImage(
                  message: 'No recent homework\n uploaded',
                )
              : Column(
                  children: [
                    const CustomCoverImage(
                      title: 'HOMEWORK DIARY',
                      imagePath: 'diary_icon.png',
                    ),
                    SizedBox(height: size.height * 0.02),
                    Flexible(
                      child: GroupedListView<DiaryRecords, String>(
                        elements: diaryRecords,
                        groupBy: (element) => element.diaryDate!,
                        groupSeparatorBuilder: (String groupByValue) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat(
                              'MMMM dd, yyyy',
                            ).format(DateTime.parse(groupByValue)),
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        itemBuilder: (context, DiaryRecords element) => Card(
                          child: CustomExpansionTile(
                            title: '${element.subject}',
                            children: <Widget>[
                              ListTile(title: Text(element.description!)),
                              (element.fileName != null &&
                                      element.fileName != "")
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _launchFile(element.fileName ?? '');
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                element.fileName ?? '',
                                                style: const TextStyle(
                                                  color: AppColors
                                                      .primaryDarkColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8), // Spacer
                                            IconButton.filled(
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryDarkColor,
                                              ),
                                              onPressed: () {
                                                _launchFile(
                                                  element.fileName ?? '',
                                                );
                                              },
                                              icon: const Icon(Icons.download),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              // ListTile(
                              //   title: GestureDetector(
                              //     onTap: () {
                              //       // Replace 'image.png' with your actual file path

                              //       _launchFile(
                              //         element.fileName ?? '',
                              //       );
                              //     },
                              //     child: Row(
                              //       children: [
                              //         const Icon(
                              //             Icons.download), // Download icon
                              //         const SizedBox(width: 8), // Spacer
                              //         Text(
                              //           element.fileName ?? '',
                              //           style: const TextStyle(
                              //               color:
                              //                   AppColors.primaryDarkColor),
                              //         ), // File name text
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        order: GroupedListOrder.DESC,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
