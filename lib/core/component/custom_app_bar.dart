import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

PreferredSizeWidget customAppBar({
  bool stopLeading = false,
  bool centerTitle = false,
  required BuildContext context,
  void Function()? onPressLeading,
  Widget? actions,
  Widget? titleWidget,
  String? title,
  double? titleSize,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    leading:
        stopLeading
            ? const SizedBox.shrink()
            : InkWell(
              onTap: onPressLeading ?? () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: SvgPicture.asset(
                    AppIcons.arrowDown,
                    fit: BoxFit.scaleDown,
                    color: darkModeValue ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
    centerTitle: centerTitle,

    title: Padding(
      padding: const EdgeInsets.only(top: 5),
      child:
          titleWidget ??
          Text(
            (title ?? '').tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: darkModeValue ? AppColors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: titleSize ?? 18.sp,
            ),
          ),
    ),

    actions: [
      if (actions != null)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: actions,
          ),
        )
      else
        Container(),
    ],
    leadingWidth: 40,
    titleSpacing: 0,

    toolbarHeight: 60,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(
        bottom != null ? bottom.preferredSize.height + 1 : 1,
      ),
      child: Column(
        children: [
          if (bottom != null) bottom,
          Divider(
            color:
                darkModeValue
                    ? const Color(0xff9CA3A3)
                    : AppColors.cBorderButtonColor,
            height: 0.6,
            thickness: darkModeValue ? 0.2 : 1,
          ),
        ],
      ),
    ),
  );
}
