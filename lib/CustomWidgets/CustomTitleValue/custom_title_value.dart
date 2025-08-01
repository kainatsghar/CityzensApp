import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomTitleValue extends StatelessWidget {
  final String value;
  final String title;
  final bool showDivider;
  final bool isCopyAllowed;

  const CustomTitleValue({
    super.key,
    required this.value,
    required this.title,
    this.isCopyAllowed = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 3.4,
                child: Text(
                  '$title: ',
                  style: const TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SelectableText(
                  enableInteractiveSelection: isCopyAllowed,
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              if (isCopyAllowed)
                SizedBox(
                  height: 16,
                  child: IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        Visibility(
          visible: showDivider,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Divider(height: 0.0, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
