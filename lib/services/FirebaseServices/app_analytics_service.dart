import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Login/login_response.dart';

class AppAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Log when a user logs in successfully
  static Future<void> logLogin({
    required LoginResponse user,
    required String method,
  }) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      await setUserProperties(user);
    } catch (e) {
      debugPrint('[Analytics] Error logging login: $e');
    }
  }

  /// Log when a user logs out
  static Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
      await clearUserProperties();
    } catch (e) {
      debugPrint('[Analytics] Error logging logout: $e');
    }
  }

  /// Log when a specific feature is accessed
  static Future<void> logFeatureAccess(String featureName) async {
    try {
      await _analytics.logEvent(
        name: 'feature_accessed',
        parameters: {'feature_name': featureName},
      );
    } catch (e) {
      debugPrint('[Analytics] Error logging feature access: $e');
    }
  }

  /// Result PDF download funnel events (no PII / no full URLs).
  static Future<void> logResultPdfEvent(
    String eventName, {
    String? stage,
    String? errorType,
    int? byteCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'result_pdf_$eventName',
        parameters: {
          'stage': ?stage,
          'error_type': ?errorType,
          'byte_count': ?byteCount,
        },
      );
    } catch (e) {
      debugPrint('[Analytics] Error logging result PDF event: $e');
    }
  }

  /// Set user properties for Analytics and custom keys for Crashlytics
  static Future<void> setUserProperties(LoginResponse user) async {
    try {
      String userId = user.userName ?? user.id?.toString() ?? 'unknown_id';
      String userType = user.userType ?? 'Unknown';
      String centerName = user.info?.centerName ?? 'Unknown';
      String regionName = user.info?.regionName ?? 'Unknown';
      String classSection = user.info?.className ?? 'Unknown';

      String deviceType = 'Unknown';
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          deviceType = 'Android';
        } else if (Platform.isIOS) {
          deviceType = 'iOS';
        }
      } else {
        deviceType = 'Web';
      }

      // --- Analytics ---
      await _analytics.setUserId(id: userId);
      await _analytics.setUserProperty(name: 'user_type', value: userType);
      await _analytics.setUserProperty(name: 'device_type', value: deviceType);
      await _analytics.setUserProperty(name: 'center_name', value: centerName);
      await _analytics.setUserProperty(name: 'region_name', value: regionName);
      await _analytics.setUserProperty(
        name: 'class_section',
        value: classSection,
      );

      // --- Crashlytics ---
      await _crashlytics.setUserIdentifier(userId);
      await _crashlytics.setCustomKey('user_type', userType);
      await _crashlytics.setCustomKey('device_type', deviceType);
      await _crashlytics.setCustomKey('center_name', centerName);
      await _crashlytics.setCustomKey('region_name', regionName);
      await _crashlytics.setCustomKey('class_section', classSection);
    } catch (e) {
      debugPrint('[Analytics] Error setting user properties: $e');
    }
  }

  /// Clear user properties upon logout
  static Future<void> clearUserProperties() async {
    try {
      // --- Analytics ---
      await _analytics.setUserId(id: null);
      await _analytics.setUserProperty(name: 'user_type', value: null);
      await _analytics.setUserProperty(name: 'device_type', value: null);
      await _analytics.setUserProperty(name: 'center_name', value: null);
      await _analytics.setUserProperty(name: 'region_name', value: null);
      await _analytics.setUserProperty(name: 'class_section', value: null);

      // --- Crashlytics ---
      await _crashlytics.setUserIdentifier('');
      await _crashlytics.setCustomKey('user_type', 'none');
      await _crashlytics.setCustomKey('device_type', 'none');
      await _crashlytics.setCustomKey('center_name', 'none');
      await _crashlytics.setCustomKey('region_name', 'none');
      await _crashlytics.setCustomKey('class_section', 'none');
    } catch (e) {
      debugPrint('[Analytics] Error clearing user properties: $e');
    }
  }
}
