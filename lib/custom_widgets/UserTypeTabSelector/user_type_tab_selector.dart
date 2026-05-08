import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/model/Options/options.dart';

/// A reusable tab selector showing a modern moving indicator.
/// - `options`: list of `Options` to show as tabs
/// - `initialIndex`: which tab to start on
/// - `onChanged`: callback with selected index when user taps a tab
/// - `height`: height of the tab container
class UserTypeTabSelector extends StatefulWidget {
  final List<Options> options;
  final int initialIndex;
  final void Function(int index) onChanged;
  final double height;

  const UserTypeTabSelector({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialIndex = 0,
    this.height = 48,
  });

  @override
  State<UserTypeTabSelector> createState() => _UserTypeTabSelectorState();
}

class _UserTypeTabSelectorState extends State<UserTypeTabSelector>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.options.length,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, widget.options.length - 1),
    );
    _controller.addListener(() {
      if (!_controller.indexIsChanging) return;
      widget.onChanged(_controller.index);
    });
  }

  @override
  void didUpdateWidget(covariant UserTypeTabSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.length != oldWidget.options.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.options.length,
        vsync: this,
        initialIndex: widget.initialIndex.clamp(0, widget.options.length - 1),
      );
      _controller.addListener(() {
        if (!_controller.indexIsChanging) return;
        widget.onChanged(_controller.index);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.softGreyText,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        isScrollable: false,
        tabs: widget.options
            .map((t) => Tab(child: Text((t.title ?? '').toUpperCase())))
            .toList(),
        onTap: (index) => widget.onChanged(index),
      ),
    );
  }
}
