import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';

class LinkText extends StatelessWidget {
  final String mainText;
  final String linkText;
  final VoidCallback onLinkTap;

  const LinkText({super.key, required this.mainText, required this.linkText, required this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: mainText,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: darkModeValue ? AppColors.darkModeText : const Color(0xff343434),
        ),
        children: <TextSpan>[
          // Option 1: Multiple line breaks
          const TextSpan(text: '\n\n'),

          // Option 2: Using height property (uncomment to use)
          // TextSpan(
          //   text: '\n',
          //   style: TextStyle(height: 3.0), // Adjust multiplier as needed
          // ),
          TextSpan(
            text: linkText,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColor,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 25,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

// Alternative approach using Column for more control
class LinkTextColumn extends StatelessWidget {
  final String mainText;
  final String linkText;
  final VoidCallback onLinkTap;
  final double spacing;

  const LinkTextColumn({super.key, required this.mainText, required this.linkText, required this.onLinkTap, this.spacing = 12.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          mainText,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: darkModeValue ? AppColors.darkModeText : const Color(0xff343434),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing), // Precise height control
        GestureDetector(
          onTap: onLinkTap,
          child: Text(
            linkText,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColor,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 25,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
