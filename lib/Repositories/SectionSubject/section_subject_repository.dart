import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/OfflineState/data_state.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';
import 'package:tcs_app/services/SectionSubject/section_subject_service.dart';

/// Repository for Section Subjects with offline-first strategy
/// Handles background syncing and local caching of subject data
class SectionSubjectRepository {
  /// Get subjects for a section with offline-first strategy
  Future<SectionSubjectResponse?> getSubjectsOfflineFirst({
    required int classSectionId,
    required String token,
    required String teacherId,
    required bool isDiary,
    required Function(DataState<SectionSubjectResponse>) onStateChange,
  }) async {
    final cacheKey = _getCacheKey(classSectionId, isDiary);

    // Step 1: Check local cache
    final cachedData = await _getFromCache(cacheKey);

    if (cachedData != null) {
      // Immediately return cached data
      onStateChange(
        DataLoaded(
          cachedData,
          isStale: true,
          lastSyncedAt: await LocalCacheManager.getLastSyncTime(key: cacheKey),
        ),
      );

      // Step 2: Background sync
      _backgroundSync(
        classSectionId: classSectionId,
        token: token,
        teacherId: teacherId,
        isDiary: isDiary,
        cacheKey: cacheKey,
        onStateChange: onStateChange,
      );

      return cachedData;
    } else {
      // No cache, fetch from API
      onStateChange(const DataLoading());

      try {
        final response = await SectionSubjectService.getSubjectsRequest(
          classSectionId: classSectionId.toString(),
          token: token,
          teacherId: teacherId,
          isDiary: isDiary,
        );

        // Exclude subject ID 55
        response.sectionSubject?.removeWhere((s) => s.subjectId == 55);

        await _saveToCache(cacheKey, response);

        onStateChange(
          DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
        );

        return response;
      } catch (e) {
        onStateChange(
          DataError(
            'Failed to load subjects: ${e.toString()}',
            cachedData: null,
          ),
        );
        rethrow;
      }
    }
  }

  /// Background sync for subjects
  Future<void> _backgroundSync({
    required int classSectionId,
    required String token,
    required String teacherId,
    required bool isDiary,
    required String cacheKey,
    required Function(DataState<SectionSubjectResponse>) onStateChange,
  }) async {
    try {
      final response = await SectionSubjectService.getSubjectsRequest(
        classSectionId: classSectionId.toString(),
        token: token,
        teacherId: teacherId,
        isDiary: isDiary,
      );

      response.sectionSubject?.removeWhere((s) => s.subjectId == 55);

      await _saveToCache(cacheKey, response);

      onStateChange(
        DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
      );
    } catch (e) {
      debugPrint('SectionSubjectRepository: Background sync failed: $e');
    }
  }

  /// Force refresh subjects (pull-to-refresh)
  Future<void> forceRefresh({
    required int classSectionId,
    required String token,
    required String teacherId,
    required bool isDiary,
    required Function(DataState<SectionSubjectResponse>) onStateChange,
  }) async {
    final cacheKey = _getCacheKey(classSectionId, isDiary);

    onStateChange(const DataLoading());

    try {
      final response = await SectionSubjectService.getSubjectsRequest(
        classSectionId: classSectionId.toString(),
        token: token,
        teacherId: teacherId,
        isDiary: isDiary,
      );

      response.sectionSubject?.removeWhere((s) => s.subjectId == 55);

      await _saveToCache(cacheKey, response);

      onStateChange(
        DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
      );
    } catch (e) {
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        onStateChange(
          DataError(
            'Failed to refresh: ${e.toString()}',
            cachedData: cachedData,
          ),
        );
      } else {
        onStateChange(
          FirstRunError('No internet and no offline data available'),
        );
      }
    }
  }

  /// Clear cache
  Future<void> clearCache({
    required int classSectionId,
    required bool isDiary,
  }) async {
    final cacheKey = _getCacheKey(classSectionId, isDiary);
    await LocalCacheManager.clearCache(key: cacheKey);
  }

  // ============= Private Helpers =============

  Future<SectionSubjectResponse?> _getFromCache(String key) async {
    try {
      final jsonStr = await LocalCacheManager.getData(key: key);
      if (jsonStr != null) {
        return SectionSubjectResponse.fromJson(jsonDecode(jsonStr));
      }
    } catch (e) {
      debugPrint('SectionSubjectRepository: Error getting from cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(String key, SectionSubjectResponse response) async {
    try {
      final jsonData = jsonEncode(response.toJson());
      await LocalCacheManager.saveData(
        key: key,
        jsonData: jsonData,
        dataType: 'section_subject_response',
      );
    } catch (e) {
      debugPrint('SectionSubjectRepository: Error saving to cache: $e');
    }
  }

  String _getCacheKey(int classSectionId, bool isDiary) {
    return 'section_subjects_${classSectionId}_isDiary_$isDiary';
  }
}
