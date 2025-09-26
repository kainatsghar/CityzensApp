import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../CustomWidgets/CustomAppButton/custom_app_button.dart';
import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import '../../Provider/ComplaintQuery/complaint_query_provider.dart';
import '../../Utils/app_constants.dart';

class ComplaintQueryComponents extends StatefulWidget {
  const ComplaintQueryComponents({super.key});

  @override
  State<ComplaintQueryComponents> createState() =>
      _ComplaintQueryComponentsState();
}

class _ComplaintQueryComponentsState extends State<ComplaintQueryComponents> {
  final Map<String, List<String>> categoryMap = {
    'Academics': [
      'General Academics Concerns',
      'Result Related',
      "Teacher's Complaint",
      'Unavailability of Teachers',
      'Course Related',
      'Education Technology',
    ],
    'Financial': [
      'Fee Challans / General Fee related',
      'Fee Arrears',
      'Fine Removal Request',
      'Security Deposit Refund',
      'Withdrawals & School Leaving',
      'Scholarships',
      'Online Fee Update',
      'Concessions',
    ],
    'Management & Administrative': [
      'Complaints Against the SLTs',
      'Facilities',
      "Complaint Against Staff / General School's Complaint",
    ],
    'Miscellaneous': ['Study Pack', 'Uniforms', 'AC Facility', 'Vendors'],
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ComplaintQueryProvider>(
      builder: (context, value, _) {
        var responseData = value.withdrawalResponse;

        var type = ['Complaint', 'Inquiry'];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: responseData == null
                ? const ShowCustomMessage(message: AppConstants.noRecordFound)
                : Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        const CustomCoverImage(
                          title: 'COMPLAINT/QUERY',
                          imagePath: 'lightbulb.png',
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: size.width * 0.45,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'STUDENT NAME:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primaryTitleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                                child: TextFormField(
                                  //validator: value.validator,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    labelText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) {
                                    value.setStudentNameValue(values);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: size.width * 0.45,
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'STUDENT ID:',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  AppColors.primaryTitleColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                                child: TextFormField(
                                  controller: value.rollNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    //labelText: value.rollNumberLabel,
                                    //hintText: value.rollNumberLabel,
                                    contentPadding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    //labelText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) {
                                    value.setStudentRollNumberValue(values);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 0,
                          ),
                          child: Column(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),

                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors.primaryColor,
                                    height: 20,
                                    thickness: 4,
                                    indent: size.width * 0.1,
                                    endIndent: size.width * 0.1,
                                  ),
                                  Stack(
                                    children: [
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
                                    ],
                                  ),
                                ],
                              ),
                              //SizedBox(height: size.height * 0.01),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 0.0,
                                  right: 0.0,
                                  left: 0.0,
                                ),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: type.length,
                                      itemBuilder: (_, index) {
                                        final options = type[index];
                                        return SizedBox(
                                          height: size.height * 0.04,
                                          width: size.width * 0.8,
                                          child: GestureDetector(
                                            onTap: () {
                                              value.setTypeValue(options);
                                            },
                                            child: Card(
                                              color: value.type == options
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
                                                    color: value.type == options
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              //SizedBox(height: size.height * 0.01),
                              Stack(
                                children: [
                                  Divider(
                                    color: AppColors.primaryColor,
                                    height: 20,
                                    thickness: 4,
                                    indent: size.width * 0.1,
                                    endIndent: size.width * 0.1,
                                  ),
                                  Stack(
                                    children: [
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
                                    ],
                                  ),
                                ],
                              ),
                              //SizedBox(height: size.height * 0.01),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: categoryMap.keys.length,
                                itemBuilder: (_, index) {
                                  final category = categoryMap.keys.elementAt(
                                    index,
                                  );
                                  value.isSelected = value.subCategory.contains(
                                    category,
                                  );
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          value.setCategory(category);
                                          // setState(() {
                                          //   value.selectedCategory =
                                          //       value.selectedCategory ==
                                          //               category
                                          //           ? null
                                          //           : category;
                                          // });
                                        },
                                        child: Card(
                                          color: value.category == category
                                              ? AppColors.successGreenColor
                                              : AppColors.secondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              0,
                                            ),
                                          ),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    category,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          value.category ==
                                                              category
                                                          ? AppColors.blackColor
                                                          : AppColors
                                                                .blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  // if (value.category ==
                                                  //     category)
                                                  //   Positioned(
                                                  //     top: 1,
                                                  //     left:
                                                  //         size.width * 0.5 -
                                                  //             30,
                                                  //     child: const Icon(
                                                  //       Icons
                                                  //           .arrow_drop_down_sharp,
                                                  //       size: 32,
                                                  //       color: AppColors
                                                  //           .primaryDarkColor,
                                                  //     ),
                                                  //   ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (value.selectedCategory == category)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: categoryMap[category]!
                                              .map(
                                                (subCategory) => SizedBox(
                                                  width: size.width * 0.8,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      value
                                                          .setCategoryAndSubCategory(
                                                            category,
                                                            subCategory,
                                                          );
                                                    },
                                                    child: Card(
                                                      color:
                                                          value.subCategory ==
                                                              subCategory
                                                          ? AppColors
                                                                .primaryDarkColor
                                                          : AppColors
                                                                .secondaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              0,
                                                            ),
                                                      ),
                                                      elevation: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            subCategory,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  value.subCategory ==
                                                                      subCategory
                                                                  ? AppColors
                                                                        .whiteColor
                                                                  : AppColors
                                                                        .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAppButton(
                            buttonTitle: 'SAVE',
                            onTap: () => {
                              value.saveComplaintQueryRequest(context, true),
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
