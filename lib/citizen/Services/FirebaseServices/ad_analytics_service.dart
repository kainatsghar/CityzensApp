import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

enum AdType { image, video }

extension AdTypeExtension on AdType {
  String get displayName {
    switch (this) {
      case AdType.image:
        return 'Image';
      case AdType.video:
        return 'Video';
    }
  }
}

enum AdPosition { launchPage, launchDialog, homeCarousel }

extension AdPositionExtension on AdPosition {
  String get displayName {
    switch (this) {
      case AdPosition.launchPage:
        return 'LaunchPage';
      case AdPosition.launchDialog:
        return 'LaunchDialog';
      case AdPosition.homeCarousel:
        return 'HomeCarousel';
    }
  }
}

class AdAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Log when an ad is shown to user
  static Future<void> logAdImpression({
    required String adId,
    required String position,
    String type = "Image",
  }) async {
    log('Logging ad impression: adId=$adId, position=$position, type=$type');
    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {'ad_id': adId, 'ad_position': position, 'ad_type': type},
    );
  }

  /// Log when user taps the ad
  static Future<void> logAdTap({
    required String adId,
    required String position,
    required String adTitle,
    String type = 'Image',
  }) async {
    await _analytics.logEvent(
      name: 'ad_tap',
      parameters: {
        'ad_id': adId,
        'ad_position': position,
        'ad_title': adTitle,
        'ad_type': type,
      },
    );
  }

  /// (Optional) track ad link open
  static Future<void> logAdOpenLink({
    required String adId,
    required String position,
  }) async {
    await _analytics.logEvent(
      name: 'ad_open_link',
      parameters: {'ad_id': adId, 'ad_position': position},
    );
  }
}
