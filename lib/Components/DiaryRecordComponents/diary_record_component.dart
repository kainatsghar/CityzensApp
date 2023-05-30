import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomExpansionTile/custom_expansion_tile.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';

import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import '../../Model/Diary/diary_response.dart';
import '../../Provider/Diary/diary_provider.dart';

class DiaryRecordComponent extends StatelessWidget {
  const DiaryRecordComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<DiaryProvider>(builder: (context, value, _) {
      List<DiaryRecords> diaryRecords = value.diaryResponse.diaryRecords;
      return Padding(
        padding: EdgeInsets.all(10),
        child: diaryRecords == null || diaryRecords.isEmpty
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : Column(
                children: [
                  CustomCoverImage(
                      title: 'HOMEWORK DIARY', imagePath: 'diary_icon.png'),
                  SizedBox(height: size.height * 0.02),
                  Flexible(
                    child: GroupedListView<DiaryRecords, String>(
                        elements: diaryRecords,
                        groupBy: (element) => element.diaryDate,
                        groupSeparatorBuilder: (String groupByValue) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                DateFormat('MMMM dd, yyyy')
                                    .format(DateTime.parse(groupByValue)),
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600))),
                        itemBuilder: (context, DiaryRecords element) => Card(
                                child: CustomExpansionTile(
                                    title: '${element.subject}',
                                    children: <Widget>[
                                  ListTile(title: Text(element.description))
                                ])),
                        order: GroupedListOrder.ASC),
                  ),
                ],
              ),
      );
    });
  }
}
