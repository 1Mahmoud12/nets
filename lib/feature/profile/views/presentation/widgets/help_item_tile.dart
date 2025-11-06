import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class HelpItemTile extends StatelessWidget {
  const HelpItemTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDarkMode,
    required this.isArabic,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(iconPath, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: isDarkMode ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
      ),
      trailing: RotatedBox(quarterTurns: isArabic ? 3 : 1, child: SvgPicture.asset(AppIcons.arrowDown)),
      onTap: onTap,
    );
  }
}

