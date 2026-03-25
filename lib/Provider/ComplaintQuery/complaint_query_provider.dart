import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/WithdrawalRequest/withdrawal_response.dart';
import '../../model/MultiChild/multi_child_response.dart';
import '../../routes/app_navigation.dart';
import '../../services/WithdrawalRequest/withdrawal_request_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../LocalData/local_data_provider.dart';
import '../ParentDashboard/parent_dashboard_provider.dart';

class ComplaintQueryProvider with ChangeNotifier {
  WithdrawalResponse? withdrawalResponse;

  String? selectedCategory;

  bool isSelected = false;

  String category = "";
  String subCategory = "";
  String type = "";

  // Auto-filled user info
  String userType = "";

  // Form data
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController campusController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  MultiChildResponse? multiChildResponse;

  final formKey = GlobalKey<FormState>();

  late LocalDataProvider localDataProvider;

  void initializeData() {
    localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    userType = localDataProvider.userData?.userType ?? "";
  }

  void initializeUserData() {
    initializeData();

    if (userType == "Student") {
      nameController.text = localDataProvider.userData?.info?.name ?? "";
      idController.text = localDataProvider.studentId;
      classController.text = localDataProvider.userData?.info?.className ?? "";
      campusController.text =
          localDataProvider.userData?.info?.centerName ?? "";
      regionController.text =
          localDataProvider.userData?.info?.regionName ?? "";
      emailController.text =
          localDataProvider.userData?.info?.fatherEmail ?? "";
      mobileController.text = "";
      multiChildResponse = null;
      descriptionController.text = "";
    } else if (userType == "Teacher") {
      nameController.text = localDataProvider.userData?.name ?? "";
      idController.text = localDataProvider.userData?.userName ?? "";
      campusController.text =
          localDataProvider.userData?.info?.centerName ?? "";
      regionController.text =
          localDataProvider.userData?.info?.regionName ?? "";
      emailController.text = "";
      mobileController.text =
          localDataProvider.userData?.info?.fatherEmail ?? "";
      multiChildResponse = null;
      descriptionController.text = "";
    } else if (userType == "Parent") {
      idController.text = localDataProvider.userData?.userName ?? "";
      campusController.text =
          localDataProvider.userData?.info?.centerName ?? "";
      regionController.text =
          localDataProvider.userData?.info?.regionName ?? "";
      emailController.text =
          localDataProvider.userData?.info?.fatherEmail ?? "";
      mobileController.text = "";

      final parentProvider = Provider.of<ParentDashboardProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );
      multiChildResponse = parentProvider.multiChildResponse;
      descriptionController.text = _buildChildrenInfo();
    }

    type = "Complaint"; // Default to Complaint
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

  /// Build children info for description
  String _buildChildrenInfo() {
    if (multiChildResponse?.children == null) return "";
    final buffer = StringBuffer();
    buffer.writeln("Children Information:");
    for (int i = 0; i < multiChildResponse!.children!.length; i++) {
      final child = multiChildResponse!.children![i];
      buffer.writeln("${i + 1}. Student Name: ${child.studentName}");
      buffer.writeln("   Class: ${child.className}");
      buffer.writeln("   Campus: ${child.centerName}");
      buffer.writeln("   Region: ${child.regionName}");
      buffer.writeln("   Student ID: ${child.studentId}");
      buffer.writeln("   Father Email: ${child.fatherEmail}");
      buffer.writeln("");
    }
    return buffer.toString();
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
        final studentNameValue = nameController.text.trim();
        final rollNumberValue = idController.text.trim();

        if (studentNameValue.isEmpty || rollNumberValue.isEmpty) {
          showSnackBar("Please enter student details.");
          return;
        }

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
    userType = "";

    nameController.clear();
    idController.clear();
    classController.clear();
    campusController.clear();
    regionController.clear();
    emailController.clear();
    mobileController.clear();
    descriptionController.clear();

    multiChildResponse = null;
  }
}
