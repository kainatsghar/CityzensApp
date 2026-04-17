// === UPDATED FILE: custom_toggle_button.dart ===
// Modernized: Animated scale feedback, refined border, premium feel
import 'package:flutter/material.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class CustomToggleButton extends StatelessWidget {
  final Student student;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const CustomToggleButton({
    super.key,
    required this.student,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = student.day == title;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.35),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        height: 36,
        width: 36,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: isSelected ? 14 : 13,
              color: isSelected ? color : color.withValues(alpha: 0.5),
            ),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
