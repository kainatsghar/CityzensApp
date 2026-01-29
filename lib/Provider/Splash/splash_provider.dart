import 'package:flutter/foundation.dart';
import 'package:tcs_app/model/Firebase/FeatureConfig/feature_config_model.dart';
import 'package:tcs_app/model/Firebase/Promotion/promotion_model.dart';
import 'package:tcs_app/repositories/FeatureConfig/feature_config_repository.dart';
import 'package:tcs_app/repositories/Promotion/promotion_repository.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';

class SplashProvider with ChangeNotifier {
  PromotionModel? _activePromotion;
  PromotionModel? get activePromotion => _activePromotion;

  List<FeatureConfigModel>? _listOfFeatureConfig;
  List<FeatureConfigModel>? get listOfFeatureConfig => _listOfFeatureConfig;

  void loadInitialData() async {
    // Additional initialization if needed

    if (kIsWeb) {
      // Handle web-specific initialization here if needed
      Future.delayed(const Duration(seconds: 3), () {
        AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
      });
    } else {
      final results = await Future.wait([
        FeatureConfigRepository().getNewFeaturesList(),
        PromotionRepository().getActivePromotion(),
      ]);
      _listOfFeatureConfig = results[0] as List<FeatureConfigModel>?;
      _activePromotion = results[1] as PromotionModel?;

      Future.delayed(const Duration(seconds: 3), () {
        if (_activePromotion != null &&
            ((_activePromotion!.isLive &&
                    kReleaseMode &&
                    _activePromotion!.startDate!.isBefore(DateTime.now()) &&
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
