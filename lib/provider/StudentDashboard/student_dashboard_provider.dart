import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/model/StudentDashboard/child_dashboard_data.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/MultiChild/multi_child_service.dart';
import 'package:tcs_app/repositories/StudentDashboard/student_dashboard_repository.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';

export 'package:tcs_app/model/StudentDashboard/child_dashboard_data.dart';

class StudentDashboardProvider with ChangeNotifier {
  final Map<String, ChildDashboardData> _childDataMap = {};
  final StudentDashboardRepository _repository = StudentDashboardRepository();

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

    // Immediately update FeeChallanProvider to prevent showing previous child's info
    final context = AppNavigation.currentContext;
    if (context != null) {
      try {
        final feeProvider = Provider.of<FeeChallanProvider>(
          context,
          listen: false,
        );
        final activeData = activeChildData;
        if (activeData != null) {
          feeProvider.outstandingChallans = activeData.outstandingChallans;
          feeProvider.challanReceiptResponse = null;
          feeProvider.notifyListeners();
        }
      } catch (e) {
        debugPrint(
          'Error syncing FeeChallanProvider on active child switch: $e',
        );
      }
    }
  }

  Future<void> refreshActiveChild() async {
    final token = localDataProvider.userData?.tokenId;
    if (token == null ||
        _activeStudentId == null ||
        _activeStudentId!.isEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final context = AppNavigation.currentContext;
      if (context != null && context.mounted) {
        try {
          Provider.of<ClassTestResultProvider>(
            context,
            listen: false,
          ).studentTestResultListResponse = null;
        } catch (_) {}
      }
      await _fetchDataForChild(
        _activeStudentId!,
        token,
        _childDataMap[_activeStudentId!]!,
        forceRefresh: true,
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
      final context = AppNavigation.currentContext;
      if (context != null && context.mounted) {
        try {
          Provider.of<ClassTestResultProvider>(
            context,
            listen: false,
          ).clearData();
        } catch (_) {}
      }
      List<Future> tasks = [];
      _childDataMap.forEach((studentId, data) {
        tasks.add(
          _fetchDataForChild(studentId, token, data, forceRefresh: true),
        );
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
    ChildDashboardData data, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await _repository.forceRefresh(
        studentId: studentId,
        token: token,
        data: data,
      );
      if (studentId == _activeStudentId) {
        notifyListeners();
      }
    } else {
      await _repository.fetchChildDataOfflineFirst(
        studentId: studentId,
        token: token,
        data: data,
        onCacheHit: (cachedData) {
          // Cache hit — immediately show cached dashboard
          // The UI is already bound to `data`, so just notify.
          if (studentId == _activeStudentId) {
            _isFirstChildReady = true;
            _isLoading = false;
            notifyListeners();
          }
        },
        onSyncComplete: () {
          if (studentId == _activeStudentId) {
            notifyListeners();
          }
        },
      );
    }

    // Sync FeeChallanProvider if this is the active child
    if (studentId == _activeStudentId) {
      final context = AppNavigation.currentContext;
      if (context != null && context.mounted) {
        try {
          final feeProvider = Provider.of<FeeChallanProvider>(
            context,
            listen: false,
          );
          feeProvider.outstandingChallans = data.outstandingChallans;
          feeProvider.notifyListeners();
        } catch (e) {
          debugPrint('Error syncing FeeChallanProvider on child fee load: $e');
        }
      }
    }
  }

  void clearData() {
    _childDataMap.clear();
    _isFirstChildReady = false;
    _isAllChildrenReady = false;
    _isLoading = false;
    _loadError = null;
    _activeStudentId = null;
    _multiChildResponse = null;
  }
}
