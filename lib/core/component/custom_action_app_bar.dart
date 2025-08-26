import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constant_gaping.dart';

class CustomActionAppBar extends StatelessWidget {
  const CustomActionAppBar({super.key, required this.title, this.onPressLeading, this.stopLeading = true});
  final String title;
  final bool? stopLeading;
  final VoidCallback? onPressLeading;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (stopLeading!)
          InkWell(
            onTap: onPressLeading ?? () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: darkModeValue ? AppColors.darkModeText : AppColors.cDividerColor),
          ),
        w5,
        Text(
          title.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: darkModeValue ? AppColors.darkModeText : AppColors.cDividerColor,
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
            height: 1.7,
          ),
        ),
        s,

        InkWell(
          onTap: () {
            //   context.navigateToPage(const MenuView());
          },
          child: SvgPicture.asset(
            AppIcons.profileIcons,
            colorFilter:
                darkModeValue
                    ? const ColorFilter.mode(AppColors.darkModeText, BlendMode.srcIn)
                    : const ColorFilter.mode(AppColors.cDividerColor, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}
