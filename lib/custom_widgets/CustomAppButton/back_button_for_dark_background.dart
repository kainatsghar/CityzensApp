import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackButtonForDarkBackground extends StatelessWidget {
  const BackButtonForDarkBackground({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 18,
        ),
      ),
      onPressed:
          onPressed ??
          () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
    );
  }
}
