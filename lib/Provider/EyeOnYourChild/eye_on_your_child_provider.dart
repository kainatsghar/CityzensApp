import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/AddEyeOnYourChild/add_eye_on_your_child_response.dart';
import '../../Model/EyeOnYourChild/eye_on_your_child_response.dart';
import '../../Model/ParentEyeOnYourChild/parent_eye_on_your_child_response.dart';
import '../../Services/AddEyeOnYourChild/add_eye_on_your_child_service.dart';
import '../../Services/EyeOnYourChild/eye_on_your_child_service.dart';
import '../../Routes/app_navigation.dart';
import '../../Services/ParentEyeOnYourChild/parent_eye_on_your_child_service.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../LocalData/local_data_provider.dart';

class EyeOnYourChildProvider with ChangeNotifier {
  EyeOnYourChildResponse? eyeOnChildResponse;
  ParentEyeOnYourChildResponse? parentEyeOnChildResponse;

  final formKey = GlobalKey<FormState>();

  int? selectedIndex;

  String? selectedUpdate;
  int? selectedUpdateId;
  String? selectedChild;
  int? selectedChildId;

  String? fileName1;
  String? base64String1;

  String? fileName2;
  String? base64String2;

  String? fileName3;
  String? base64String3;

  List<String>? imagePaths;

  List<File?> files = [];

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false);

  void setStudentsUpdates(ParentEyeOnYourChildResponse response) {
    parentEyeOnChildResponse = response;
    if (response.fileList != null && response.fileList!.isNotEmpty) {
      imagePaths = [
        response.fileList![0].filePath1.toString(),
        response.fileList![0].filePath2.toString(),
        response.fileList![0].filePath3.toString()
      ];
    }

    notifyListeners();
  }

  void setEyeOnYourChildRecords(EyeOnYourChildResponse response) {
    eyeOnChildResponse = response;
    notifyListeners();
  }

  void setSelectedUpdate(String reason, int id) {
    selectedUpdate = reason;
    selectedUpdateId = id;
    notifyListeners();
  }

  void setSelectedChild(String child, int id) {
    selectedChild = child;
    selectedChildId = id;
    notifyListeners();
  }

  Future<void> submitEyeOnChildRecord() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        AddEyeOnYourChildResponse response =
            await AddEyeOnYourChildService.saveStudentUpdatesForParent(
          studentId: selectedChildId ?? 0,
          updateId: selectedUpdateId ?? 0,
          tokenId: localDataProvider.userData!.tokenId,
          createdBy: localDataProvider.userData!.id,
          modifiedBy: localDataProvider.userData!.id,
          fileName1: fileName1 ?? '',
          fileName2: fileName2 ?? '',
          fileName3: fileName3 ?? '',
          fileBaseString1: base64String1 ?? '',
          fileBaseString2: base64String2 ?? '',
          fileBaseString3: base64String3 ?? '',
        );
        if (response.isSuccess!) {
          await loadEyeOnChildConfig();
          Future.delayed(
              const Duration(seconds: 1), () => AppNavigation.goBack());
          showSnackBar('Record Added Successfully',
              color: AppColors.successGreenColor);
        } else {
          showSnackBar(response.message);
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    }
    DialogBuilder.hideOpenDialog();
  }

  void setReason(int index) {
    if (selectedIndex == index) {
      selectedIndex = null;
    } else {
      selectedIndex = index;
    }
  }

  Future<EyeOnYourChildResponse> loadEyeOnChildConfig() async {
    int? userId = localDataProvider.userData!.userType == 'Student'
        ? int.tryParse(localDataProvider.studentId)
        : localDataProvider.userData!.userType == 'Parent'
            ? int.tryParse(localDataProvider.studentId)
            : int.tryParse(localDataProvider.userData!.userName ?? '');
    try {
      EyeOnYourChildResponse response =
          await EyeOnYourChildService.getEyeOnChildConfig(
              userName: userId ?? 0);
      setEyeOnYourChildRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<ParentEyeOnYourChildResponse> loadStudentUpdates() async {
    int? userId = int.tryParse(localDataProvider.studentId);
    try {
      ParentEyeOnYourChildResponse response =
          await ParentEyeOnYourChildService.getStudentUpdatesForParent(
              userName: userId ?? 0,
              tokenId: localDataProvider.userData!.tokenId ?? '');
      setStudentsUpdates(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void uploadAttachment() async {
    fileName1 = "";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      List<File> selectedFiles =
          result.paths.map((path) => File(path!)).toList();

      if (selectedFiles.length > 3) {
        showSnackBar('You can only select up to 3 images.');
        return;
      }
      if (selectedFiles.isNotEmpty) {
        fileName1 = selectedFiles.first.path.split('/').last;

        // Check if the second record exists
        if (selectedFiles.length > 1) {
          fileName2 = selectedFiles[1].path.split('/').last;
        }

        // Check if the third record exists
        if (selectedFiles.length > 2) {
          fileName3 = selectedFiles.last.path.split('/').last;
        }

        files = selectedFiles;

        // Process each file if it exists
        for (int i = 0; i < selectedFiles.length; i++) {
          File file = selectedFiles[i];
          String base64String = await fileToBase64(file);

          // Assign base64String values based on the index of the file
          switch (i) {
            case 0:
              base64String1 = base64String;
              break;
            case 1:
              base64String2 = base64String;
              break;
            case 2:
              base64String3 = base64String;
              break;
            default:
              // Handle additional files if needed
              break;
          }
        }
      }

      // fileName1 = selectedFiles.first.path.split('/').last;
      // fileName2 = selectedFiles[1].path.split('/').last;
      // fileName3 = selectedFiles.last.path.split('/').last;

      // files = selectedFiles;

      // if (files.isNotEmpty) {
      //   //File file = files.first!;
      //   base64String1 = await fileToBase64(files.first!);
      //   base64String2 = await fileToBase64(files[1]!);
      //   base64String3 = await fileToBase64(files.last!);
      // }
    }
    notifyListeners();
  }

  Future<String> fileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  void clearData() {
    selectedIndex = null;

    selectedUpdate = null;
    selectedChild = null;
    selectedUpdateId = null;
    selectedChildId = null;

    eyeOnChildResponse = null;
    fileName1 = null;
    fileName2 = null;
    fileName3 = null;

    base64String1 = null;
    base64String2 = null;
    base64String3 = null;
    files = [];

    imagePaths = [];
  }
}
