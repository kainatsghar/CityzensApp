import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/LibraryComponents/single_library_item.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/Library/library_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class LibraryComponent extends StatelessWidget {
  const LibraryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LibraryProvider>(builder: (context, value, _) {
        var responseData = value.libraryResponse.listLibrary;
        return responseData!.isEmpty
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : ListView.builder(
                itemCount: value.libraryResponse.listLibrary!.length + 1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return CustomStudentInfo(info: value.libraryResponse.info);
                  } else {
                    index -= 1;
                    return SingleLibraryItem(record: responseData[index]);
                  }
                });
      }),
    );
  }
}
