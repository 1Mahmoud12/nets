import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/extensions.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: context.screenWidth, height: 8, color: AppColors.cBorderButtonColor);
  }
}
