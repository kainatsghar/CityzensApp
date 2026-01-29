import 'package:flutter/material.dart';
import 'package:tcs_app/model/Firebase/Promotion/promotion_model.dart';
import 'package:tcs_app/screens/Promotion/promotion_dialog.dart';

class PromoWrapper extends StatefulWidget {
  const PromoWrapper({super.key, required this.child, this.promotionModel});
  final Widget child;
  final PromotionModel? promotionModel; // Set to true for demonstration

  @override
  State<PromoWrapper> createState() => _PromoWrapperState();
}

class _PromoWrapperState extends State<PromoWrapper> {
  bool _shown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_shown) {
      _shown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.promotionModel != null && mounted) {
          PromotionalDialog.show(context, widget.promotionModel!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
