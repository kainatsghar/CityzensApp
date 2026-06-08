import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles local caching with SharedPreferences
/// Stores JSON data and metadata like last sync time
class LocalCacheManager {
  static const String _cacheKeyPrefix = 'cityzens_cache_';
  static const String _lastSyncKeyPrefix = 'cityzens_last_sync_';

  /// Save data to local cache with metadata
  static Future<void> saveData({
    required String key,
    required String jsonData,
    required String dataType, // e.g., 'teacher_sections_diary_true'
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(key);
      final lastSyncKey = _getLastSyncKey(key);

      // Save JSON data
      await prefs.setString(cacheKey, jsonData);

      // Save last sync timestamp
      await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());

      // Save data type for validation
      await prefs.setString('${cacheKey}_type', dataType);
    } catch (e) {
      debugPrint('LocalCacheManager Error saving $key: $e');
      rethrow;
    }
  }

  /// Retrieve data from local cache
  static Future<String?> getData({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(key);
      return prefs.getString(cacheKey);
    } catch (e) {
      debugPrint('LocalCacheManager Error retrieving $key: $e');
      return null;
    }
  }

  /// Get last sync time for a key
  static Future<DateTime?> getLastSyncTime({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncKey = _getLastSyncKey(key);
      final lastSyncStr = prefs.getString(lastSyncKey);

      if (lastSyncStr != null) {
        return DateTime.parse(lastSyncStr);
      }
      return null;
    } catch (e) {
      debugPrint('LocalCacheManager Error getting last sync time for $key: $e');
      return null;
    }
  }

  /// Check if cache exists for a key
  static Future<bool> cacheExists({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(key);
      return prefs.containsKey(cacheKey);
    } catch (e) {
      debugPrint(
        'LocalCacheManager Error checking cache existence for $key: $e',
      );
      return false;
    }
  }

  /// Clear cache for a specific key
  static Future<void> clearCache({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(key);
      final lastSyncKey = _getLastSyncKey(key);
      final typeKey = '${cacheKey}_type';

      await Future.wait([
        prefs.remove(cacheKey),
        prefs.remove(lastSyncKey),
        prefs.remove(typeKey),
      ]);
    } catch (e) {
      debugPrint('LocalCacheManager Error clearing cache for $key: $e');
      rethrow;
    }
  }

  /// Clear all Cityzens caches (for logout)
  static Future<void> clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_cacheKeyPrefix) ||
            key.startsWith(_lastSyncKeyPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      debugPrint('LocalCacheManager Error clearing all caches: $e');
      rethrow;
    }
  }

  /// Get formatted time since last sync (e.g., "5 mins ago", "2 hours ago")
  static String getTimeSinceLastSync(DateTime? lastSyncedAt) {
    if (lastSyncedAt == null) return 'Never synced';

    final now = DateTime.now();
    final difference = now.difference(lastSyncedAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return 'A long time ago';
    }
  }

  static String _getCacheKey(String key) => '$_cacheKeyPrefix$key';

  static String _getLastSyncKey(String key) => '$_lastSyncKeyPrefix$key';
}
