import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';
import 'package:nets/core/utils/extensions.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

class SuccessfullyView extends StatelessWidget {
  final bool homeView;

  const SuccessfullyView({super.key, this.homeView = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: darkModeValue ? AppColors.black : AppColors.white,

        appBar: customAppBar(context: context, title: 'reset_password'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(AppImages.sendOtpImage),
                Text(
                  'password_changed_success'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 20.sp),
                ),
                Text(
                  'password_changed_message.'.tr(),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: darkModeValue ? AppColors.darkModeText : AppColors.cP50,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                CustomTextButton(
                  backgroundColor: AppColors.primaryColor,
                  colorText: Colors.white,
                  borderColor: AppColors.primaryColor,
                  borderRadius: 4,
                  onPress: () {
                    if (homeView) {
                      context.navigateToPage(const NavigationView());
                    } else {
                      context.navigateToPage(const LoginView());
                    }
                  },
                  childText: homeView ? 'go_to_home'.tr() : 'login'.tr(),
                ),
              ].paddingDirectional(top: 24),
            ),
          ),
        ),
      ),
    );
  }
}
