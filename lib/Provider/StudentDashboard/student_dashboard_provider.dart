import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/services/StudentAssignment/student_assignment_service.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/model/Diary/diary_response.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import 'package:tcs_app/services/StudentProfile/student_profile_service.dart';
import 'package:tcs_app/services/AttendancePercentage/attendance_percentage_service.dart';
import 'package:tcs_app/services/StudentAttendance/student_attendance_service.dart';
import 'package:tcs_app/services/FeeChallan/feechallan_service.dart';
import 'package:tcs_app/services/StudentDiary/student_diary_service.dart';
import 'package:tcs_app/services/Notifications/notification_service.dart';
import 'package:tcs_app/services/MultiChild/multi_child_service.dart';

class ChildDashboardData {
  StudentProfileResponse? profile;
  AttendancePercentageResponse? attendancePercentage;
  StudentAttendanceResponse? currentMonthAttendance;
  OutstandingChallanResponse? outstandingChallans;
  DiaryResponse? latestHomework;
  NotificationResponse? latestCirculars;
  AssignmentResponse? latestAssignments;
}

class StudentDashboardProvider with ChangeNotifier {
  final Map<String, ChildDashboardData> _childDataMap = {};

  bool _isFirstChildReady = false;
  bool _isAllChildrenReady = false;
  bool _isLoading = false;
  String? _loadError;
  String? _activeStudentId;
  MultiChildResponse? _multiChildResponse;

  bool get isFirstChildReady => _isFirstChildReady;
  bool get isAllChildrenReady => _isAllChildrenReady;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  MultiChildResponse? get multiChildResponse => _multiChildResponse;

  ChildDashboardData? get activeChildData =>
      _activeStudentId != null ? _childDataMap[_activeStudentId] : null;

  ChildDashboardData? getChildData(String studentId) =>
      _childDataMap[studentId];

  LocalDataProvider get localDataProvider => Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> initializeForStudent() async {
    final token = localDataProvider.userData?.tokenId;
    final userName = localDataProvider.studentId;
    if (token == null || userName.isEmpty) return;

    _activeStudentId = userName;
    _childDataMap.clear();
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      _childDataMap[userName] = ChildDashboardData();
      await _fetchDataForChild(userName, token, _childDataMap[userName]!);
      _isFirstChildReady = true;
      _isAllChildrenReady = true;
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMultiChildData() async {
    final token = localDataProvider.userData?.tokenId;
    final parentId = localDataProvider.userData?.id;
    if (token == null || parentId == null) return;

    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      _multiChildResponse = await MultiChildService.multiChildRequest(
        token: token,
        userName: parentId.toString(),
      );

      if (_multiChildResponse?.children != null &&
          _multiChildResponse!.children!.isNotEmpty) {
        if (localDataProvider.studentId.isEmpty) {
          final firstChild = _multiChildResponse!.children!.first;
          localDataProvider.setStudentId(firstChild.studentId.toString());
          localDataProvider.setSGradeId(firstChild.classId);
        }
        await initializeForParent(_multiChildResponse!.children!);
      }
    } catch (e) {
      _loadError = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializeForParent(List<ChildInfo> children) async {
    final token = localDataProvider.userData?.tokenId;
    if (token == null || children.isEmpty) return;

    _activeStudentId = localDataProvider.studentId;
    if (_activeStudentId == null || _activeStudentId!.isEmpty) {
      _activeStudentId = children.first.studentId.toString();
    }

    _childDataMap.clear();
    for (var child in children) {
      _childDataMap[child.studentId.toString()] = ChildDashboardData();
    }

    _isLoading = true;
    _loadError = null;
    _isFirstChildReady = false;
    _isAllChildrenReady = false;
    notifyListeners();

    try {
      // 1. Load first (active) child immediately
      await _fetchDataForChild(
        _activeStudentId!,
        token,
        _childDataMap[_activeStudentId!]!,
      );
      _isFirstChildReady = true;
      _isLoading = false;
      notifyListeners();

      // 2. Fire remaining children in background
      List<Future> backgroundTasks = [];
      for (var child in children) {
        final sid = child.studentId.toString();
        if (sid != _activeStudentId) {
          backgroundTasks.add(
            _fetchDataForChild(sid, token, _childDataMap[sid]!),
          );
        }
      }

      if (backgroundTasks.isNotEmpty) {
        await Future.wait(backgroundTasks);
      }

      _isAllChildrenReady = true;
      notifyListeners();
    } catch (e) {
      _loadError = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void switchActiveChild(String studentId) {
    if (_activeStudentId == studentId) return;
    _activeStudentId = studentId;
    notifyListeners();
  }

  Future<void> refreshActiveChild() async {
    final token = localDataProvider.userData?.tokenId;
    if (token == null || _activeStudentId == null || _activeStudentId!.isEmpty)
      return;

    _isLoading = true;
    notifyListeners();

    try {
      await _fetchDataForChild(
        _activeStudentId!,
        token,
        _childDataMap[_activeStudentId!]!,
      );
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllChildren() async {
    final token = localDataProvider.userData?.tokenId;
    if (token == null || _childDataMap.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<Future> tasks = [];
      _childDataMap.forEach((studentId, data) {
        tasks.add(_fetchDataForChild(studentId, token, data));
      });
      await Future.wait(tasks);
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchDataForChild(
    String studentId,
    String token,
    ChildDashboardData data,
  ) async {
    final currentMonthStr = DateFormat('yyyyMM').format(DateTime.now());

    await Future.wait([
      // Profile
      StudentProfileService.stdProfileRequest(userName: studentId, token: token)
          .then((res) {
            data.profile = res;
          })
          .catchError((_) {}),

      // Attendance %
      AttendancePercentageService.attendancePercentage(
            userName: studentId,
            tokenId: token,
          )
          .then((res) {
            data.attendancePercentage = res;
          })
          .catchError((_) {}),

      // Current Month Attendance
      StudentAttendanceService.studentAttendanceRequest(
            userName: studentId,
            attendanceDate: currentMonthStr,
            tokenId: token,
          )
          .then((res) {
            data.currentMonthAttendance = res;
          })
          .catchError((_) {}),

      // Outstanding Fees
      FeeChallanService.outStandingChallanRequest(
            userName: studentId,
            token: token,
          )
          .then((res) {
            data.outstandingChallans = res;
          })
          .catchError((_) {}),

      // Latest Homework
      StudentDiaryService.getDiaryRecords(userName: studentId, tokenId: token)
          .then((res) {
            data.latestHomework = res;
          })
          .catchError((_) {}),

      // Circulars (group = '3')
      NotificationService.notificationRequest(
            userName: studentId,
            token: token,
            group: '3',
          )
          .then((res) {
            data.latestCirculars = res;
          })
          .catchError((_) {}),

      // Latest Assignments
      StudentAssignmentService.getAssignmentRecords(
            userName: studentId,
            tokenId: token,
          )
          .then((res) {
            data.latestAssignments = res;
          })
          .catchError((_) {}),
    ]);
  }

  void clearData() {
    _childDataMap.clear();
    _isFirstChildReady = false;
    _isAllChildrenReady = false;
    _isLoading = false;
    _loadError = null;
    _activeStudentId = null;
    _multiChildResponse = null;
    notifyListeners();
  }
}
