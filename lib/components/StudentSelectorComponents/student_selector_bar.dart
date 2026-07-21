import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentSelectorBar extends StatelessWidget {
  final List<ChildInfo>? children;
  final VoidCallback onChildSelected;

  const StudentSelectorBar({
    super.key,
    required this.children,
    required this.onChildSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (children == null || children!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Consumer<LocalDataProvider>(
      builder: (context, localData, _) {
        final currentStudentId = localData.studentId;

        return Container(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(children!.length, (index) {
                final child = children![index];
                final isSelected = currentStudentId == '${child.studentId}';

                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      localData.setStudentId('${child.studentId}');
                      localData.setSGradeId(child.classId);
                      onChildSelected();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withValues(alpha: 0.2),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomUserImage(
                          imageSize: 36.0,
                          userId: '${child.studentId}',
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.studentName?.split(' ').first ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryBlue,
                              ),
                            ),
                            Text(
                              child.className ?? '',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
