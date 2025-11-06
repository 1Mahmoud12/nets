import 'package:flutter/material.dart';

class ProfileSectionDivider extends StatelessWidget {
  const ProfileSectionDivider({super.key, this.indent = 20, required this.isDarkMode});

  final double indent;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
      indent: indent,
      endIndent: 20,
    );
  }
}

