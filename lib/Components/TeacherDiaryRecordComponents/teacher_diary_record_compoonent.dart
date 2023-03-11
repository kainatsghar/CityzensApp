import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Model/TeacherDiary/teacher_diary_response.dart';
import 'package:tcs_app/Provider/TeacherDiary/teacher_diary_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';

import '../../CustomWidgets/ShowCustomMessage/show_custom_message.dart';

class TeacherDiaryRecordComponent extends StatelessWidget {
  const TeacherDiaryRecordComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherDiaryProvider>(builder: (context, value, _) {
      List<DiaryRecords> diaryRecords = value.teacherDiaryResponse.diaryRecords;
      return Padding(
        padding: EdgeInsets.all(10),
        child: diaryRecords.isEmpty
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : GroupedListView<DiaryRecords, String>(
                elements: diaryRecords,
                groupBy: (element) => element.diaryDate,
                groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          DateFormat('MMMM dd, yyyy')
                              .format(DateTime.parse(groupByValue)),
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600)),
                    ),
                itemBuilder: (context, DiaryRecords element) => Card(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(element.subject,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600)),
                          children: <Widget>[
                            ListTile(title: Text(element.description))
                          ],
                        ),
                      ),
                    ),
                order: GroupedListOrder.ASC),
      );
    });
  }
}
