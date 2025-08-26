import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class CheckBoxButtonWidget extends StatefulWidget {
  const CheckBoxButtonWidget({super.key, this.borderValue, this.isChecked});

  final double? borderValue;
  final bool? isChecked;

  @override
  State<CheckBoxButtonWidget> createState() => _CheckBoxButtonWidgetState();
}

class _CheckBoxButtonWidgetState extends State<CheckBoxButtonWidget> {
  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked ?? false;
  }

  late bool _isChecked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: _isChecked ? AppColors.primaryColor : Colors.white,
          border: Border.all(color: _isChecked ? Colors.transparent : Colors.grey.withAlpha((0.4 * 255).toInt())),
          borderRadius: BorderRadius.circular(widget.borderValue ?? 8),
        ),
        child: _isChecked ? const Icon(Icons.check, size: 18.0, color: Colors.white) : null,
      ),
    );
  }
}
