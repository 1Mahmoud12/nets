// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

class LabelCheckbox extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Function(bool) onChanged;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const LabelCheckbox({Key? key, required this.label, this.initialValue = false, required this.onChanged, this.width, this.padding})
    : super(key: key);

  @override
  State<LabelCheckbox> createState() => _LabelCheckboxState();
}

class _LabelCheckboxState extends State<LabelCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: InkWell(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
          });
          widget.onChanged(isChecked);
        },
        borderRadius: BorderRadius.circular(7),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(7),
                color: isChecked ? Colors.white : Colors.white,
              ),
              child: isChecked ? Icon(Icons.check, size: 18, color: Theme.of(context).primaryColor) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
