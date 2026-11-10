import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/attendance_graph_component.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/attendance_list_item.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/student_list_response.dart';
import 'package:tcs_app/citizen/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class StudentListComponent extends StatefulWidget {
  const StudentListComponent({super.key});

  @override
  State<StudentListComponent> createState() => _StudentListComponentState();
}

class _StudentListComponentState extends State<StudentListComponent> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        final List<Student> studentList =
            value.studentListResponse.studentList ?? [];

        if (studentList.isEmpty) {
          return const Center(
            child: ShowCustomMessage(message: AppConstants.noRecordFound),
          );
        }

        if (value.saveAttendanceResponse?.isSuccessful != null &&
            value.saveAttendanceResponse!.isSuccessful!) {
          return const AttendanceGraphComponent();
        }

        final int pCount = studentList.where((s) => s.day == 'P').length;
        final int aCount = studentList.where((s) => s.day == 'A').length;
        final int lCount = studentList.where((s) => s.day == 'L').length;

        final List<MapEntry<int, Student>> filtered = [];
        for (int i = 0; i < studentList.length; i++) {
          final student = studentList[i];
          if (_query.isEmpty) {
            filtered.add(MapEntry(i, student));
          } else {
            final name = (student.name ?? '').toLowerCase();
            final id = '${student.studentId ?? ''}'.toLowerCase();
            if (name.contains(_query) || id.contains(_query)) {
              filtered.add(MapEntry(i, student));
            }
          }
        }

        final String todayFormatted =
            DateFormat('E d MMM').format(DateTime.now());

        return Column(
          children: [
            // Scrollable Body (.ma .bd)
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Yellow Reminder Strip (.ma .note)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8C4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0A21A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Today, $todayFormatted',
                                style: AppThemes.roboto(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF4A3D00),
                                ),
                                children: [
                                  TextSpan(
                                    text: ' · mark before 10 AM',
                                    style: AppThemes.roboto(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B5900),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2. Slim P/A/L Count Pills + All present (.ma .sum2)
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          _buildCountChip(
                            letter: 'P',
                            count: pCount,
                            bg: const Color(0xFFDDF3EA),
                            fg: const Color(0xFF0E8A5F),
                          ),
                          const SizedBox(width: 5),
                          _buildCountChip(
                            letter: 'A',
                            count: aCount,
                            bg: const Color(0xFFFBE3E7),
                            fg: const Color(0xFFC42840),
                          ),
                          const SizedBox(width: 5),
                          _buildCountChip(
                            letter: 'L',
                            count: lCount,
                            bg: const Color(0xFFFDEFD2),
                            fg: const Color(0xFF8A5A00),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => value.markAllPresent(),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blueTint,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'All present',
                                  style: AppThemes.sora(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. Search Bar (.ma .srch)
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCDD4DE)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) {
                          setState(() {
                            _query = v.trim().toLowerCase();
                          });
                        },
                        style: AppThemes.roboto(
                          fontSize: 13,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: AppColors.muted,
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: AppColors.muted,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _query = '';
                                    });
                                  },
                                )
                              : null,
                          hintText: 'Search by name or ID',
                          hintStyle: AppThemes.roboto(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 4. Student List Grouped Card (.ma .list)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'No student matches "$_query"',
                                  style: AppThemes.roboto(
                                    fontSize: 12.5,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(filtered.length, (i) {
                                final entry = filtered[i];
                                return Column(
                                  children: [
                                    if (i > 0)
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFFEEF1F5),
                                      ),
                                    AttendanceListItem(
                                      index: entry.key,
                                      student: entry.value,
                                    ),
                                  ],
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Save Footer (.ma .ft)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.yellowDeep,
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => value.saveAttendance(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save attendance',
                        style: AppThemes.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountChip({
    required String letter,
    required int count,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$letter ',
            style: AppThemes.sora(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          Text(
            '$count',
            style: AppThemes.sora(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
