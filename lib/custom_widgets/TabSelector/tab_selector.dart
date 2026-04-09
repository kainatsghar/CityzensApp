import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class TabSelector<T> extends StatefulWidget {
  final List<T>? items;
  final Function(T) getDisplayText;
  final Function(T item) onItemSelected;
  final String? initialItemName;
  final bool isEnabled;

  const TabSelector({
    required this.items,
    required this.getDisplayText,
    required this.onItemSelected,
    this.initialItemName,
    this.isEnabled = true,
    super.key,
  });

  @override
  State<TabSelector<T>> createState() => _TabSelectorState<T>();
}

class _TabSelectorState<T> extends State<TabSelector<T>>
    with TickerProviderStateMixin {
  late Map<int, AnimationController> _scaleControllers;

  @override
  void initState() {
    super.initState();
    _scaleControllers = {};
    _initControllers();

    // Auto-select first item in provider IF NO initial selection provided
    if (widget.initialItemName == null || widget.initialItemName!.isEmpty) {
      _triggerAutoSelection();
    }
  }

  void _initControllers() {
    if (widget.items != null) {
      for (int i = 0; i < widget.items!.length; i++) {
        _scaleControllers.putIfAbsent(
          i,
          () => AnimationController(
            duration: const Duration(milliseconds: 150),
            vsync: this,
          ),
        );
      }
    }
  }

  void _triggerAutoSelection() {
    if (widget.items != null && widget.items!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onItemSelected(widget.items![0]);
        }
      });
    }
  }

  @override
  void didUpdateWidget(TabSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _initControllers();
    }
    // If no selection provided, auto-select first one again?
    // No, only on first init usually.
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectItem(int index) {
    if (widget.items != null && index < widget.items!.length) {
      _scaleControllers[index]?.forward().then((_) {
        _scaleControllers[index]?.reverse();
      });
      widget.onItemSelected(widget.items![index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items == null || widget.items!.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: const Center(
          child: Text(
            'No items available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Determine selection from initialItemName from parent
    int selectedIndex = -1;
    bool hasInitialName =
        widget.initialItemName != null && widget.initialItemName!.isNotEmpty;

    if (hasInitialName) {
      selectedIndex = widget.items!.indexWhere(
        (item) => widget.getDisplayText(item) == widget.initialItemName,
      );
    } else if (widget.items!.isNotEmpty) {
      // No initial name provided, default to first item
      selectedIndex = 0;
    }

    return Wrap(
      runSpacing: 8,
      spacing: 8,
      alignment: WrapAlignment.start,
      children: List.generate(widget.items!.length, (index) {
        final item = widget.items![index];
        final displayText = widget.getDisplayText(item);
        final isSelected = selectedIndex == index;

        return ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: widget.isEnabled ? 1.08 : 1.0)
              .animate(
            CurvedAnimation(
              parent:
                  _scaleControllers[index] ??
                  AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 150),
                  ),
              curve: Curves.easeInOut,
            ),
          ),
          child: GestureDetector(
            onTap: widget.isEnabled ? () => _selectItem(index) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(widget.isEnabled ? 1.0 : 0.5)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(widget.isEnabled ? 1.0 : 0.5)
                      : Colors.grey.shade200,
                  width: isSelected ? 2.0 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isSelected
                      ? AppColors.whiteColor
                      : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                child: Text(displayText),
              ),
            ),
          ),
        );
      }),
    );
  }
}
