import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constant_gaping.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.isActive, this.isFeatured = false});

  final bool isActive;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isFeatured ? 'trending'.tr() : 'status'.tr(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey.withAlpha((0.6 * 255).toInt())),
        ),
        s,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: isActive ? Colors.green.withAlpha((0.2 * 255).toInt()) : AppColors.primaryColor.withAlpha((0.2 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isActive ? 'active'.tr() : 'inactive'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: isActive ? Colors.green : AppColors.white),
          ),
        ),
      ],
    );
  }
}
