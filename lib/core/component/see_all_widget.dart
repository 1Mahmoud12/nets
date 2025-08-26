import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class SeeAllWidget extends StatelessWidget {
  const SeeAllWidget({super.key, required this.title, this.onTap, this.padding, this.showSeeAll = true, this.textStyle});

  final String title;
  final bool showSeeAll;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr(), style: textStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
          if (showSeeAll)
            InkWell(
              onTap: onTap,
              child: Text('view_all'.tr(), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.greyG600)),
            ),
        ],
      ),
    );
  }
}
