import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import '../../Provider/WithdrawalRequest/withdrawal_request_provider.dart';
import '../../Utils/app_constants.dart';

class WithdrawalRequestComponent extends StatefulWidget {
  const WithdrawalRequestComponent({super.key});

  @override
  State<WithdrawalRequestComponent> createState() =>
      _WithdrawalRequestComponentState();
}

class _WithdrawalRequestComponentState
    extends State<WithdrawalRequestComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<WithdrawalRequestProvider>(builder: (context, value, _) {
      var responseData = value.withdrawalResponse;

      value.isRelocationSelected =
          value.selectedReasons.any((reason) => reason.id == 8);

      var option = ['Yes', 'No'];

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          // ignore: unnecessary_null_comparison
          child: responseData == null
              ? const ShowCustomMessage(message: AppConstants.noRecordFound)
              : Form(
                  key: value.formKey,
                  child: Column(
                    children: [
                      const CustomCoverImage(
                          title: 'WITHDRAWAL REQUEST',
                          imagePath: 'withdrawal.png'),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: size.width * 0.44,
                                child: const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // Added

                                  children: [
                                    Text('CHILD NAME:',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primaryTitleColor,
                                            fontWeight: FontWeight.bold)),
                                    //SizedBox(height: 2.0),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CLASS:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //SizedBox(height: 2.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Added

                                    children: [
                                      SizedBox(
                                        //height: size.height * 0.04,
                                        width: size.width * 0.8,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 235, 234, 234),
                                          child: Center(
                                            child: Text(
                                                value.truncateText(responseData
                                                        .studentInfo?.name ??
                                                    ''),
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 83, 83, 83),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                      //const SizedBox(height: 2.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Added

                                    children: [
                                      SizedBox(
                                        width: size.width * 0.8,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 235, 234, 234),
                                          child: Center(
                                            child: Text(
                                                responseData.studentInfo!
                                                        .className ??
                                                    '',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 83, 83, 83),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(height: size.height * 0.01),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.44,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SECTION:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryTitleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.36,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ROLL NUMBER:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryTitleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                    ],
                                  ),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Added

                                    children: [
                                      SizedBox(
                                        //height: size.height * 0.04,
                                        width: size.width * 0.8,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 235, 234, 234),
                                          child: Center(
                                            child: Text(
                                                responseData.studentInfo!
                                                        .sectionName ??
                                                    '',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 83, 83, 83),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                      //const SizedBox(height: 2.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Added

                                    children: [
                                      SizedBox(
                                        width: size.width * 0.8,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 235, 234, 234),
                                          child: Center(
                                            child: Text(
                                                responseData
                                                    .studentInfo!.studentId
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 83, 83, 83),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(height: size.height * 0.01),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.36,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PHONE NUMBER:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryTitleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                    ],
                                  ),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  //width: size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Added

                                    children: [
                                      SizedBox(
                                        width: size.width * 0.86,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 235, 234, 234),
                                          child: Center(
                                            child: Text(
                                                responseData
                                                        .studentInfo!.phone ??
                                                    '',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 83, 83, 83),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                              ]),
                        ]),
                      ),
                      SizedBox(height: size.height * 0.02),
                      if (!value.isSubmitted && !value.isProcessing)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 0),
                          child: Column(
                            children: [
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // Added
                                children: [
                                  Text(
                                    'Please select reason for withdrawal',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .start, // Added textAlign property
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // Added
                                children: [
                                  Text(
                                    '(You may tick a maximum of 3 boxes)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        //fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDarkColor),
                                    textAlign: TextAlign
                                        .start, // Added textAlign property
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Stack(children: [
                                    Divider(
                                      color: AppColors.primaryColor,
                                      height: 20,
                                      thickness: 4,
                                      indent: size.width * 0.1,
                                      endIndent: size.width * 0.1,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        size: 32,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: responseData.reasons?.length,
                                    itemBuilder: (_, index) {
                                      final reason =
                                          responseData.reasons?[index];
                                      value.isSelected = value.selectedReasons
                                          .contains(reason);
                                      final updates =
                                          responseData.reasons?[index];
                                      return SizedBox(
                                        height: size.height * 0.04,
                                        child: GestureDetector(
                                          onTap: () {
                                            value.toggleSelection(reason!);
                                          },
                                          child: Card(
                                            color: value.isSelected
                                                ? AppColors.primaryDarkColor
                                                : AppColors.secondaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            elevation: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                updates!.reason ?? '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: value.isSelected
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else if (value.isProcessing)
                        Container(
                          margin: const EdgeInsets.all(
                              16.0), // Adds some space around the container
                          padding: const EdgeInsets.all(
                              12.0), // Adds padding inside the container
                          decoration: BoxDecoration(
                            color: Colors.orange[
                                100], // Light orange background color for the warning
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                            border: Border.all(
                              color: Colors.orange, // Orange border
                              width: 2.0, // Border width
                            ),
                          ),
                          child: const Text(
                            '⚠️ Withdrawal request is in process...',
                            style: TextStyle(
                              fontSize:
                                  16.0, // Slightly larger font size for better readability
                              fontWeight: FontWeight.bold, // Bold text
                              color: Colors
                                  .orange, // Orange text color to match the theme
                            ),
                            textAlign:
                                TextAlign.center, // Center-aligns the text
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 0),
                          child: Column(
                            children: [
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // Added
                                children: [
                                  Text(
                                    'Would you like to discuss this further withour school team ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .center, // Added textAlign property
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Stack(children: [
                                    Divider(
                                      color: AppColors.primaryColor,
                                      height: 20,
                                      thickness: 4,
                                      indent: size.width * 0.1,
                                      endIndent: size.width * 0.1,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        size: 32,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: option.length,
                                    itemBuilder: (_, index) {
                                      final options = option[index];
                                      return SizedBox(
                                        height: size.height * 0.04,
                                        child: GestureDetector(
                                          onTap: () {
                                            value
                                                .setComminicatingValue(options);
                                          },
                                          child: Card(
                                            color:
                                                value.isComminicating == options
                                                    ? AppColors.primaryDarkColor
                                                    : AppColors.secondaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            elevation: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                options,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      value.isComminicating ==
                                                              options
                                                          ? AppColors.whiteColor
                                                          : AppColors
                                                              .blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // Added
                                children: [
                                  Text(
                                    'Were you contacted by the school management ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .center, // Added textAlign property
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Stack(children: [
                                    Divider(
                                      color: AppColors.primaryColor,
                                      height: 20,
                                      thickness: 4,
                                      indent: size.width * 0.1,
                                      endIndent: size.width * 0.1,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        size: 32,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: option.length,
                                    itemBuilder: (_, index) {
                                      final options = option[index];
                                      return SizedBox(
                                        height: size.height * 0.04,
                                        child: GestureDetector(
                                          onTap: () {
                                            value.setContactedValue(options);
                                          },
                                          child: Card(
                                            color: value.isContacted == options
                                                ? AppColors.primaryDarkColor
                                                : AppColors.secondaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            elevation: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                options,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: value.isContacted ==
                                                          options
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // Added
                                children: [
                                  Text(
                                    'Are you satisfied with the measures taken by the school to address your concerns?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .center, // Added textAlign property
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Stack(children: [
                                    Divider(
                                      color: AppColors.primaryColor,
                                      height: 20,
                                      thickness: 4,
                                      indent: size.width * 0.1,
                                      endIndent: size.width * 0.1,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        size: 32,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: option.length,
                                    itemBuilder: (_, index) {
                                      final options = option[index];
                                      return SizedBox(
                                        height: size.height * 0.04,
                                        child: GestureDetector(
                                          onTap: () {
                                            value.setSatisfiedValue(options);
                                          },
                                          child: Card(
                                            color: value.isSatisfied == options
                                                ? AppColors.primaryDarkColor
                                                : AppColors.secondaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            elevation: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                options,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: value.isSatisfied ==
                                                          options
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // Added
                                children: [
                                  Text(
                                    'Would you still like to withdraw your child from the school ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .center, // Added textAlign property
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors
                                        .primaryColor, // Set the color of the line
                                    height: 20, // Set the height of the line
                                    thickness:
                                        4, // Set the thickness of the line
                                    indent: size.width *
                                        0.1, // Set the indent of the line
                                    endIndent: size.width *
                                        0.1, // Set the endIndent of the line
                                  ),
                                  Stack(children: [
                                    Divider(
                                      color: AppColors.primaryColor,
                                      height: 20,
                                      thickness: 4,
                                      indent: size.width * 0.1,
                                      endIndent: size.width * 0.1,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        size: 32,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: option.length,
                                    itemBuilder: (_, index) {
                                      final options = option[index];
                                      return SizedBox(
                                        height: size.height * 0.04,
                                        child: GestureDetector(
                                          onTap: () {
                                            value.setWithdrawValue(options);
                                          },
                                          child: Card(
                                            color: value.isWithdraw == options
                                                ? AppColors.primaryDarkColor
                                                : AppColors.secondaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            elevation: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                options,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: value.isWithdraw ==
                                                          options
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              if (value.isWithdraw == "Yes")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: size.height * 0.02),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 4.0, right: 1.0),
                                      child: Text(
                                        'SECURITY DEPOSIT CHEQUE TO BE PREPARED IN FAVOUR OF:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryTitleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    //SizedBox(height: size.height * 0.01),
                                    SizedBox(
                                      width: size.width * 0.87,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        color: AppColors.greyColor,
                                        child: Center(
                                          child: SizedBox(
                                            height: size.height * 0.03,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: '',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color:
                                                          AppColors.greyColor,
                                                    )),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .greyColor,
                                                        )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .greyColor,
                                                        )),
                                              ),
                                              onChanged: (values) {
                                                value.setFavourValue(values);
                                              },
                                            ),
                                          ),
                                          // Text('',
                                          //     style: TextStyle(
                                          //         color: Color.fromARGB(
                                          //             255, 83, 83, 83),
                                          //         fontWeight: FontWeight.bold,
                                          //         fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.01),

                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0, right: 1.0),
                                          child: Text(
                                            'ADDRESS TO WHICH CHEQUE MAY BE SENT:',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  AppColors.primaryTitleColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.0),
                                      ],
                                    ),
                                    SizedBox(
                                      width: size.width * 0.87,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        color: AppColors.greyColor,
                                        child: Center(
                                          child: SizedBox(
                                            height: size.height * 0.03,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: '',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color:
                                                          AppColors.greyColor,
                                                    )),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .greyColor,
                                                        )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .greyColor,
                                                        )),
                                              ),
                                              onChanged: (values) {
                                                value.setchequeAddressValue(
                                                    values);
                                              },
                                            ),
                                          ),
                                          // Text('',
                                          //     style: TextStyle(
                                          //         color: Color.fromARGB(
                                          //             255, 83, 83, 83),
                                          //         fontWeight: FontWeight.bold,
                                          //         fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      if (value.isRelocationSelected)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //SizedBox(height: size.height * 0.02),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0, right: 1.0),
                                child: Text(
                                  'TOWN/CITY:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryTitleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.88,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  color: AppColors.greyColor,
                                  child: Center(
                                    child: SizedBox(
                                      height: size.height * 0.03,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: '',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                        ),
                                        onChanged: (values) {
                                          value.setTownCityValue(values);
                                        },
                                      ),
                                    ),
                                    // Text('',
                                    //     style: TextStyle(
                                    //         color: Color.fromARGB(
                                    //             255, 83, 83, 83),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 14)),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 4.0, right: 1.0),
                                    child: Text(
                                      'PLEASE SPECIFY:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.88,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  color: AppColors.greyColor,
                                  child: Center(
                                    child: SizedBox(
                                      height: size.height * 0.03,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: '',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                              )),
                                        ),
                                        onChanged: (values) {
                                          value.setSpecifyValue(values);
                                        },
                                      ),
                                    ),
                                    // Text('',
                                    //     style: TextStyle(
                                    //         color: Color.fromARGB(
                                    //             255, 83, 83, 83),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 14)),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                            ],
                          ),
                        ),
                      SizedBox(height: size.height * 0.02),
                      if (!value.isSubmitted && !value.isProcessing)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAppButton(
                            buttonTitle: 'SUBMIT',
                            onTap: () => {value.showModalDialog(context)},
                          ),
                        )
                      else if (value.isProcessing)
                        SizedBox(height: size.height * 0.0)
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAppButton(
                            buttonTitle: 'UPDATE',
                            onTap: () =>
                                {value.saveWithdrawalRequest(context, true)},
                          ),
                        ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
