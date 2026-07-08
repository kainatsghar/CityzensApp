import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Promotion/promotion_model.dart';
import 'package:tcs_app/repositories/Promotion/promotion_repository.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';

class SplashProvider with ChangeNotifier {
  PromotionModel? _activePromotion;
  PromotionModel? get activePromotion => _activePromotion;

  void loadInitialData() async {
    // Additional initialization if needed

    if (kIsWeb) {
      // Handle web-specific initialization here if needed
      Future.delayed(const Duration(seconds: 3), () {
        AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
      });
    } else {
      final results = await Future.wait([
        PromotionRepository().getActivePromotion(),
      ]);

      _activePromotion = results[0];

      Future.delayed(const Duration(seconds: 3), () {
        if (_activePromotion != null &&
            ((_activePromotion!.isLive &&
                    kReleaseMode &&
                    _activePromotion!.startDate != null &&
                    _activePromotion!.startDate!.isBefore(DateTime.now()) &&
                    _activePromotion!.endDate != null &&
                    _activePromotion!.endDate!.isAfter(DateTime.now())) ||
                (kDebugMode && _activePromotion!.isTesting))) {
          AppNavigation.pushReplacementTo(AppNavRoutes.promotionRoute);
        } else {
          AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
        }
      });
    }
  }
}
