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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.primaryDarkBlue,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        isScrollable: false,
        tabs: widget.options
            .map((t) => Tab(child: Text(t.title ?? '')))
            .toList(),
        onTap: (index) => widget.onChanged(index),
      ),
    );
  }
}
