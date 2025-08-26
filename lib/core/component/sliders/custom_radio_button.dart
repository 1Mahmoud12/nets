import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class CustomRadioButton extends StatefulWidget {
  final bool? value;
  final String nameRadioButton;
  final String? subTitle;
  final Function({required bool selected})? onTap;

  const CustomRadioButton({super.key, this.value, this.onTap, required this.nameRadioButton, this.subTitle});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) selected = widget.value!;
  }

  @override
  void didUpdateWidget(covariant CustomRadioButton oldWidget) {
    if (widget.value != null) selected = widget.value!;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selected = !selected;
        setState(() {});
        widget.onTap?.call(selected: selected);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cP50, width: 2),
              //  color: selected == true ? AppColors.primaryColor : AppColors.transparent,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              width: 12,
              height: 12,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: selected == true ? AppColors.cP50 : Colors.transparent),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nameRadioButton.tr(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.cP50, fontWeight: FontWeight.w400),
                ),
                //   const SizedBox(height: 8),
                if (widget.subTitle != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (widget.subTitle ?? '').tr(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.cP50.withAlpha((0.5 * 255).toInt())),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
