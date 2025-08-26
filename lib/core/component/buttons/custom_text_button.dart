import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/loadsErros/loading_widget.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants.dart';

class CustomTextButton extends StatefulWidget {
  final Widget? child;
  final String? childText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? colorText;
  final void Function()? onPress;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool state;
  final bool showArrowButton;
  final bool isExpand;
  final BorderRadiusGeometry? allBorderRadius;

  const CustomTextButton({
    super.key,
    this.child,
    required this.onPress,
    this.backgroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.borderColor,
    this.padding,
    this.margin,
    this.childText,
    this.colorText,
    this.allBorderRadius,
    this.isExpand = true,
    this.state = false,
    this.showArrowButton = false,
    this.borderWidth = 1.5,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.state != true ? widget.onPress : null,
      child: Container(
        margin: widget.margin,
        padding: widget.padding ?? const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.cBackGroundButtonColor,
          border: Border.all(color: widget.borderColor ?? AppColors.cBorderButtonColor, width: widget.borderWidth),
          borderRadius: widget.allBorderRadius ?? BorderRadius.circular((widget.borderRadius ?? 40).r),
        ),
        alignment: widget.isExpand ? AlignmentDirectional.center : null,
        child: widget.state
            ? const LoadingWidget(height: 20, width: 20, color: Colors.white)
            : !widget.showArrowButton
            ? FittedBox(
                child:
                    widget.child ??
                    Text(
                      (widget.childText ?? '').tr(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: arabicLanguage ? 16.sp : 16.sp,
                        color: widget.colorText ?? (darkModeValue ? AppColors.darkModeText : AppColors.black),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.child ??
                      Text(
                        (widget.childText ?? '').tr(),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: arabicLanguage ? 16.sp : 16.sp,
                          color: widget.colorText ?? (darkModeValue ? AppColors.darkModeText : AppColors.black),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  if (widget.showArrowButton) const SizedBox(width: 10),
                  if (widget.showArrowButton) RotatedBox(quarterTurns: arabicLanguage ? 2 : 0, child: SvgPicture.asset(AppIcons.arrowButton)),
                ],
              ),
      ),
    );
  }
}
