import 'dart:ui';
import 'package:flutter/material.dart';

/// A premium glassmorphic card with frosted glass effect and subtle depth gradients.
///
/// Designed for high readability and professional educational aesthetics.
class GlassmorphicCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? content;
  final double borderRadius;
  final double blur;
  final Color accentColor;

  const GlassmorphicCard({
    super.key,
    this.child,
    this.title,
    this.content,
    this.borderRadius = 28.0,
    this.blur = 12.0,
    this.accentColor = const Color(0xFFF3CD50), // Default school gold
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            // Subtle depth gradient
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.18),
                Colors.white.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28.0),
          child: child ?? _buildDefaultContent(),
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              Container(
                width: 5,
                height: 26,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        if (content != null)
          Text(
            content!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 15,
              height: 1.7,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
      ],
    );
  }
}
