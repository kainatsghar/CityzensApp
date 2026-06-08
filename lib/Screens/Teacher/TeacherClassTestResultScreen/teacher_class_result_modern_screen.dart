import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/model/ClassTestResult/class_test_student_list_response.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/model/AddClassTestResult/add_class_test_result_request.dart';
import 'package:tcs_app/services/ClassTestResult/class_test_result_service.dart';

class ClassTestResultsScreen extends StatefulWidget {
  const ClassTestResultsScreen({super.key});

  @override
  State<ClassTestResultsScreen> createState() => _ClassTestResultsScreenState();
}

class _ClassTestResultsScreenState extends State<ClassTestResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Map<int, TextEditingController> _maxMarksControllers = {
    1: TextEditingController(),
    2: TextEditingController(),
    3: TextEditingController(),
  };

  int _activeTestIndex = 0; // 0, 1, 2
  String _searchQuery = '';
  late EnhancedClassTestProvider _state;

  @override
  void initState() {
    super.initState();
    final baseProvider = Provider.of<ClassTestResultProvider>(
      context,
      listen: false,
    );
    _state = EnhancedClassTestProvider(baseProvider);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _state.loadAllTests();
    if (mounted) {
      for (int i = 1; i <= 3; i++) {
        _maxMarksControllers[i]!.text = _state.getMaxMarks(i) > 0
            ? _state.getMaxMarks(i).toString()
            : '';
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var c in _maxMarksControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_activeTestIndex == index) return;
    setState(() => _activeTestIndex = index);
  }

  Future<void> _handleSaveAction(int testId) async {
    final stats = _state.getStats(testId);
    final int emptyCount = stats.totalStudents - stats.marked;

    if (emptyCount > 0) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Incomplete Entry',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Text(
            'You haven\'t entered marks for $emptyCount students. They will be recorded as "0".\n\nDo you want to continue?',
            style: TextStyle(height: 1.5, color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'WAIT',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'YES, SAVE',
                style: TextStyle(
                  color: AppColors.primaryDarkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    await _state.submitTest(testId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ChangeNotifierProvider.value(
        value: _state,
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F8FB),
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'CLASS TEST RESULTS'),
          body: Consumer<EnhancedClassTestProvider>(
            builder: (context, state, child) {
              if (state.isLoading) return const CustomLoader();
              if (state.error != null) {
                return ShowError(errorText: state.error!);
              }

              return Column(
                children: [
                  _buildRefinedHeader(state),
                  _buildModernSegmentedControl(),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Container(
                        key: ValueKey(_activeTestIndex),
                        child: _buildStudentList(state, _activeTestIndex + 1),
                      ),
                    ),
                  ),
                  _buildActionBottomBar(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRefinedHeader(EnhancedClassTestProvider state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.primaryDarkColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.base.subjectController.text.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDarkColor,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'SECTION: ${state.base.sectionController.text.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildInputBox(
                  label: 'MAX MARKS',
                  controller: _maxMarksControllers[_activeTestIndex + 1]!,
                  isNumeric: true,
                  onChanged: (val) => state.setMaxMarks(
                    _activeTestIndex + 1,
                    int.tryParse(val) ?? 0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: _buildInputBox(
                  label: 'SEARCH STUDENT...',
                  controller: _searchController,
                  icon: Icons.search_rounded,
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    bool isNumeric = false,
    TextAlign textAlign = TextAlign.start,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: textAlign,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: AppColors.primaryDarkColor,
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumeric
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ]
            : null,
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 18,
                  color: AppColors.primaryDarkColor.withValues(alpha: 0.6),
                )
              : null,
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildModernSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left:
                  (MediaQuery.of(context).size.width - 40) /
                  3 *
                  _activeTestIndex,
              width: (MediaQuery.of(context).size.width - 40) / 3,
              top: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDarkColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: List.generate(3, (index) {
                final isSelected = _activeTestIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(index),
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        'TEST ${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(EnhancedClassTestProvider state, int categoryId) {
    final students = state.getStudents(categoryId);
    final filtered = students
        .where(
          (s) =>
              s.studentName!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No records found',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: filtered.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final student = filtered[index];
        return StudentMarksCard(
          key: ValueKey('${categoryId}_${student.studentId}'),
          student: student,
          testId: categoryId, // Pass categoryId to the card
          maxMarks: state.getMaxMarks(categoryId),
          onMarksChanged: (marks) => state.updateMarks(
            categoryId,
            student.studentId!,
            marks,
            isInteracted: true,
          ),
        );
      },
    );
  }

  Widget _buildActionBottomBar(EnhancedClassTestProvider state) {
    final int testId = _activeTestIndex + 1;
    final stats = state.getStats(testId);
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bool canSave = state.isTestValid(testId) && !state.isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, isKeyboardVisible ? 14 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 26.0,
              lineWidth: 5.0,
              percent: stats.progress,
              center: Text(
                "${(stats.progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDarkColor,
                ),
              ),
              progressColor: AppColors.primaryDarkColor,
              backgroundColor: Colors.grey.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animateFromLastPercent: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${stats.marked}/${stats.totalStudents} Marked',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    state.getMaxMarks(testId) > 0
                        ? 'Current Test Results'
                        : 'Wait... Set Max Marks',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _SaveButton(
              title: 'SAVE TEST $testId',
              onPressed: canSave ? () => _handleSaveAction(testId) : null,
              isLoading: state.isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SaveButton({
    required this.title,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 145,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: onPressed == null ? 0 : 4,
          shadowColor: AppColors.primaryDarkColor.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

class StudentMarksCard extends StatefulWidget {
  final ClassTestStudent student;
  final int testId;
  final int maxMarks;
  final Function(int) onMarksChanged;

  const StudentMarksCard({
    super.key,
    required this.student,
    required this.testId,
    required this.maxMarks,
    required this.onMarksChanged,
  });

  @override
  State<StudentMarksCard> createState() => _StudentMarksCardState();
}

class _StudentMarksCardState extends State<StudentMarksCard> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Check provider for interaction status to correctly handle saved '0' marks
    final provider = Provider.of<EnhancedClassTestProvider>(
      context,
      listen: false,
    );
    final isPreviouslyMarked = provider.isInteracted(
      widget.testId,
      widget.student.studentId!,
    );

    _controller = TextEditingController(
      text: (widget.student.obtainedMarks == 0 && !isPreviouslyMarked)
          ? ''
          : widget.student.obtainedMarks.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A student is marked if the field is not empty OR the provider says they are interacted
    final provider = Provider.of<EnhancedClassTestProvider>(context);
    final bool isMarked =
        _controller.text.isNotEmpty ||
        provider.isInteracted(widget.testId, widget.student.studentId!);

    final int marks = int.tryParse(_controller.text) ?? 0;
    final bool isExceeding = widget.maxMarks > 0 && marks > widget.maxMarks;
    final bool isMissingMax = widget.maxMarks <= 0 && marks > 0;
    final bool isInvalid = isExceeding || isMissingMax;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? AppColors.primaryDarkColor.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isInvalid
              ? Colors.red.shade400
              : (_isFocused
                    ? AppColors.primaryDarkColor.withValues(alpha: 0.3)
                    : Colors.transparent),
          width: 1.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkColor.withValues(
                alpha: _isFocused ? 1 : 0.08,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${widget.student.studentId}',
                style: TextStyle(
                  color: _isFocused ? Colors.white : AppColors.primaryDarkColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student.studentName ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF1B1E28),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      isMarked
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 15,
                      color: isMarked
                          ? Colors.green.shade600
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isMarked ? 'RECORDED' : 'PENDING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isMarked
                            ? Colors.green.shade600
                            : Colors.grey.shade400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildMarkEntry(isInvalid),
        ],
      ),
    );
  }

  Widget _buildMarkEntry(bool isInvalid) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 72,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isInvalid ? Colors.red.shade300 : Colors.grey.shade200,
              width: 1.2,
            ),
          ),
          child: Focus(
            onFocusChange: (f) => setState(() => _isFocused = f),
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 19,
                color: isInvalid
                    ? Colors.red.shade800
                    : AppColors.primaryDarkColor,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
              ),
              onChanged: (v) {
                widget.onMarksChanged(int.tryParse(v) ?? 0);
                setState(() {});
              },
            ),
          ),
        ),
        if (widget.maxMarks > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 2),
            child: Text(
              'OUT OF ${widget.maxMarks}',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isInvalid ? Colors.red.shade700 : Colors.grey.shade500,
                letterSpacing: 0.3,
              ),
            ),
          ),
      ],
    );
  }
}

class EnhancedClassTestProvider with ChangeNotifier {
  final ClassTestResultProvider base;
  final Map<int, List<ClassTestStudent>> _testData = {};
  final Map<int, int> _maxMarks = {};
  final Map<int, Set<int>> _interactedStudents = {1: {}, 2: {}, 3: {}};
  bool isLoading = true;
  bool isSubmitting = false;
  String? error;

  EnhancedClassTestProvider(this.base);

  bool isStudentMarked(int testId, int studentId) {
    return _interactedStudents[testId]?.contains(studentId) ?? false;
  }

  bool isInteracted(int testId, int studentId) =>
      isStudentMarked(testId, studentId);

  bool isTestValid(int id) {
    if (_testData.isEmpty) return false;
    final max = getMaxMarks(id);
    if (max <= 0) return false;

    final students = getStudents(id);
    if (students.isEmpty) return false;

    if (_interactedStudents[id]!.isEmpty) return false;

    for (var s in students) {
      if ((s.obtainedMarks ?? 0) > max) return false;
    }
    return true;
  }

  Future<void> loadAllTests() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await Future.wait([_fetchTest(1), _fetchTest(2), _fetchTest(3)]);
    } catch (e) {
      error = "Load Failed: Try Again";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchTest(int id) async {
    final response = await ClassTestResultService.classTestResulStdListRequest(
      id: base.localDataProvider.userData!.userName!,
      subjectId: '${base.subjectId}',
      sectionId: '${base.sectionId ?? 0}',
      categoryId: id,
      totalMarks: 0,
    );
    if (response.studentList != null) {
      _testData[id] = response.studentList!;
      _maxMarks[id] = response.studentList!.isNotEmpty
          ? (response.studentList![0].totalMarks ?? 0)
          : 0;

      if (_maxMarks[id]! > 0) {
        for (var student in response.studentList!) {
          _interactedStudents[id]!.add(student.studentId!);
        }
      }
    }
  }

  List<ClassTestStudent> getStudents(int id) => _testData[id] ?? [];
  int getMaxMarks(int id) => _maxMarks[id] ?? 0;

  void setMaxMarks(int id, int value) {
    _maxMarks[id] = value;
    notifyListeners();
  }

  void updateMarks(
    int testId,
    int studentId,
    int marks, {
    bool isInteracted = false,
  }) {
    final students = _testData[testId];
    if (students != null) {
      final index = students.indexWhere((s) => s.studentId == studentId);
      if (index != -1) {
        students[index].obtainedMarks = marks;
        if (isInteracted) {
          _interactedStudents[testId]!.add(studentId);
        }
        notifyListeners();
      }
    }
  }

  TestStats getStats(int id) {
    final students = getStudents(id);
    if (students.isEmpty) return TestStats(0, 0, 0);
    final markedCount = _interactedStudents[id]!.length;
    return TestStats(
      markedCount,
      students.length,
      markedCount / students.length,
    );
  }

  Future<void> submitTest(int testId) async {
    isSubmitting = true;
    notifyListeners();
    DialogBuilder.showLoadingIndicator();
    try {
      final students = getStudents(testId);
      final totalMarks = getMaxMarks(testId);
      List<StudentMarks> marksList = students
          .map(
            (s) => StudentMarks(
              studentId: s.studentId,
              obtainedMarks: s.obtainedMarks,
            ),
          )
          .toList();

      await ClassTestResultService.addStudentMarks(
        AddClassTestResultRequest(
          categoryId: testId,
          subjectId: base.subjectId,
          teacherId: int.tryParse(
            base.localDataProvider.userData!.userName.toString(),
          ),
          studentMarks: marksList,
          totalMarks: totalMarks,
        ),
      );
      showSnackBar(
        'Test $testId Results Saved Successfully',
        color: AppColors.successGreenColor,
      );
    } catch (e) {
      showSnackBar('Error while saving Test $testId');
    } finally {
      isSubmitting = false;
      DialogBuilder.hideOpenDialog();
      notifyListeners();
    }
  }
}

class TestStats {
  final int marked;
  final int totalStudents;
  final double progress;
  TestStats(this.marked, this.totalStudents, this.progress);
}
