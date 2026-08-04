import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/model/Promotion/promotion_model.dart';
import 'package:tcs_app/repositories/Promotion/promotion_repository.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/screens/Promotion/promotion_form_screen.dart';

class PromotionManagementScreen extends StatefulWidget {
  const PromotionManagementScreen({super.key});

  @override
  State<PromotionManagementScreen> createState() =>
      _PromotionManagementScreenState();
}

class _PromotionManagementScreenState extends State<PromotionManagementScreen> {
  final PromotionRepository _repository = PromotionRepository();
  bool _isLoading = true;
  List<PromotionModel> _promotions = [];

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    setState(() => _isLoading = true);
    final promos = await _repository.getActivePromotionList();
    setState(() {
      _promotions = promos ?? [];
      _isLoading = false;
    });
  }

  void _deletePromotion(PromotionModel promotion) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Delete',
              style: TextStyle(
                color: AppColors.primaryDarkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete promotion "${promotion.title ?? promotion.promotionKey}"?',
              style: const TextStyle(color: AppColors.softGreyText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      setState(() => _isLoading = true);
      await _repository.deletePromotion(promotion.id);
      await _loadPromotions();
    }
  }

  void _showPromotionDialog([PromotionModel? promotion]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionFormScreen(promotion: promotion),
      ),
    );
    if (result == true) {
      _loadPromotions();
    }
  }

  Widget _buildStatusPill(PromotionModel promo) {
    final now = DateTime.now();
    bool isExpired = promo.endDate != null && promo.endDate!.isBefore(now);
    bool isScheduled = promo.startDate != null && promo.startDate!.isAfter(now);
    bool isLive = promo.isLive && !isExpired && !isScheduled;

    Color bgColor;
    Color textColor;
    String label;

    if (promo.isTesting) {
      bgColor = AppColors.warningOrange.withValues(alpha: 0.2);
      textColor = AppColors.warningOrange;
      label = 'Testing';
    } else if (isExpired) {
      bgColor = AppColors.errorRed.withValues(alpha: 0.1);
      textColor = AppColors.errorRed;
      label = 'Expired';
    } else if (isScheduled) {
      bgColor = AppColors.primaryBlue.withValues(alpha: 0.1);
      textColor = AppColors.primaryBlue;
      label = 'Scheduled';
    } else if (isLive) {
      bgColor = AppColors.successGreen.withValues(alpha: 0.2);
      textColor = AppColors.successGreen;
      label = 'Live';
    } else {
      bgColor = AppColors.borderGrey;
      textColor = AppColors.softGreyText;
      label = 'Inactive';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ultraLightGrey,
      appBar: const CustomAppBar(title: 'MANAGE PROMOTIONS'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _promotions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 80,
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Promotions Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to create a new promotion.',
                    style: TextStyle(color: AppColors.softGreyText),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _promotions.length,
              itemBuilder: (context, index) {
                final promo = _promotions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => _showPromotionDialog(promo),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Media Preview
                          if (promo.url != null && promo.url!.isNotEmpty)
                            Container(
                              height: 240,
                              width: double.infinity,
                              color: AppColors.primaryLightBlue,
                              child: promo.promotionType == 'image'
                                  ? CachedNetworkImage(
                                      imageUrl: promo.url!,
                                      fit: BoxFit.contain,
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: AppColors.softGreyText,
                                              size: 40,
                                            ),
                                          ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 50,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        promo.title ?? 'Untitled Promotion',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryDarkBlue,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    _buildStatusPill(promo),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  promo.description ??
                                      'No description provided.',
                                  style: const TextStyle(
                                    color: AppColors.softGreyText,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Key: ${promo.promotionKey ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppColors.primaryBlue,
                                          ),
                                          onPressed: () =>
                                              _showPromotionDialog(promo),
                                          tooltip: 'Edit',
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColors.errorRed,
                                          ),
                                          onPressed: () =>
                                              _deletePromotion(promo),
                                          tooltip: 'Delete',
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPromotionDialog(),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          'Create',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
