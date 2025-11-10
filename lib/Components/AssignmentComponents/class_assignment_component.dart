import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Model/Assignment/assignment_response.dart';
import 'package:tcs_app/Provider/Assignment/assignment_provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/CustomExpansionTile/custom_expansion_tile.dart';
import '../../Routes/app_navigation.dart';
import '../../Utils/app_constants.dart';

class AssignmentRecordComponent extends StatefulWidget {
  const AssignmentRecordComponent({super.key});

  @override
  State<AssignmentRecordComponent> createState() =>
      _AssignmentRecordComponentState();
}

class _AssignmentRecordComponentState extends State<AssignmentRecordComponent> {
  var localData = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileAppAttachments/$fileName',
    );
    // ignore: deprecated_member_use
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // ignore: deprecated_member_use
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future<void> _launchFile(String fileName) async {
  //   final url =
  //       'https://app.csn.edu.pk:8090/MobileAppAttachments/$fileName';
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<AssignmentProvider>(
      builder: (context, value, _) {
        List<AssignmentRecords> assignmentRecords =
            value.assignmentResponse!.assignmentRecords!;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: assignmentRecords.isEmpty
              ? const ShowMessageOnImage(
                  message: 'No recent classwork\nuploaded',
                )
              : Column(
                  children: [
                    const CustomCoverImage(
                      title: 'CLASSWORK ASSIGNMENT',
                      imagePath: 'assignment_icon.png',
                    ),
                    SizedBox(height: size.height * 0.01),
                    Flexible(
                      child: GroupedListView<AssignmentRecords, String>(
                        elements: assignmentRecords,
                        groupBy: (element) => element.classWorkDate!,
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
                        itemBuilder: (context, AssignmentRecords element) =>
                            Card(
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
                                              _launchFile(
                                                element.fileName ?? '',
                                              );
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton.filled(
                                                  style: IconButton.styleFrom(
                                                    backgroundColor: AppColors
                                                        .primaryDarkColor,
                                                  ),
                                                  onPressed: () {
                                                    _launchFile(
                                                      element.fileName ?? '',
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.download,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
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
