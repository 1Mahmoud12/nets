import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class AboutSheet extends StatelessWidget {
  const AboutSheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.title,
    required this.appName,
    required this.versionText,
    required this.description,
    required this.termsText,
    required this.privacyText,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final String title;
  final String appName;
  final String versionText;
  final String description;
  final String termsText;
  final String privacyText;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkModeValue ? Colors.black : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: darkModeValue ? Colors.black : Colors.black),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: darkModeValue ? Colors.grey[700] : Colors.grey[200],
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)),
              child: SvgPicture.asset(AppIcons.appLogo),
            ),
            const SizedBox(height: 12),
            Text(
              appName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              versionText,
              style:
                  Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[600] : Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    onTermsTap();
                    Navigator.pop(context);
                  },
                  child: Text(
                    termsText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? AppColors.primaryColor : AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onPrivacyTap();
                    Navigator.pop(context);
                  },
                  child: Text(
                    privacyText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? AppColors.primaryColor : AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

