import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constant_gaping.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.title, this.color});
  final String title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(width: 6, height: 34, color: AppColors.primaryColor),
          w10,
          Text(
            title.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color ?? AppColors.primaryColor, fontSize: 22.sp, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
