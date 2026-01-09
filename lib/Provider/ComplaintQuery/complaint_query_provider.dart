import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import '../../Model/WithdrawalRequest/withdrawal_response.dart';
import '../../Routes/app_navigation.dart';
import '../../Services/WithdrawalRequest/withdrawal_request_service.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_constants.dart';
import '../LocalData/local_data_provider.dart';

class ComplaintQueryProvider with ChangeNotifier {
  WithdrawalResponse? withdrawalResponse;

  String? selectedCategory;

  bool isSelected = false;

  String category = "";
  String subCategory = "";
  String type = "";
  String studentName = "";
  String rollNumber = "";

  String rollNumberLabel = 'Roll Number';
  String controllerMask = '00000000';
  MaskedTextController? rollNumberController;

  final formKey = GlobalKey<FormState>();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setStudentNameValue(String val) {
    studentName = val;
    notifyListeners();
  }

  void setStudentRollNumberValue(String val) {
    rollNumber = val;
    notifyListeners();
  }

  void changeRollNumberInputField() {
    controllerMask = '00000000';
    rollNumberController = MaskedTextController(mask: controllerMask);
    rollNumberLabel = 'Roll Number';
  }

  void setCategory(String cat) {
    category = cat;
    subCategory = "";
    selectedCategory = cat;
    isSelected;
    notifyListeners();
  }

  void setCategoryAndSubCategory(String cat, String subCat) {
    category = cat;
    subCategory = subCat;
    isSelected;
    notifyListeners();
  }

  void setTypeValue(String option) {
    type = option;
    notifyListeners();
  }

  String truncateText(String text, [int maxLength = 15]) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    } else {
      return text;
    }
  }

  void setWithdrawalResponse(WithdrawalResponse response) {
    withdrawalResponse = response;
    notifyListeners();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  Future<void> saveComplaintQueryRequest(
    BuildContext context,
    bool isSaved,
  ) async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
        if (studentName.isEmpty || rollNumber.isEmpty) {
          showSnackBar("Please enter student details.");
          return;
        }
        // if () {
        //   showSnackBar("Please enter roll number.");
        //   return;
        // }
        if (type.isEmpty || subCategory.isEmpty) {
          showSnackBar("Please fill the details.");
          return;
        } else {
          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          showSnackBar(
            'Complaint Query Added Successfully',
            color: AppColors.successGreenColor,
          );
          // AddWithdrawalRequest request = AddWithdrawalRequest();

          // ///////
          // request.userId = localDataProvider.userData!.userName;
          // request.createdBy = localDataProvider.userData!.userName;
          // request.studentId = int.tryParse(localDataProvider.studentId);

          // ResponseMessage response =
          //     await AddWithdrawalRequestService.addWithdrawalRequest(request);

          // if (response.isSuccess!) {
          //   // ignore: use_build_context_synchronously

          //   await loadComplaintQuery();
          //   Future.delayed(
          //     const Duration(seconds: 1),
          //     () => AppNavigation.goBack(),
          //   );
          //   showSnackBar(
          //     'Complaint Query Added Successfully',
          //     color: AppColors.successGreenColor,
          //   );
          // } else {
          //   showSnackBar(response.message);
          // }
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  Future<WithdrawalResponse> loadComplaintQuery() async {
    try {
      int? userId = localDataProvider.userData!.userType == 'Student'
          ? int.tryParse(localDataProvider.studentId)
          : localDataProvider.userData!.userType == 'Parent'
          ? int.tryParse(localDataProvider.studentId)
          : int.tryParse(localDataProvider.userData!.userName!);

      WithdrawalResponse response =
          await WithdrawalRequestService.getWithdrawalReasons(id: userId ?? 0);
      setWithdrawalResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void clearData() {
    withdrawalResponse = null;
    selectedCategory = "";
    category = "";
    subCategory = "";
    type = "";
    studentName = "";
    rollNumber = "";
  }
}
