import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class ProfileStatItem extends StatelessWidget {
  const ProfileStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  final String label;
  final String value;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: isDarkMode ? AppColors.white : Colors.grey[600]),
        ),
      ],
    );
  }
}

