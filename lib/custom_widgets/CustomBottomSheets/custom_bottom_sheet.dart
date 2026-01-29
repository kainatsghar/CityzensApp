import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final double? height;
  final String title;
  final Widget child;
  final EdgeInsets? bottomSheetPadding;
  final EdgeInsets? titlePadding;
  final bool scrollRequired;
  // final String status;

  const CustomBottomSheet({
    this.title = '',
    this.height,
    required this.child,
    this.bottomSheetPadding,
    this.titlePadding,
    this.scrollRequired = true,
    // this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                bottomSheetPadding ??
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      titlePadding ?? const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: scrollRequired ? 1 : 0,
            child: InkWell(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: bottomSheetPadding ?? const EdgeInsets.all(15.0),
                child: child,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
