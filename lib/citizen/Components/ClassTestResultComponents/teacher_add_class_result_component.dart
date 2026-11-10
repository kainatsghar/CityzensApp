import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Model/ClassTestResult/class_test_student_list_response.dart';
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';

class TeacherAddClassResultComponent extends StatefulWidget {
  const TeacherAddClassResultComponent({super.key});

  @override
  State<TeacherAddClassResultComponent> createState() =>
      _TeacherAddClassResultComponentState();
}

class _TeacherAddClassResultComponentState
    extends State<TeacherAddClassResultComponent> {
  final TextEditingController _maxMarksController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final Map<int, TextEditingController> _markControllers = {};

  ClassTestResultStudentListResponse? _lastSyncedResponse;
  String _searchQuery = '';
  bool _sortById = false;

  @override
  void dispose() {
    _maxMarksController.dispose();
    _searchController.dispose();
    for (final ctrl in _markControllers.values) {
      ctrl.dispose();
    }
    _markControllers.clear();
    super.dispose();
  }

  void _syncControllersIfNeeded(ClassTestResultProvider provider) {
    final response = provider.classTestResultStudentResponse;
    if (identical(response, _lastSyncedResponse)) {
      return;
    }
    _lastSyncedResponse = response;

    final String nextMax =
        provider.totalMarks > 0 ? '${provider.totalMarks}' : '';
    if (_maxMarksController.text != nextMax) {
      _maxMarksController.text = nextMax;
    }

    for (final ctrl in _markControllers.values) {
      ctrl.dispose();
    }
    _markControllers.clear();

    final list = response?.studentList ?? <ClassTestStudent>[];
    for (int i = 0; i < list.length; i++) {
      final s = list[i];
      final int key = s.studentId ?? -(i + 1);
      final int obtained = s.obtainedMarks ?? 0;
      final String initialText =
          (provider.totalMarks > 0 && obtained > 0) ? '$obtained' : '';
      _markControllers[key] = TextEditingController(text: initialText);
    }
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.blueTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.assignment_outlined,
              size: 28,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No students found',
            style: AppThemes.sora(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select a section and subject with enrolled students.',
            textAlign: TextAlign.center,
            style: AppThemes.roboto(
              fontSize: 12.5,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassTestResultProvider>(
      builder: (context, value, _) {
        _syncControllersIfNeeded(value);

        final List<ClassTestStudent> studentList =
            value.classTestResultStudentResponse?.studentList ??
                <ClassTestStudent>[];

        final bool hasMax = value.totalMarks > 0;

        // Build indexed items for stable controller & updateObtainedMarks lookup
        final List<_IndexedStudent> ordered = List.generate(
          studentList.length,
          (i) => _IndexedStudent(index: i, student: studentList[i]),
        );

        ordered.sort((a, b) {
          if (_sortById) {
            return (a.student.studentId ?? 0)
                .compareTo(b.student.studentId ?? 0);
          }
          return (a.student.studentName ?? '')
              .toLowerCase()
              .compareTo((b.student.studentName ?? '').toLowerCase());
        });

        final String q = _searchQuery.trim().toLowerCase();
        final List<_IndexedStudent> visible = q.isEmpty
            ? ordered
            : ordered.where((entry) {
                final String name =
                    (entry.student.studentName ?? '').toLowerCase();
                final String id = '${entry.student.studentId ?? ''}'.toLowerCase();
                return name.contains(q) || id.contains(q);
              }).toList();

        // Compute marking progress across ALL students in class
        int markedCount = 0;
        int overMaxCount = 0;
        for (int i = 0; i < studentList.length; i++) {
          final s = studentList[i];
          final int key = s.studentId ?? -(i + 1);
          final String text = (_markControllers[key]?.text ?? '').trim();
          if (text.isEmpty) continue;
          final int? parsed = int.tryParse(text);
          if (parsed == null) continue;
          if (hasMax && parsed > value.totalMarks) {
            overMaxCount++;
          } else {
            markedCount++;
          }
        }

        final int pct = studentList.isEmpty
            ? 0
            : ((markedCount / studentList.length) * 100).round().clamp(0, 100);
        final bool canSave =
            hasMax && overMaxCount == 0 && markedCount > 0 && studentList.isNotEmpty;

        String barHint;
        Color barHintColor = AppColors.muted;
        if (!hasMax) {
          barHint = 'Set max marks first';
        } else if (overMaxCount > 0) {
          barHint = '$overMaxCount over the maximum';
          barHintColor = const Color(0xFFC42840);
        } else if (studentList.isNotEmpty && markedCount == studentList.length) {
          barHint = 'All marked';
        } else {
          barHint = '${studentList.length - markedCount} left';
        }

        return Column(
          children: [
            Expanded(
              child: Form(
                key: value.testFormKey,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  children: [
                    // Out of Box (.tm .max)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: hasMax ? Colors.white : const Color(0xFFFFFDF0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: hasMax
                              ? AppColors.line
                              : const Color(0xFFE0A21A),
                          width: hasMax ? 1 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Out of',
                                  style: AppThemes.sora(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasMax
                                      ? 'Marks for Test ${value.categoryId}'
                                      : 'Set the total marks to start',
                                  style: AppThemes.roboto(
                                    fontSize: 11.5,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 68,
                            child: TextFormField(
                              controller: _maxMarksController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              style: AppThemes.sora(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.blue,
                              ),
                              decoration: InputDecoration(
                                hintText: '–',
                                hintStyle: AppThemes.sora(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 9,
                                  horizontal: 6,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCDD4DE),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.blue,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC42840),
                                    width: 1.5,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC42840),
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(fontSize: 0, height: 0),
                              ),
                              validator: (val) {
                                final int total = int.tryParse(val ?? '') ?? 0;
                                if (total <= 0) return '';
                                return null;
                              },
                              onChanged: (val) {
                                final int total =
                                    val.isEmpty ? 0 : (int.tryParse(val) ?? 0);
                                setState(() {
                                  value.totalMarks = total;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Search & Sort Tools (.tm .tools)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFCDD4DE)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              style: AppThemes.roboto(
                                fontSize: 13,
                                color: AppColors.ink,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search student',
                                hintStyle: AppThemes.roboto(
                                  fontSize: 13,
                                  color: AppColors.muted,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  size: 18,
                                  color: AppColors.muted,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                          color: AppColors.muted,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                  horizontal: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => setState(() => _sortById = !_sortById),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFCDD4DE)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.filter_list_rounded,
                                  size: 16,
                                  color: AppColors.blue,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _sortById ? 'ID' : 'A–Z',
                                  style: AppThemes.sora(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Student Marks List Container (.tm .list)
                    if (studentList.isEmpty)
                      _buildEmptyState()
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: visible.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'No student matches "$_searchQuery"',
                                    style: AppThemes.roboto(
                                      fontSize: 12.5,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  for (int vIdx = 0;
                                      vIdx < visible.length;
                                      vIdx++) ...[
                                    if (vIdx > 0)
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFFEEF1F5),
                                      ),
                                    _buildStudentRow(
                                      provider: value,
                                      indexed: visible[vIdx],
                                      hasMax: hasMax,
                                    ),
                                  ],
                                ],
                              ),
                      ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Progress Ring & Save Footer (.tm .bar)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: CustomPaint(
                          painter: _ProgressRingPainter(
                            progress: studentList.isEmpty
                                ? 0
                                : (markedCount / studentList.length)
                                    .clamp(0.0, 1.0),
                          ),
                          child: Center(
                            child: Text(
                              '$pct%',
                              style: AppThemes.sora(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$markedCount/${studentList.length} marked',
                              style: AppThemes.sora(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              barHint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppThemes.roboto(
                                fontSize: 11.5,
                                color: barHintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: canSave
                              ? AppColors.yellow
                              : const Color(0xFFE6E9EE),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: canSave
                              ? const [
                                  BoxShadow(
                                    color: Color(0xFFD9C400),
                                    offset: Offset(0, 2),
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: canSave ? () => value.submitAllMarks() : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: Text(
                                  'Save Test ${value.categoryId}',
                                  style: AppThemes.sora(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: canSave
                                        ? AppColors.blue
                                        : const Color(0xFF9AA3B2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentRow({
    required ClassTestResultProvider provider,
    required _IndexedStudent indexed,
    required bool hasMax,
  }) {
    final ClassTestStudent s = indexed.student;
    final int key = s.studentId ?? -(indexed.index + 1);
    final TextEditingController ctrl =
        _markControllers.putIfAbsent(key, () => TextEditingController());
    final String raw = ctrl.text.trim();
    final int? parsed = int.tryParse(raw);

    final bool isPending = raw.isEmpty;
    final bool isOverMax = hasMax && parsed != null && parsed > provider.totalMarks;

    Color tagBg = const Color(0xFFEEF1F5);
    Color tagFg = const Color(0xFF7A8394);
    String tagLabel = 'PENDING';
    if (!isPending && isOverMax) {
      tagBg = const Color(0xFFFBE3E7);
      tagFg = const Color(0xFFC42840);
      tagLabel = 'MAX ${provider.totalMarks}';
    } else if (!isPending) {
      tagBg = const Color(0xFFDDF3EA);
      tagFg = const Color(0xFF0E8A5F);
      tagLabel = 'MARKED';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.studentName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppThemes.sora(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'ID ${s.studentId ?? '-'}',
                      style: AppThemes.roboto(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tagLabel,
                        style: AppThemes.sora(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: tagFg,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              hasMax
                  ? SizedBox(
                      width: 50,
                      height: 40,
                      child: TextFormField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        style: AppThemes.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isOverMax
                              ? const Color(0xFFC42840)
                              : AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isOverMax
                                  ? const Color(0xFFC42840)
                                  : const Color(0xFFCDD4DE),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: isOverMax
                                  ? const Color(0xFFC42840)
                                  : AppColors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          final int nextMarks =
                              val.isEmpty ? 0 : (int.tryParse(val) ?? 0);
                          provider.updateObtainedMarks(indexed.index, nextMarks);
                        },
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CustomPaint(
                        painter: _DashedRRectPainter(
                          color: Color(0xFFCDD4DE),
                          radius: 10,
                        ),
                      ),
                    ),
              const SizedBox(width: 4),
              SizedBox(
                width: 26,
                child: Text(
                  '/${hasMax ? provider.totalMarks : '–'}',
                  style: AppThemes.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndexedStudent {
  final int index;
  final ClassTestStudent student;

  const _IndexedStudent({
    required this.index,
    required this.student,
  });
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRRectPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(0.75);
    final Path path = Path()..addRRect(rrect);
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dash = 4.0;
    const double gap = 3.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  const _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - 5) / 2;

    final Paint trackPaint = Paint()
      ..color = const Color(0xFFE6E9EE)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = const Color(0xFF0E8A5F)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
