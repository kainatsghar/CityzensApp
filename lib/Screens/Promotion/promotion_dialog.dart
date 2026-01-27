import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/Model/Firebase/Promotion/promotion_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionalDialog {
  static Future<void> show(
    BuildContext context,
    PromotionModel promotionModel,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(promotionModel.url!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.all(8.0),
                      child: IconButton.filled(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomAppButton(
                    buttonTitle: 'Register',
                    width: 0,
                    onTap: () async {
                      final url = Uri.parse('https://forms.gle/YOUR_FORM_LINK');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
