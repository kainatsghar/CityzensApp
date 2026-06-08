import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomTitleValue extends StatelessWidget {
  final String value;
  final String title;
  final bool boldValue;
  final bool showDivider;
  final bool isCopyAllowed;
  final bool isSelectionAllowed;

  const CustomTitleValue({
    super.key,
    required this.value,
    required this.title,
    this.boldValue = false,
    this.isCopyAllowed = false,
    this.isSelectionAllowed = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: SelectableText(
                  value,
                  enableInteractiveSelection: isSelectionAllowed,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.primaryDarkColor,
                    fontSize: 13,
                    fontWeight: boldValue ? FontWeight.w800 : FontWeight.w600,
                    height: 1.3,
                  ),
                  contextMenuBuilder: (context, editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems = [];
                    if (!editableTextState.textEditingValue.selection.isCollapsed) {
                      buttonItems.add(
                        ContextMenuButtonItem(
                          onPressed: () {
                            editableTextState.copySelection(SelectionChangedCause.toolbar);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                            editableTextState.hideToolbar();
                          },
                          type: ContextMenuButtonType.copy,
                        ),
                      );
                    }
                    buttonItems.add(
                      ContextMenuButtonItem(
                        onPressed: () => editableTextState.selectAll(SelectionChangedCause.toolbar),
                        type: ContextMenuButtonType.selectAll,
                      ),
                    );
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                ),
              ),
              if (isCopyAllowed) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Icon(
                    Icons.copy_rounded, 
                    size: 14, 
                    color: AppColors.primaryColor.withValues(alpha: 0.6)
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withValues(alpha: 0.15),
          ),
      ],
    );
  }
}
