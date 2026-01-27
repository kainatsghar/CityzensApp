import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_bottom_sheet.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Select',
      scrollRequired: false,
      child: Consumer<LocalDataProvider>(
        builder: (context, value, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => value.openCamera(),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: AppColors.blackColor, fontSize: 16),
                ),
                trailing: const Icon(Icons.camera),
              ),
              const Divider(height: 0.2),
              ListTile(
                onTap: () => value.openGallery(),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: AppColors.blackColor, fontSize: 16),
                ),
                trailing: const Icon(Icons.image),
              ),
              const Divider(height: 0.2),
            ],
          );
        },
      ),
    );
  }
}
