import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_menu_button.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/citizen/Provider/ParentDashboard/parent_dashboard_provider.dart';
import 'package:tcs_app/citizen/Provider/StudentAttendance/student_attendance_provider.dart';

class MultiChildComponent extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const MultiChildComponent({
    super.key,
    this.onOpenDrawer,
  });

  @override
  State<MultiChildComponent> createState() => _MultiChildComponentState();
}

class _MultiChildComponentState extends State<MultiChildComponent> {
  int _selectedIndex = 0;
  int? _lastSyncedStudentId;

  String get _sessionLabel {
    final DateTime now = DateTime.now();
    final int startYear = now.month >= 8 ? now.year : now.year - 1;
    final int endShort = (startYear + 1) % 100;
    return 'SESSION $startYear–${endShort.toString().padLeft(2, '0')}';
  }

  void _syncSelectedChildIfNeeded(
    List<ChildInfo> children,
    LocalDataProvider localData,
    StudentAttendanceProvider attendance,
  ) {
    if (children.isEmpty) return;
    if (_selectedIndex >= children.length) {
      _selectedIndex = 0;
    }
    final ChildInfo child = children[_selectedIndex];
    final int? targetId = child.studentId;
    if (targetId == null || _lastSyncedStudentId == targetId) {
      return;
    }
    _lastSyncedStudentId = targetId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyChildSelection(child, localData, attendance);
    });
  }

  void _applyChildSelection(
    ChildInfo child,
    LocalDataProvider localData,
    StudentAttendanceProvider attendance,
  ) {
    final String idStr = '${child.studentId ?? ''}';
    if (localData.studentId != idStr) {
      localData.setStudentId(idStr);
    }
    if (localData.gradeId != child.classId) {
      localData.setSGradeId(child.classId);
    }
    if (idStr.isNotEmpty) {
      attendance
          .getAttendancePercentage()
          .catchError((_) => AttendancePercentageResponse());
    }
  }

  ({String cls, String section}) _splitClassSection(String? raw) {
    final String clean = (raw ?? '').trim();
    if (clean.isEmpty) return (cls: '—', section: '—');
    if (clean.contains('-')) {
      final parts = clean.split('-');
      final String cls = parts.first.trim();
      final String sec = parts.sublist(1).join('-').trim();
      return (
        cls: cls.isEmpty ? '—' : cls,
        section: sec.isEmpty ? '—' : sec,
      );
    }
    return (cls: clean, section: '—');
  }

  String _initialFor(String? name) {
    final String trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return 'S';
    return trimmed[0].toUpperCase();
  }

  void _openChildSheet(
    BuildContext context,
    List<ChildInfo> children,
    LocalDataProvider localData,
    StudentAttendanceProvider attendance,
  ) {
    if (children.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5DAE2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose child',
                        style: AppThemes.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '${children.length} ${children.length == 1 ? 'child' : 'children'}',
                        style: AppThemes.roboto(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.55,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: children.length,
                    itemBuilder: (_, index) {
                      final ChildInfo child = children[index];
                      final bool isSelected = index == _selectedIndex;
                      final parsed = _splitClassSection(child.className);
                      final String metaText = parsed.section == '—'
                          ? 'Class ${parsed.cls} · Roll ${child.studentId ?? '-'}'
                          : 'Class ${parsed.cls} – ${parsed.section} · Roll ${child.studentId ?? '-'}';

                      return InkWell(
                        onTap: () {
                          Navigator.of(sheetCtx).pop();
                          setState(() {
                            _selectedIndex = index;
                            _lastSyncedStudentId = child.studentId;
                          });
                          _applyChildSelection(child, localData, attendance);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.blueTint
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.yellow
                                      : AppColors.blueTint,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _initialFor(child.studentName),
                                  style: AppThemes.sora(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      child.studentName ?? 'Student',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppThemes.sora(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      metaText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppThemes.roboto(
                                        fontSize: 11.5,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: AppColors.blue,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ParentDashboardProvider, LocalDataProvider,
        StudentAttendanceProvider>(
      builder: (context, parentProvider, localData, attendance, _) {
        final List<ChildInfo> children =
            parentProvider.multiChildResponse?.children ?? <ChildInfo>[];

        if (children.isEmpty) {
          return Column(
            children: [
              _buildTopNavOnlyHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: AppColors.blueTint,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const CityzensIcon(
                              type: CityzensIconType.user,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No children linked yet',
                            style: AppThemes.sora(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pull down to refresh your child details.',
                            style: AppThemes.roboto(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        _syncSelectedChildIfNeeded(children, localData, attendance);

        final int safeIndex = _selectedIndex.clamp(0, children.length - 1);
        final ChildInfo child = children[safeIndex];
        final String localGradeId = '${child.classId ?? localData.gradeId ?? ''}';
        final String gradeId = localData.userData?.info?.gradeId?.toString() ?? '';

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              // P1 Blue Header (Top Bar + Child Switcher Card + Session Attendance Card)
              _buildHeader(
                context: context,
                children: children,
                selectedIndex: safeIndex,
                child: child,
                localData: localData,
                attendance: attendance,
                localGradeId: localGradeId,
                gradeId: gradeId,
              ),

              // Body (Bento Grid + Quick Actions Grid)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBentoGrid(),
                    const SizedBox(height: 14),
                    _buildQuickActionsGrid(
                      gradeId: gradeId,
                      localGradeId: localGradeId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopNavOnlyHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _buildTopBar(),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CityzensMenuButton(
          size: 40,
          onTap: () => widget.onOpenDrawer?.call(),
        ),
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/images/logo-horizontal-white.png',
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 40, height: 40),
      ],
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required List<ChildInfo> children,
    required int selectedIndex,
    required ChildInfo child,
    required LocalDataProvider localData,
    required StudentAttendanceProvider attendance,
    required String localGradeId,
    required String gradeId,
  }) {
    final parsed = _splitClassSection(child.className);
    final String rollNo = '${child.studentId ?? '-'}';
    final String campus = (child.centerName ?? '').trim();

    final num rawPct =
        attendance.attendancePercentage?.data?.attendancePercentage ?? 0;
    final int cleanPct = rawPct.clamp(0, 100).toInt();
    final int absentPct = (100 - cleanPct).clamp(0, 100);

    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 10),

              // P1 Selected Child Switcher Card
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openChildSheet(
                    context,
                    children,
                    localData,
                    attendance,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Yellow Circle Initial with White Ring
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _initialFor(child.studentName),
                                style: AppThemes.sora(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 34),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            child.studentName ?? 'Student',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppThemes.sora(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            '${selectedIndex + 1} of ${children.length}',
                                            style: AppThemes.sora(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: _buildMetaCol(
                                          'CLASS',
                                          parsed.cls,
                                        ),
                                      ),
                                      _buildMetaDivider(),
                                      Flexible(
                                        child: _buildMetaCol(
                                          'SECTION',
                                          parsed.section,
                                        ),
                                      ),
                                      _buildMetaDivider(),
                                      Flexible(
                                        child: _buildMetaCol(
                                          'ROLL NO.',
                                          rollNo,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (campus.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      campus,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppThemes.roboto(
                                        fontSize: 11,
                                        color:
                                            Colors.white.withValues(alpha: 0.78),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Session Attendance Summary Card (.par .ses)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: CustomPaint(
                        painter: _SessionRingPainter(
                          progress: (cleanPct / 100.0).clamp(0.0, 1.0),
                        ),
                        child: Center(
                          child: Text(
                            '$cleanPct%',
                            style: AppThemes.sora(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sessionLabel,
                            style: AppThemes.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Colors.white.withValues(alpha: 0.76),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 10,
                            runSpacing: 2,
                            children: [
                              _buildSessionStat(
                                color: const Color(0xFF4CD39B),
                                value: '$cleanPct%',
                                label: 'Present',
                              ),
                              _buildSessionStat(
                                color: const Color(0xFFFF7A90),
                                value: '$absentPct%',
                                label: 'Absent',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (gradeId == '19' ||
                              gradeId == '20' ||
                              localGradeId == '19' ||
                              localGradeId == '20') {
                            AppNavigation.navigateTo(
                              AppNavRoutes.attendanceSubjectRoute,
                            );
                          } else {
                            AppNavigation.navigateTo(
                              AppNavRoutes.attendanceRoute,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Monthly',
                                style: AppThemes.sora(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 15,
                                color: AppColors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildMetaDivider() {
    return Container(
      height: 20,
      width: 1,
      color: Colors.white.withValues(alpha: 0.22),
      margin: const EdgeInsets.symmetric(horizontal: 9),
    );
  }

  Widget _buildMetaCol(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          val,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppThemes.sora(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionStat({
    required Color color,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$value ',
          style: AppThemes.sora(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 11.5,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Hero Card: Homework diary
        Expanded(
          flex: 108,
          child: GestureDetector(
            onTap: () =>
                AppNavigation.navigateTo(AppNavRoutes.studentDiaryRoute),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 156,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -34,
                      bottom: -34,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.04),
                              spreadRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CityzensIcon(
                                type: CityzensIconType.homework,
                                size: 48,
                                primaryColor: Colors.white,
                                secondaryColor: AppColors.yellow,
                                accentColor: AppColors.blue,
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Homework\ndiary',
                            style: AppThemes.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Right Stack: Timetable + Classwork
        Expanded(
          flex: 100,
          child: Column(
            children: [
              _buildBentoMiniCard(
                title: 'Timetable',
                iconType: CityzensIconType.timetable,
                iconBg: AppColors.blueTint,
                onTap: () =>
                    AppNavigation.navigateTo(AppNavRoutes.teacherTimeTableRoute),
              ),
              const SizedBox(height: 8),
              _buildBentoMiniCard(
                title: 'Classwork',
                iconType: CityzensIconType.classwork,
                iconBg: const Color(0xFFFFF8C4),
                onTap: () =>
                    AppNavigation.navigateTo(AppNavRoutes.studentAssignmentRoute),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBentoMiniCard({
    required String title,
    required CityzensIconType iconType,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueDeep.withValues(alpha: 0.06),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CityzensIcon(type: iconType, size: 24),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.blueTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.blue,
                    size: 15,
                  ),
                ),
              ],
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppThemes.sora(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid({
    required String gradeId,
    required String localGradeId,
  }) {
    final List<Widget> buttons = [
      _buildQuickButton(
        iconType: CityzensIconType.user,
        label: 'Profile',
        onTap: () =>
            AppNavigation.navigateTo(AppNavRoutes.studentProfileRoute),
      ),
      _buildQuickButton(
        iconType: CityzensIconType.attendance,
        label: 'Attendance',
        onTap: () {
          if (gradeId == '19' ||
              gradeId == '20' ||
              localGradeId == '19' ||
              localGradeId == '20') {
            AppNavigation.navigateTo(AppNavRoutes.attendanceSubjectRoute);
          } else {
            AppNavigation.navigateTo(AppNavRoutes.attendanceRoute);
          }
        },
      ),
    ];

    if (gradeId != '2' &&
        gradeId != '3' &&
        gradeId != '4' &&
        localGradeId != '2' &&
        localGradeId != '3' &&
        localGradeId != '4') {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.results,
          label: 'Term result',
          onTap: () =>
              AppNavigation.navigateTo(AppNavRoutes.academicTermRoute),
        ),
      );
    }

    if (gradeId != '2' &&
        gradeId != '3' &&
        gradeId != '4' &&
        gradeId != '5' &&
        gradeId != '6' &&
        localGradeId != '2' &&
        localGradeId != '3' &&
        localGradeId != '4' &&
        localGradeId != '5' &&
        localGradeId != '6') {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.tests,
          label: 'Class tests',
          onTap: () => AppNavigation.navigateTo(
            AppNavRoutes.studentClassTestResultRoute,
          ),
        ),
      );
    }

    buttons.addAll([
      _buildQuickButton(
        iconType: CityzensIconType.fees,
        label: 'Fees',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
      ),
      _buildQuickButton(
        iconType: CityzensIconType.circulars,
        label: 'Circulars',
        onTap: () =>
            AppNavigation.navigateTo(AppNavRoutes.notificationsRoute),
      ),
      _buildQuickButton(
        iconType: CityzensIconType.library,
        label: 'Library',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
      ),
    ]);

    if (gradeId == '2' ||
        gradeId == '3' ||
        gradeId == '4' ||
        localGradeId == '2' ||
        localGradeId == '3' ||
        localGradeId == '4') {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.eyeChild,
          label: 'Eye on your\nchild',
          ringHighlight: true,
          onTap: () => AppNavigation.navigateTo(
            AppNavRoutes.parentEyeOnYourChildRoute,
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 4,
      mainAxisSpacing: 8,
      childAspectRatio: 0.80,
      children: buttons,
    );
  }

  Widget _buildQuickButton({
    required CityzensIconType iconType,
    required String label,
    required VoidCallback onTap,
    bool ringHighlight = false,
  }) {
    final Widget iconBox = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueDeep.withValues(alpha: 0.06),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: CityzensIcon(type: iconType, size: 28),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ringHighlight
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.blue.withValues(alpha: 0.16),
                      width: 1.5,
                    ),
                  ),
                  child: iconBox,
                )
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: iconBox,
                ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppThemes.roboto(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              height: 1.15,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRingPainter extends CustomPainter {
  final double progress;

  const _SessionRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - 5) / 2;

    final Paint trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = AppColors.yellow
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
  bool shouldRepaint(covariant _SessionRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
