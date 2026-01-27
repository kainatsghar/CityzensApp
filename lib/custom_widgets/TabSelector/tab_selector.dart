import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class TabSelector<T> extends StatefulWidget {
  final List<T>? items;
  final Function(T) getDisplayText;
  final Function(T item) onItemSelected;
  final String? initialItemName;

  const TabSelector({
    required this.items,
    required this.getDisplayText,
    required this.onItemSelected,
    this.initialItemName,
    super.key,
  });

  @override
  State<TabSelector<T>> createState() => _TabSelectorState<T>();
}

class _TabSelectorState<T> extends State<TabSelector<T>>
    with TickerProviderStateMixin {
  late int _selectedIndex;
  late Map<int, AnimationController> _scaleControllers;

  @override
  void initState() {
    super.initState();
    // Auto-select first item or find by name if provided
    _selectedIndex = 0;
    _scaleControllers = {};

    if (widget.items != null && widget.items!.isNotEmpty) {
      // Initialize scale controllers for each item
      for (int i = 0; i < widget.items!.length; i++) {
        _scaleControllers[i] = AnimationController(
          duration: const Duration(milliseconds: 150),
          vsync: this,
        );
      }

      if (widget.initialItemName != null &&
          widget.initialItemName!.isNotEmpty) {
        _selectedIndex = widget.items!.indexWhere(
          (item) => widget.getDisplayText(item) == widget.initialItemName,
        );
        if (_selectedIndex == -1) _selectedIndex = 0;
      }
      // Notify parent of initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.items != null && widget.items!.isNotEmpty && mounted) {
          widget.onItemSelected(widget.items![_selectedIndex]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectItem(int index) {
    if (_selectedIndex != index &&
        widget.items != null &&
        index < widget.items!.length) {
      // Animate scale for new selection
      _scaleControllers[index]?.forward().then((_) {
        _scaleControllers[index]?.reverse();
      });

      setState(() {
        _selectedIndex = index;
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.items!.length, (index) {
          final item = widget.items![index];
          final displayText = widget.getDisplayText(item);
          final isSelected = _selectedIndex == index;

          return ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.08).animate(
              CurvedAnimation(
                parent: _scaleControllers[index]!,
                curve: Curves.easeInOut,
              ),
            ),
            child: GestureDetector(
              onTap: () => _selectItem(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 8,
                  right: index == widget.items!.length - 1 ? 0 : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.white,
                    width: isSelected ? 2.0 : 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                  child: Text(displayText),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
