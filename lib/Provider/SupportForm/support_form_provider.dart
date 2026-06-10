import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';

class SupportFormProvider with ChangeNotifier {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController(); // Roll/ERP/CNIC
  TextEditingController classController = TextEditingController();
  TextEditingController campusController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileContactController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  // Dropdown selections
  String selectedFeedbackType = "Bug Report";
  List<String> feedbackTypes = [
    "Bug Report",
    "Suggestion",
    "Account Issue",
    "Payment/Fee Issue",
    "Login Problem",
    "Performance Issue",
    "Content/Data Correction",
    "Other",
  ];

  // Auto-filled info
  String userType = "";
  MultiChildResponse? multiChildResponse;
  String appVersion = "";
  String deviceInfo = "";
  String osVersion = "";
  String submittedAt = "";
  late LocalDataProvider localProvider;

  void initializeData() {
    // Any initialization if needed
    localProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    userType = localProvider.userData?.userType ?? "";
  }

  /// Load user data from LocalDataProvider
  void initializeUserData() {
    var studentDashboardProvider = Provider.of<StudentDashboardProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );

    initializeData();

    if (userType == "Student") {
      nameController.text = localProvider.userData!.info!.name ?? "";
      idController.text = localProvider.studentId;
      classController.text = localProvider.userData!.info!.className ?? "";
      campusController.text = localProvider.userData!.info!.centerName ?? "";
      regionController.text = localProvider.userData!.info!.regionName ?? "";
      emailController.text = localProvider.userData!.info!.fatherEmail ?? "";
      mobileContactController.text = "";
    } else if (userType == "Teacher") {
      nameController.text = localProvider.userData!.name ?? "";
      idController.text = '${localProvider.userData!.userName}';
      campusController.text = localProvider.userData!.info!.centerName ?? "";
      regionController.text = localProvider.userData!.info!.regionName ?? "";
      emailController.text = "";
      mobileContactController.text =
          localProvider.userData!.info!.fatherEmail ?? "";
    } else if (userType == "Parent") {
      nameController.text = "";
      idController.text = '${localProvider.userData!.userName}';
      campusController.text = localProvider.userData!.info!.centerName ?? "";
      regionController.text = localProvider.userData!.info!.regionName ?? "";
      mobileContactController.text =
          localProvider.userData!.info!.fatherEmail ?? "";
      multiChildResponse = studentDashboardProvider.multiChildResponse;
      emailController.text =
          multiChildResponse?.children != null &&
              multiChildResponse!.children!.isNotEmpty
          ? multiChildResponse!.children!.first.fatherEmail ?? ""
          : "";
    }
  }

  /// Load device + app info
  Future<void> loadDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    appVersion = packageInfo.version;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = "${androidInfo.manufacturer} ${androidInfo.model}";
      osVersion = "Android ${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = iosInfo.utsname.machine;
      osVersion = "${iosInfo.systemName} ${iosInfo.systemVersion}";
    }

    submittedAt = DateTime.now().toString();

    notifyListeners();
  }

  /// Clears only user-editable form fields. Call in initState() of feedback screens.
  void clearFormState() {
    titleController.clear();
    detailsController.clear();
    selectedFeedbackType = "Bug Report";
    mobileContactController.clear();
  }

  void clearData() {
    nameController.clear();
    idController.clear();
    classController.clear();
    campusController.clear();
    regionController.clear();
    emailController.clear();
    mobileContactController.clear();
    titleController.clear();
    detailsController.clear();
    selectedFeedbackType = "Bug Report";
    multiChildResponse = null;
    userType = "";
    appVersion = "";
    deviceInfo = "";
    osVersion = "";
    submittedAt = "";
  }

  void updateFeedbackType(String value) {
    selectedFeedbackType = value;
    notifyListeners();
  }

  /// Inject children info (for parents)
  void setMultiChildData(MultiChildResponse response) {
    multiChildResponse = response;
    notifyListeners();
  }

  /// Build children info for email
  String _buildChildrenInfo() {
    if (multiChildResponse?.children == null) return "No Children Found";
    final buffer = StringBuffer();
    for (int i = 0; i < multiChildResponse!.children!.length; i++) {
      final child = multiChildResponse!.children![i];
      buffer.writeln("${i + 1}. Student Name: ${child.studentName}");
      buffer.writeln("   Class: ${child.className}");
      buffer.writeln("   Campus: ${child.centerName}");
      buffer.writeln("   Region: ${child.regionName}");
      buffer.writeln("   StudentId: ${child.studentId}");
      buffer.writeln("   Father Email: ${child.fatherEmail}");
      buffer.writeln("");
    }
    return buffer.toString();
  }

  /// Build email body
  String _buildEmailBody() {
    final buffer = StringBuffer();

    buffer.writeln("User Name: ${nameController.text}");
    buffer.writeln("User Type: $userType");
    buffer.writeln("ID: ${idController.text}");
    if (classController.text.isNotEmpty) {
      buffer.writeln("Class: ${classController.text}");
    }
    if (userType != "Parent") {
      buffer.writeln("Campus: ${campusController.text}");
      buffer.writeln("Region: ${regionController.text}");
    }
    buffer.writeln("Contact No: ${mobileContactController.text}");
    buffer.writeln("");
    buffer.writeln("Feedback Type: $selectedFeedbackType");
    buffer.writeln("Title: ${titleController.text}");
    buffer.writeln("Details:");
    buffer.writeln(detailsController.text);
    buffer.writeln("");

    if (userType == "Parent") {
      buffer.writeln("-------------------");
      buffer.writeln("Children Info:");
      buffer.writeln(_buildChildrenInfo());
    }

    buffer.writeln("-------------------");
    buffer.writeln("Device Info:");
    buffer.writeln("Device: $deviceInfo");
    buffer.writeln("OS Version: $osVersion");
    buffer.writeln("App Version: $appVersion");
    buffer.writeln("Submitted At: $submittedAt");

    return buffer.toString();
  }

  /// Send support email
  Future<void> sendSupportEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final subject = "$selectedFeedbackType - ${titleController.text.trim()}";

    final body = _buildEmailBody();

    final email = Email(
      body: body,
      subject: subject,
      recipients: [AppConstants.appSupportEmail],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
