import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Model/Options/options.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/student_list_response.dart';
import 'package:tcs_app/citizen/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class AttendanceListItem extends StatelessWidget {
  final Student student;
  final int index;

  const AttendanceListItem({
    super.key,
    required this.student,
    required this.index,
  });

  Color _optionColor(String code) {
    switch (code) {
      case 'P':
        return const Color(0xFF0E8A5F);
      case 'A':
        return const Color(0xFFC42840);
      case 'L':
        return const Color(0xFFE0A21A);
      default:
        return const Color(0xFF6B7487);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Options> attendanceOptions = HelperFunction.attendanceOptions();
    final int optionCount = (student.status == true)
        ? attendanceOptions.length
        : (attendanceOptions.length - 1);

    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Row Number
              SizedBox(
                width: 24,
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                  style: AppThemes.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Student Name & ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppThemes.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'ID ${student.studentId ?? ''}',
                      style: AppThemes.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // P / A / L Toggle Buttons matching `.ma .pal`
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(optionCount, (i) {
                  final String code =
                      attendanceOptions[i].title!.characters.first;
                  final bool isSelected = student.day == code;
                  final Color activeColor = _optionColor(code);

                  return Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                    child: GestureDetector(
                      onTap: () => value.changeStatus(code, index),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? activeColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? activeColor
                                : const Color(0xFFD5DAE2),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          code,
                          style: AppThemes.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF9AA3B2),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
