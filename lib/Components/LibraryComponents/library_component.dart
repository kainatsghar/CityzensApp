import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/LibraryComponents/single_library_item.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Provider/Library/library_provider.dart';

class LibraryComponent extends StatelessWidget {
  const LibraryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LibraryProvider>(
        builder: (context, value, _) {
          var responseData = value.libraryResponse.listLibrary;
          return responseData!.isEmpty
              ? const ShowMessageOnImage(message: 'No library records found')
              : ListView.builder(
                  itemCount: value.libraryResponse.listLibrary!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return CustomStudentInfo(
                        info: value.libraryResponse.info,
                      );
                    } else {
                      index -= 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleLibraryItem(record: responseData[index]),
                      );
                    }
                  },
                );
        },
      ),
    );
  }
}
