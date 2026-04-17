// === UPDATED FILE: attendance_list_item.dart ===
// Modernized: Premium student card with avatar, structured layout,
// animated toggle buttons, and consistent design language.
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomToggleButton/custom_toggle_button.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class AttendanceListItem extends StatelessWidget {
  final Student student;
  final int index;

  const AttendanceListItem({
    super.key,
    required this.student,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<Options> attendanceOptions = HelperFunction.attendanceOptions();
    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        return FadeInUp(
          delay: Duration(milliseconds: 20 * index),
          duration: const Duration(milliseconds: 350),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Student Avatar ──
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Student Info ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDarkColor,
                          letterSpacing: 0.2,
                        ),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Card.filled(
                        color: AppColors.primaryLightBlue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            'ID: ${student.studentId}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // ── Toggle Buttons ──
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    !student.status!
                        ? attendanceOptions.length - 1
                        : attendanceOptions.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: CustomToggleButton(
                        student: student,
                        title: attendanceOptions[i].title!.characters.first,
                        color: attendanceOptions[i].color!,
                        onTap: () => value.changeStatus(
                          attendanceOptions[i].title!.characters.first,
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
