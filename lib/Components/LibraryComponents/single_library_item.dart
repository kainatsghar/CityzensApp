import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Library/library_response.dart';

class SingleLibraryItem extends StatelessWidget {
  final LibraryRecords record;

  const SingleLibraryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // border: Border.all(color: AppColors.primaryTitleColor),
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.secondaryColor,
      ),
      child: Column(
        children: <Widget>[
          CustomTitleValue(title: 'Book Title', value: record.bookTitle!),
          CustomTitleValue(title: 'Author Name', value: record.authorName!),
          CustomTitleValue(
            title: 'Issue Date',
            value: HelperFunction.dateFormatter(record.issueDate),
          ),
          CustomTitleValue(
            title: 'Due Date',
            value: HelperFunction.dateFormatter(record.dueDate),
          ),
          CustomTitleValue(
            title: 'Return Date',
            value: HelperFunction.dateFormatter(record.returnDate),
          ),
          CustomTitleValue(
            title: 'Fine Amount',
            value: 'PKR ${record.fine ?? '-'}',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
