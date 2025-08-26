import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';

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
    leading: stopLeading
        ? const SizedBox.shrink()
        : InkWell(
            onTap: onPressLeading ?? () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_back_ios, color: darkModeValue ? Colors.white : Colors.black),
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
              fontWeight: FontWeight.w800,
              fontSize: titleSize ?? 20.sp,
            ),
          ),
    ),

    actions: [
      if (actions != null)
        Expanded(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: actions),
        )
      else
        Container(),
    ],
    leadingWidth: 40,
    titleSpacing: 0,

    toolbarHeight: 60,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(bottom != null ? bottom.preferredSize.height + 1 : 1),
      child: Column(
        children: [
          if (bottom != null) bottom,
          Divider(color: darkModeValue ? const Color(0xff9CA3A3) : AppColors.cBorderButtonColor, height: 0.6, thickness: darkModeValue ? 0.2 : 1),
        ],
      ),
    ),
  );
}
