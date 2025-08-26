import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.notificationPermission),
            const SizedBox(height: 36),
            Text(
              'what_is_your_location_?'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text('to_find_nearby_service_provider.'.tr(), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.cSecondaryBlack)),
            const SizedBox(height: 36),
            CustomTextButton(
              onPress: () {
                //context.navigateToPage(const AddressView());
              },
              childText: 'enter_location'.tr(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
