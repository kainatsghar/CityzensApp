import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/model/Diary/diary_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';

import 'package:tcs_app/services/StudentProfile/student_profile_service.dart';
import 'package:tcs_app/services/AttendancePercentage/attendance_percentage_service.dart';
import 'package:tcs_app/services/StudentAttendance/student_attendance_service.dart';
import 'package:tcs_app/services/FeeChallan/feechallan_service.dart';
import 'package:tcs_app/services/StudentDiary/student_diary_service.dart';
import 'package:tcs_app/services/Notifications/notification_service.dart';
import 'package:tcs_app/services/StudentAssignment/student_assignment_service.dart';
import 'package:tcs_app/model/StudentSubjects/student_subject_response.dart';
import 'package:tcs_app/services/StudentSubjects/student_subject_service.dart';
import 'package:tcs_app/shared_preference/shared_preference.dart';

/// Offline-first repository for student dashboard data.
///
/// Caches the entire [ChildDashboardData] bundle per student.
/// On cache hit → returns instantly, then background-syncs.
/// TTLs: profile = until logout, fees/homework/assignments/circulars = 15min,
///        attendance = 30min.
class StudentDashboardRepository {
  /// TTL for the dashboard bundle cache (15 minutes).
  /// Individual data freshness varies, but we cache the full bundle
  /// and let background sync update everything.
  static const _bundleTtl = Duration(minutes: 15);

  /// Fetch data for a child with offline-first strategy.
  ///
  /// [onCacheHit] is called synchronously if cache exists — populate UI immediately.
  /// Returns the final [ChildDashboardData] after network fetch.
  Future<ChildDashboardData> fetchChildDataOfflineFirst({
    required String studentId,
    required String token,
    required ChildDashboardData data,
    Function(ChildDashboardData cachedData)? onCacheHit,
    Function()? onSyncComplete,
  }) async {
    final cacheKey = _getCacheKey(studentId);

    // 1. Try cache first
    final cached = await _getFromCache(cacheKey);
    if (cached != null) {
      // Populate the data object from cache
      _populateFromCached(data, cached);

      // Notify caller of instant cache data
      onCacheHit?.call(data);

      // 2. Background sync — don't await, let it update in background
      _backgroundSync(studentId, token, data, cacheKey, onSyncComplete);

      return data;
    }

    // 3. No cache → fetch from network
    await _fetchFromNetwork(studentId, token, data);
    await _saveToCache(cacheKey, data);
    return data;
  }

  /// Force refresh from network (pull-to-refresh).
  Future<void> forceRefresh({
    required String studentId,
    required String token,
    required ChildDashboardData data,
  }) async {
    await _fetchFromNetwork(studentId, token, data);
    await _saveToCache(_getCacheKey(studentId), data);
  }

  /// Background sync — fetches from network and updates cache silently.
  Future<void> _backgroundSync(
    String studentId,
    String token,
    ChildDashboardData data,
    String cacheKey,
    Function()? onSyncComplete,
  ) async {
    try {
      await _fetchFromNetwork(studentId, token, data);
      await _saveToCache(cacheKey, data);
      onSyncComplete?.call();
    } catch (e) {
      debugPrint('StudentDashboardRepository: Background sync failed: $e');
    }
  }

  /// Fetch all 7 APIs in parallel — same logic as the original _fetchDataForChild.
  Future<void> _fetchFromNetwork(
    String studentId,
    String token,
    ChildDashboardData data,
  ) async {
    final currentMonthStr = DateFormat('yyyyMM').format(DateTime.now());

    final cachedSessionStr = await AppLocalData.getStringPrefValue(
      key: 'cached_session_id_$studentId',
    );
    final cachedSessionId = int.tryParse(cachedSessionStr ?? '') ?? 17;

    StudentSubjectResponse? parallelSubjectsRes;

    await Future.wait([
      StudentProfileService.stdProfileRequest(
        userName: studentId,
        token: token,
      ).then((res) => data.profile = res).catchError((_) {}),

      AttendancePercentageService.attendancePercentage(
            userName: studentId,
            tokenId: token,
          )
          .then((res) {
            data.attendancePercentage = res;
          })
          .catchError((_) {}),

      StudentAttendanceService.studentAttendanceRequest(
        userName: studentId,
        attendanceDate: currentMonthStr,
        tokenId: token,
      ).then((res) => data.currentMonthAttendance = res).catchError((_) {}),

      FeeChallanService.outStandingChallanRequest(
        userName: studentId,
        token: token,
      ).then((res) => data.outstandingChallans = res).catchError((_) {}),

      StudentDiaryService.getDiaryRecords(
        userName: studentId,
        tokenId: token,
      ).then((res) => data.latestHomework = res).catchError((_) {}),

      NotificationService.notificationRequest(
        userName: studentId,
        token: token,
        group: '3',
      ).then((res) => data.latestCirculars = res).catchError((_) {}),

      StudentAssignmentService.getAssignmentRecords(
        userName: studentId,
        tokenId: token,
      ).then((res) => data.latestAssignments = res).catchError((_) {}),

      StudentSubjectService.getSubjects(
        studentId: studentId,
        tokenId: token,
        sessionId: cachedSessionId,
      ).then((res) => parallelSubjectsRes = res).catchError((_) {}),
    ]);

    final newSessionId = data.attendancePercentage?.data?.sessionId;

    if (newSessionId != null && newSessionId != cachedSessionId) {
      await AppLocalData.setStringPrefValue(
        key: 'cached_session_id_$studentId',
        value: newSessionId.toString(),
      );

      final updatedSubjectsRes = await StudentSubjectService.getSubjects(
        studentId: studentId,
        tokenId: token,
        sessionId: newSessionId,
      );
      data.subjects = updatedSubjectsRes;
    } else {
      if (parallelSubjectsRes != null) {
        data.subjects = parallelSubjectsRes;
      }
    }
  }

  // ============= Cache Helpers =============

  void _populateFromCached(ChildDashboardData target, _CachedBundle cached) {
    target.profile = cached.profile;
    target.attendancePercentage = cached.attendancePercentage;
    target.currentMonthAttendance = cached.currentMonthAttendance;
    target.outstandingChallans = cached.outstandingChallans;
    target.latestHomework = cached.latestHomework;
    target.latestCirculars = cached.latestCirculars;
    target.latestAssignments = cached.latestAssignments;
    target.subjects = cached.subjects;
  }

  Future<_CachedBundle?> _getFromCache(String key) async {
    try {
      // Check TTL
      final lastSync = await LocalCacheManager.getLastSyncTime(key: key);
      if (lastSync != null &&
          DateTime.now().difference(lastSync) > _bundleTtl) {
        // Cache expired — still return it for instant display, but it's stale
      }

      final jsonStr = await LocalCacheManager.getData(key: key);
      if (jsonStr == null) return null;

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return _CachedBundle.fromJson(map);
    } catch (e) {
      debugPrint('StudentDashboardRepository: Cache read error: $e');
      return null;
    }
  }

  Future<void> _saveToCache(String key, ChildDashboardData data) async {
    try {
      final bundle = _CachedBundle(
        profile: data.profile,
        attendancePercentage: data.attendancePercentage,
        currentMonthAttendance: data.currentMonthAttendance,
        outstandingChallans: data.outstandingChallans,
        latestHomework: data.latestHomework,
        latestCirculars: data.latestCirculars,
        latestAssignments: data.latestAssignments,
        subjects: data.subjects,
      );

      await LocalCacheManager.saveData(
        key: key,
        jsonData: jsonEncode(bundle.toJson()),
        dataType: 'student_dashboard_bundle',
      );
    } catch (e) {
      debugPrint('StudentDashboardRepository: Cache write error: $e');
    }
  }

  String _getCacheKey(String studentId) => 'student_dashboard_$studentId';
}

/// Internal serializable bundle for caching.
class _CachedBundle {
  final StudentProfileResponse? profile;
  final AttendancePercentageResponse? attendancePercentage;
  final StudentAttendanceResponse? currentMonthAttendance;
  final OutstandingChallanResponse? outstandingChallans;
  final DiaryResponse? latestHomework;
  final NotificationResponse? latestCirculars;
  final AssignmentResponse? latestAssignments;
  final StudentSubjectResponse? subjects;

  _CachedBundle({
    this.profile,
    this.attendancePercentage,
    this.currentMonthAttendance,
    this.outstandingChallans,
    this.latestHomework,
    this.latestCirculars,
    this.latestAssignments,
    this.subjects,
  });

  Map<String, dynamic> toJson() => {
    if (profile != null) 'profile': profile!.toJson(),
    if (attendancePercentage != null)
      'attendancePercentage': attendancePercentage!.toJson(),
    if (currentMonthAttendance != null)
      'currentMonthAttendance': currentMonthAttendance!.toJson(),
    if (outstandingChallans != null)
      'outstandingChallans': outstandingChallans!.toJson(),
    if (latestHomework != null) 'latestHomework': latestHomework!.toJson(),
    if (latestCirculars != null) 'latestCirculars': latestCirculars!.toJson(),
    if (latestAssignments != null)
      'latestAssignments': latestAssignments!.toJson(),
    if (subjects != null) 'subjects': subjects!.toJson(),
  };

  factory _CachedBundle.fromJson(Map<String, dynamic> json) {
    return _CachedBundle(
      profile: json['profile'] != null
          ? StudentProfileResponse.fromJson(json['profile'])
          : null,
      attendancePercentage: json['attendancePercentage'] != null
          ? AttendancePercentageResponse.fromJson(json['attendancePercentage'])
          : null,
      currentMonthAttendance: json['currentMonthAttendance'] != null
          ? StudentAttendanceResponse.fromJson(json['currentMonthAttendance'])
          : null,
      outstandingChallans: json['outstandingChallans'] != null
          ? OutstandingChallanResponse.fromJson(json['outstandingChallans'])
          : null,
      latestHomework: json['latestHomework'] != null
          ? DiaryResponse.fromJson(json['latestHomework'])
          : null,
      latestCirculars: json['latestCirculars'] != null
          ? NotificationResponse.fromJson(json['latestCirculars'])
          : null,
      latestAssignments: json['latestAssignments'] != null
          ? AssignmentResponse.fromJson(json['latestAssignments'])
          : null,
      subjects: json['subjects'] != null
          ? StudentSubjectResponse.fromJson(json['subjects'])
          : null,
    );
  }
}
