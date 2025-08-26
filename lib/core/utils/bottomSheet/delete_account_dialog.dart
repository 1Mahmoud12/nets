import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';
import 'package:nets/core/utils/extensions.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';

Future<void> deleteAccountDialog({required BuildContext context, required void Function()? onPress}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => SpringAnimationDialog(
          dialog: AlertDialog(
            title: Image.asset(AppImages.deleteAccount, fit: BoxFit.contain, width: 90, height: 140),
            content: Text(
              'are_you_sure_you_want_to_delete_your_account?'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      backgroundColor: AppColors.transparent,
                      colorText: AppColors.cP50,
                      borderColor: AppColors.cP50,
                      onPress: () {
                        Navigator.pop(context);
                        //  onPress?.call();
                        //   context.navigateToPage(const NavigationView());
                      },
                      childText: 'move_back'.tr(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextButton(
                      backgroundColor: AppColors.white,
                      colorText: AppColors.cError300,
                      borderColor: AppColors.cError300,
                      onPress: () {
                        userCacheValue = null;
                        userCache?.clear();
                        Navigator.pop(context);
                        onPress?.call();
                        context.navigateToPage(const LoginView());
                      },
                      childText: 'delete',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) /*.animate().slide(
                begin: const Offset(0, 1), // Start off-screen
                end: Offset.zero, // Move to the final position
                curve: Curves.bounceIn, // Smooth entry
                duration: const Duration(milliseconds: 2000), // Adjust entry duration
              )*/
      /*.animate(delay: const Duration(milliseconds: 400))
          .slide(
            begin: Offset.zero, // Start at the final position
            end: const Offset(0, 0.01), // Slight upward bounce
            curve: Curves.easeOut, // Smooth deceleration
            duration: const Duration(milliseconds: 400), // Short bounce duration
          )
          .animate(delay: const Duration(milliseconds: 800))
          .slide(
            begin: const Offset(0, 0.01), // Slight upward bounce
            end: Offset.zero, // Start at the final position
            curve: Curves.easeOut, // Smooth deceleration
            duration: const Duration(milliseconds: 400), // Short bounce duration
          )*/
      ;
    },
  );
}

class SpringAnimationDialog extends StatefulWidget {
  final void Function()? onPress;
  final Widget dialog;

  const SpringAnimationDialog({super.key, this.onPress, required this.dialog});

  @override
  State<SpringAnimationDialog> createState() => _SpringAnimationDialogState();
}

class _SpringAnimationDialogState extends State<SpringAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late SpringSimulation springSimulation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, upperBound: double.infinity);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      springSimulation = SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 300, damping: 20),
        context.screenHeight,
        context.screenHeight / 2,
        0,
      );
      animationController.animateWith(springSimulation);
    });
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(offset: Offset(0, animationController.value - (MediaQuery.of(context).size.height / 2)), child: widget.dialog);
      },
    );
  }
}
