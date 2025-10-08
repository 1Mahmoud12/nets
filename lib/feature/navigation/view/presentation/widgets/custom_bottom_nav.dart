import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> selectedIcons;
  final List<String> unselectedIcons;
  final List<String> names;
  final bool showBadge;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.selectedIcons,
    required this.names,
    required this.unselectedIcons,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 0),
      decoration: BoxDecoration(
        color: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
        border: Border(
          top: BorderSide(
            color:
                darkModeValue
                    ? Colors.transparent
                    : AppColors.cBorderButtonColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          names.length,
          (index) => _buildNavItem(
            context: context,
            index: index,
            isSelected: currentIndex == index,
            showBadge: showBadge && index == 3, // Example for campaign tab
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required bool isSelected,
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   isSelected ? selectedIcons[index] : unselectedIcons[index],
            //   color:
            //       isSelected
            //           ? AppColors.primaryColor
            //           : darkModeValue
            //           ? AppColors.darkModeColor
            //           : AppColors.black,
            //   size: 24,
            // ),
            SvgPicture.asset(
              selectedIcons[index],
              color: isSelected ? AppColors.primaryColor : AppColors.greyG300,
              width: 24,
              height: 24,
            ),
            Text(
              names[index].tr(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primaryColor : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
