import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:load_switch/load_switch.dart';
import 'package:nets/core/themes/colors.dart';

class CustomLoadSwitchWidget extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Future<bool> Function() future;
  final Function({required bool value}) onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Widget? spacer;
  final TextStyle? labelStyle;
  final bool? state;
  final double? labelFontSize;

  const CustomLoadSwitchWidget({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = AppColors.green,
    this.inactiveColor = AppColors.cinActiveColor,
    this.spacer,
    this.labelStyle,
    this.labelFontSize,
    required this.future,
    this.state = false,
  }) : super(key: key);

  @override
  State<CustomLoadSwitchWidget> createState() => _CustomLoadSwitchWidgetState();
}

class _CustomLoadSwitchWidgetState extends State<CustomLoadSwitchWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomLoadSwitchWidget oldWidget) {
    _value = widget.initialValue;
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label,
          style:
              widget.labelStyle ??
              Theme.of(
                context,
              ).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500, color: AppColors.cNameStatusColor, fontSize: widget.labelFontSize),
        ),
        widget.spacer ?? SizedBox(width: 12.w),
        Stack(
          children: [
            LoadSwitch(
              value: _value,
              future: widget.future,
              width: 50.w,
              height: 28.h,
              switchDecoration: (value, key) =>
                  BoxDecoration(color: value ? widget.activeColor : widget.inactiveColor, borderRadius: BorderRadius.circular(30)),
              thumbSizeRatio: 0.8,
              onChange: (v) {
                setState(() {
                  _value = v;
                });
                widget.onChanged(value: v);
              },
              onTap: (v) {},
            ),
            if (widget.state!) Positioned.fill(child: Container(color: Colors.white.withAlpha((0.4 * 255).toInt()))),
          ],
        ),
      ],
    );
  }
}
