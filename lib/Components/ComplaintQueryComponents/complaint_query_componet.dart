import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomCard/custom_card.dart';
import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../provider/ComplaintQuery/complaint_query_provider.dart';
import '../../utils/app_constants.dart';

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

        var type = ['Complaint', 'Enquiry'];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: responseData == null
                ? const ShowCustomMessage(message: AppConstants.noRecordFound)
                : Form(
                    key: value.formKey,
                    child: CustomCard(
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
                                CustomTextFormField(
                                  controller: value.nameController,
                                  prefixIcon: Icons.person,
                                  hintText: 'User Name',
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                if (value.userType.isNotEmpty) ...[
                                  CustomTextFormField(
                                    hintText: value.userType,
                                    prefixIcon: Icons.account_circle,
                                    isEnable: false,
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                ],
                                CustomTextFormField(
                                  controller: value.idController,
                                  prefixIcon: Icons.badge,
                                  hintText: 'Roll No / ERP / CNIC',
                                  inputType: TextInputType.text,
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                  controller: value.emailController,
                                  prefixIcon: Icons.email,
                                  hintText: 'Contact Email',
                                  inputType: TextInputType.emailAddress,
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                CustomTextFormField(
                                  controller: value.mobileController,
                                  prefixIcon: Icons.phone_iphone,
                                  hintText: 'Mobile Number',
                                  inputType: TextInputType.phone,
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                if (value.userType == 'Student') ...[
                                  CustomTextFormField(
                                    controller: value.classController,
                                    prefixIcon: Icons.school,
                                    hintText: 'Class',
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                ],
                                if (value.userType != 'Parent') ...[
                                  CustomTextFormField(
                                    controller: value.campusController,
                                    prefixIcon: Icons.business,
                                    hintText: 'Campus',
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  CustomTextFormField(
                                    controller: value.regionController,
                                    prefixIcon: Icons.location_city,
                                    hintText: 'Region',
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                ],
                                CustomTextFormField(
                                  controller: value.descriptionController,
                                  hintText: 'Description',
                                  maxLines: 4,
                                  inputType: TextInputType.multiline,
                                  inputAction: TextInputAction.newline,
                                  validator: value.validator,
                                ),
                                SizedBox(height: size.height * 0.02),
                                SizedBox(height: size.height * 0.03),
                                // Type selection
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Type',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: type.map((option) {
                                    final isSelected = value.type == option;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => value.setTypeValue(option),
                                        child: Card(
                                          color: isSelected
                                              ? AppColors.primaryDarkColor
                                              : AppColors.secondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              option,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors
                                                          .primaryTitleColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: size.height * 0.03),
                                // Category dropdown
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: value.category.isEmpty
                                      ? null
                                      : value.category,
                                  borderRadius: BorderRadius.circular(8.0),
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.only(right: 3.0),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.category,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: const Text('Select Category'),
                                  items: categoryMap.keys
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        ),
                                      )
                                      .toList(),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please select a category';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    if (val != null) {
                                      value.setCategory(val);
                                    }
                                  },
                                ),
                                SizedBox(height: size.height * 0.02),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: value.subCategory.isEmpty
                                      ? null
                                      : value.subCategory,
                                  borderRadius: BorderRadius.circular(8.0),
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.only(right: 3.0),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.list,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: Text(
                                    value.category.isEmpty
                                        ? 'Select Category First'
                                        : 'Select Subcategory',
                                  ),
                                  items: value.category.isEmpty
                                      ? []
                                      : (categoryMap[value.category] ?? [])
                                            .map(
                                              (sub) => DropdownMenuItem(
                                                value: sub,
                                                child: Text(sub),
                                              ),
                                            )
                                            .toList(),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please select a subcategory';
                                    }
                                    return null;
                                  },
                                  onChanged: value.category.isEmpty
                                      ? null
                                      : (val) {
                                          if (val != null) {
                                            value.setCategoryAndSubCategory(
                                              value.category,
                                              val,
                                            );
                                          }
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
                              onTap: () => value.saveComplaintQueryRequest(
                                context,
                                true,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
