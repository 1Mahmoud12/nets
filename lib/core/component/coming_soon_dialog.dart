import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        color: Colors.black.withAlpha((0.4 * 255).toInt()),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 280.w),
            child: Card(
              color: darkModeValue ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 12,
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header stripe
                  Container(height: 6.h, color: AppColors.primaryColor, width: double.infinity),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                    child: Column(
                      children: [
                        Image.asset(AppImages.smallAppLogo),

                        SizedBox(height: 20.h),
                        Text(
                          'coming_soon'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'this_feature_is_under_development_and_will_be_available_shortly'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.sp, height: 1.5, color: darkModeValue ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
