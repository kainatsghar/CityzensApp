import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/OfflineState/data_state.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';
import 'package:tcs_app/services/TeacherSection/teacher_section_service.dart';

/// Repository for Teacher Sections with offline-first strategy
///
/// This repository implements the offline-first pattern:
/// 1. Check local cache first and return immediately (instant UI load)
/// 2. In background, fetch from API
/// 3. If API succeeds, update cache and notify
/// 4. If API fails and we have cache, keep showing it
/// 5. If API fails and no cache, show error
class TeacherSectionRepository {
  /// Get sections with offline-first strategy
  /// Returns [TeacherSectionResponse] from cache first if available,
  /// then fetches fresh data in background
  Future<TeacherSectionResponse?> getSectionsOfflineFirst({
    required String userName,
    required String token,
    required bool isDiary,
    required Function(DataState<TeacherSectionResponse>) onStateChange,
  }) async {
    final cacheKey = _getCacheKey(userName, isDiary);

    // Step 1: Check local cache
    final cachedData = await _getFromCache(cacheKey);

    if (cachedData != null) {
      // Immediately return cached data to UI
      onStateChange(
        DataLoaded(
          cachedData,
          isStale: true,
          lastSyncedAt: await LocalCacheManager.getLastSyncTime(key: cacheKey),
        ),
      );

      // Step 2: Background sync
      _backgroundSync(
        userName: userName,
        token: token,
        isDiary: isDiary,
        cacheKey: cacheKey,
        onStateChange: onStateChange,
      );

      return cachedData;
    } else {
      // No cache, need to fetch from API
      onStateChange(const DataLoading());

      try {
        final response = await TeacherSectionService.sectionRequest(
          userName: userName,
          token: token,
          isDiary: isDiary,
        );

        // Save to cache
        await _saveToCache(cacheKey, response);

        onStateChange(
          DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
        );

        return response;
      } catch (e) {
        onStateChange(
          DataError(
            'Failed to load sections: ${e.toString()}',
            cachedData: null,
          ),
        );
        rethrow;
      }
    }
  }

  /// Background sync - fetches fresh data and updates cache if successful
  /// Does not throw errors to avoid interrupting the user
  Future<void> _backgroundSync({
    required String userName,
    required String token,
    required bool isDiary,
    required String cacheKey,
    required Function(DataState<TeacherSectionResponse>) onStateChange,
  }) async {
    try {
      final response = await TeacherSectionService.sectionRequest(
        userName: userName,
        token: token,
        isDiary: isDiary,
      );

      // Update cache with fresh data
      await _saveToCache(cacheKey, response);

      // Notify UI with updated data (not stale anymore)
      onStateChange(
        DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
      );
    } catch (e) {
      // Silently fail - don't interrupt user if background sync fails
      debugPrint('TeacherSectionRepository: Background sync failed: $e');
    }
  }

  /// Get all sections for both isDiary states (for parallel loading)
  /// Returns a map containing responses for both diary true and false
  Future<Map<String, dynamic>> getAllSectionsOfflineFirst({
    required String userName,
    required String token,
    required Function(String key, DataState<TeacherSectionResponse>)
    onStateChange,
  }) async {
    final results = <String, TeacherSectionResponse?>{};

    // Fetch both in parallel with offline-first strategy
    await Future.wait([
      getSectionsOfflineFirst(
        userName: userName,
        token: token,
        isDiary: true,
        onStateChange: (state) => onStateChange('diary_true', state),
      ).then((data) => results['diary_true'] = data),
      getSectionsOfflineFirst(
        userName: userName,
        token: token,
        isDiary: false,
        onStateChange: (state) => onStateChange('diary_false', state),
      ).then((data) => results['diary_false'] = data),
    ]);

    return results;
  }

  /// Force refresh from API (useful for pull-to-refresh)
  Future<void> forceRefresh({
    required String userName,
    required String token,
    required bool isDiary,
    required Function(DataState<TeacherSectionResponse>) onStateChange,
  }) async {
    final cacheKey = _getCacheKey(userName, isDiary);

    onStateChange(const DataLoading());

    try {
      final response = await TeacherSectionService.sectionRequest(
        userName: userName,
        token: token,
        isDiary: isDiary,
      );

      await _saveToCache(cacheKey, response);

      onStateChange(
        DataLoaded(response, isStale: false, lastSyncedAt: DateTime.now()),
      );
    } catch (e) {
      // Try to use cached data as fallback
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

  /// Clear cache for a specific query
  Future<void> clearCache({
    required String userName,
    required bool isDiary,
  }) async {
    final cacheKey = _getCacheKey(userName, isDiary);
    await LocalCacheManager.clearCache(key: cacheKey);
  }

  /// Get date diff display text
  String getLastSyncDisplayText(DateTime? lastSyncedAt) {
    return LocalCacheManager.getTimeSinceLastSync(lastSyncedAt);
  }

  // ============= Private Helpers =============

  Future<TeacherSectionResponse?> _getFromCache(String key) async {
    try {
      final jsonStr = await LocalCacheManager.getData(key: key);
      if (jsonStr != null) {
        return TeacherSectionResponse.fromJson(jsonDecode(jsonStr));
      }
    } catch (e) {
      debugPrint('TeacherSectionRepository: Error getting from cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(String key, TeacherSectionResponse response) async {
    try {
      // Convert response to JSON immediately
      final jsonData = jsonEncode({
        'IsSuccessful': response.isSuccessful,
        'Message': response.message,
        'IsServerException': response.isException,
        'ClassSection':
            response.section
                ?.map(
                  (s) => {
                    'ClassSectionId': s.classSectionId,
                    'Name': s.name,
                    'ClassId': s.classId,
                  },
                )
                .toList() ??
            [],
      });

      await LocalCacheManager.saveData(
        key: key,
        jsonData: jsonData,
        dataType: 'teacher_sections_response',
      );
    } catch (e) {
      debugPrint('TeacherSectionRepository: Error saving to cache: $e');
    }
  }

  String _getCacheKey(String userName, bool isDiary) {
    return 'teacher_sections_${userName}_isDiary_$isDiary';
  }
}
