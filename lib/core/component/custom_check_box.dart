import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/themes/styles.dart';
import 'package:nets/core/utils/screen_spaces_extension.dart';

import '../themes/colors.dart';

class CustomCheckBox extends StatefulWidget {
  final bool borderEnable;
  final bool? checkBox;
  final void Function(bool)? onTap;
  final double? paddingIcon;
  final double? borderRadius;
  final double? widthBorder;
  final Color? fillFalseValue;
  final Color? fillTrueValue;
  final Color? borderColor;
  final String? textValue;
  final Widget? child;

  const CustomCheckBox({
    super.key,
    this.borderEnable = true,
    this.fillFalseValue,
    this.fillTrueValue,
    this.paddingIcon,
    this.borderColor,
    this.widthBorder,
    this.textValue,
    this.borderRadius,
    this.onTap,
    this.checkBox = false,
    this.child,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.checkBox ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _isChecked = !_isChecked;
        setState(() {});
        if (widget.onTap != null) {
          widget.onTap!.call(_isChecked);
        }
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: Durations.short4,
            padding: EdgeInsets.all(widget.paddingIcon ?? 3),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).r),
              color: _isChecked ? widget.fillTrueValue ?? AppColors.primaryColor : widget.fillFalseValue ?? AppColors.white,
              border: Border.all(
                color: widget.borderEnable ? widget.borderColor ?? AppColors.cBorderDecoration : AppColors.transparent,
                width: widget.widthBorder ?? 1,
              ),
            ),
            child: Icon(Icons.check, size: 16, color: _isChecked ? AppColors.white : AppColors.transparent),
          ),
          if (widget.textValue != null) 10.ESW(),
          if (widget.child != null) widget.child!,
          if (widget.child == null)
            Expanded(
              child: Text(widget.textValue ?? '', style: Styles.style12400.copyWith(color: AppColors.subTextColor)),
            ),
        ],
      ),
    );
  }
}
