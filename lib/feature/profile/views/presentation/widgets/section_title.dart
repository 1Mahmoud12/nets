import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.isDarkMode = false,
  });

  final String title;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
    );
  }
}

