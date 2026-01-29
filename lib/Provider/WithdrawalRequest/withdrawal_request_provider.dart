import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/AddWithdrawalRequest/add_withdrawal_request.dart';
import '../../model/WithdrawalRequest/withdrawal_response.dart';
import '../../services/AddWithdrawalRequest/add_withdrawal_request_service.dart';
import '../../routes/app_navigation.dart';
import '../../services/WithdrawalRequest/withdrawal_request_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../LocalData/local_data_provider.dart';

class WithdrawalRequestProvider with ChangeNotifier {
  WithdrawalResponse? withdrawalResponse;
  List<WithdrawalReasonsDto> selectedReasons = [];
  bool isSubmitted = false;
  bool isProcessing = false;
  bool isRelocationSelected = false;
  bool isSelected = false;
  String townCity = "";
  String specify = "";
  String reasonString = "";

  String? isCommunicating = "";
  String? isContacted = "";
  String? isSatisfied = "";
  String? isWithdraw = "";

  String inFavour = "";
  String chequeAddress = "";

  late final formKey = GlobalKey<FormState>();

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setTownCityValue(String val) {
    townCity = val;
  }

  void setSpecifyValue(String val) {
    specify = val;
  }

  void setCommunicatingValue(String? val) {
    isCommunicating = val;

    notifyListeners();
  }

  void setContactedValue(String? val) {
    isContacted = val;
    notifyListeners();
  }

  void setSatisfiedValue(String? val) {
    isSatisfied = val;
    notifyListeners();
  }

  void setWithdrawValue(String? val) {
    isWithdraw = val;
    notifyListeners();
  }

  void setFavourValue(String val) {
    inFavour = val;
    notifyListeners();
  }

  void setchequeAddressValue(String val) {
    chequeAddress = val;
    notifyListeners();
  }

  void toggleSelection(WithdrawalReasonsDto reason) {
    if (selectedReasons.contains(reason)) {
      selectedReasons.remove(reason);
    } else if (selectedReasons.length < 3) {
      selectedReasons.add(reason);
      reasonString = "";
    } else {
      showSnackBar(
        'Maximum of 3 reasons allowed!',
        color: AppColors.lightRedColor,
      );
    }
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
    isSubmitted = withdrawalResponse!.studentInfo!.isSubmitted ?? false;
    isProcessing = withdrawalResponse!.studentInfo!.isProcessing ?? false;
    notifyListeners();
  }

  Future<void> saveWithdrawalRequest(BuildContext context, bool isSaved) async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());

        AddWithdrawalRequest request = AddWithdrawalRequest();

        ///////
        request.userId = localDataProvider.userData!.userName;
        request.createdBy = localDataProvider.userData!.userName;
        request.studentId = int.tryParse(localDataProvider.studentId);
        if (isSubmitted == true &&
            (isCommunicating!.isEmpty ||
                isSatisfied!.isEmpty ||
                isWithdraw!.isEmpty)) {
          if (selectedReasons.isEmpty) {
            showSnackBar("Please answer the questions.");
            return;
          } else {
            request.isContactedBySchool = isCommunicating == "Yes"
                ? true
                : false;
            request.isSatisfiedConcerns = isSatisfied == "Yes" ? true : false;
            request.isWithdrawal = isWithdraw == "Yes" ? true : false;
            if (isWithdraw == "Yes") {
              request.inFavourOf = inFavour;
              request.address = chequeAddress;
            }
          }
        } else {
          if (isSubmitted == false && selectedReasons.isEmpty) {
            showSnackBar("Please select a reason.");
            return;
          } else {
            String commaSeparatedIds = selectedReasons
                .map((reason) => reason.id)
                .join(',');

            request.reasonId = commaSeparatedIds;
            request.isRelocated = isRelocationSelected;

            if (isRelocationSelected) {
              request.townCity = townCity;
              request.specify = specify;
            }
          }
        }

        ResponseMessage response =
            await AddWithdrawalRequestService.addWithdrawalRequest(request);

        if (response.isSuccess!) {
          // ignore: use_build_context_synchronously
          if (!isSubmitted) Navigator.of(context).pop(); // Close the dialog

          Future.delayed(
            const Duration(seconds: 1),
            () => AppNavigation.goBack(),
          );
          await loadWithdrawal();
          showSnackBar(
            'Withdrawal Response Added Successfully',
            color: AppColors.successGreenColor,
          );
        } else {
          showSnackBar(response.message);
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  Future<WithdrawalResponse> loadWithdrawal() async {
    try {
      int? userId = localDataProvider.userData!.userType == 'Student'
          ? int.tryParse(localDataProvider.studentId)
          : localDataProvider.userData!.userType == 'Parent'
          ? int.tryParse(localDataProvider.studentId)
          : int.tryParse(localDataProvider.userData!.userName.toString());

      WithdrawalResponse response =
          await WithdrawalRequestService.getWithdrawalReasons(id: userId ?? 0);
      setWithdrawalResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void showModalDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (selectedReasons.isEmpty) {
      showSnackBar("Please select a reason.");
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Terms and Conditions'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.8,
                    child: const Text(
                      '1.⁠ ⁠In the case where parents/guardians do not give one month notice of withdrawal then one month fee in lieu of notice will be deducted from the Security Deposit balance.\n'
                      '2.⁠ ⁠The outstanding/unpaid fee will be adjusted from Security Deposit.\n'
                      '3.⁠ ⁠If this application is made after the 7th of the month, then the fee is payable for the whole of that month.\n'
                      '4.⁠ ⁠The school leaving certificate will be issued when all school dues have been cleared and the student has completed at least ONE ACADEMIC SESSION with The City School.\n'
                      '5.⁠ ⁠Students withdrawn on completion of academic session in May, with or without notice, are liable to pay the tuition fee for up to and including the month of July.',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'If you have read the above terms and conditions, and acknowledge them, please click Confirm to proceed.',
                    style: TextStyle(
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CustomAppButton(
                buttonTitle: 'CONFIRM',
                onTap: () => {saveWithdrawalRequest(context, false)},
              ),
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'This is just a request and not an application to form.',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop(); // Close the dialog
              //   },
              //   child: const Text('Confirm'),
              // ),
            ],
          );
        },
      );
    }
  }

  void clearData() {
    withdrawalResponse = null;
    selectedReasons = [];
    isSelected = false;

    isSubmitted = false;
    isRelocationSelected = false;
    townCity = "";
    specify = "";
    reasonString = "";
    isCommunicating = "";
    isContacted = "";
    isSatisfied = "";
    isWithdraw = "";
    inFavour = "";
    chequeAddress = "";
  }
}
