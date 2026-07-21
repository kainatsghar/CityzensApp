import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/StudentSubjects/student_subject_response.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentSubjectsScreen extends StatelessWidget {
  const StudentSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'My Subjects',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      body: Consumer<StudentDashboardProvider>(
        builder: (context, provider, _) {
          final data = provider.activeChildData;
          final subjects = data?.subjects?.studentSubjects ?? [];

          // Filter out subjects where teacher (FullName) is null or empty
          final validSubjects = subjects
              .where((s) => s.fullName != null && s.fullName!.trim().isNotEmpty)
              .toList();

          if (validSubjects.isEmpty) {
            return const Center(
              child: Text(
                'No subjects or teachers assigned yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: validSubjects.length,
            itemBuilder: (context, index) {
              final subject = validSubjects[index];
              return _SubjectCard(subject: subject);
            },
          );
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final StudentSubject subject;

  const _SubjectCard({required this.subject});

  Color _getColorForSubject(String subjectName) {
    // Generate a consistent vibrant color based on the subject name's hash
    final hash = subjectName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.85).toColor(); // Soft pastel
  }

  Color _getDarkColorForSubject(String subjectName) {
    final hash = subjectName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.75, 0.40).toColor(); // Darker text/icon
  }

  @override
  Widget build(BuildContext context) {
    final name = subject.subjectName ?? 'Unknown Subject';
    final teacher = subject.fullName ?? 'Unknown Teacher';
    
    final bgColor = _getColorForSubject(name);
    final darkColor = _getDarkColorForSubject(name);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: darkColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: darkColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 14,
                          color: darkColor.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            teacher,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: darkColor.withValues(alpha: 0.9),
                            ),
                          ),
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
  }
}
