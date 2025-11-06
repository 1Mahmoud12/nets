import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class ProfileSettingsItem extends StatelessWidget {
  const ProfileSettingsItem({
    super.key,
    this.icon,
    required this.title,
    this.iconPath,
    required this.subtitle,
    required this.onTap,
    this.isSvg = false,
    this.trailing,
    required this.isDarkMode,
    required this.isArabic,
  });

  final IconData? icon;
  final String title;
  final String? iconPath;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSvg;
  final Widget? trailing;
  final bool isDarkMode;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: isSvg
            ? SvgPicture.asset(iconPath!)
            : Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w400, color: isDarkMode ? AppColors.white : AppColors.black),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: isDarkMode ? AppColors.greyG100 : AppColors.greyG300),
      ),
      trailing: trailing ?? RotatedBox(quarterTurns: isArabic ? 3 : 1, child: SvgPicture.asset(AppIcons.arrowDown)),
      onTap: onTap,
    );
  }
}

