import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/loadsErros/loading_widget.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constant_gaping.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/extensions.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/core/utils/state_app_widget.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';
import 'package:nets/feature/splash/view/manager/cubit/splash_home_cubit.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final SplashHomeCubit splashHomeCubit = SplashHomeCubit();
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await splashHomeCubit.getSplashHome(context: context);

        if (mounted) {
          if (userCacheValue?.data != null) {
            context.navigateToPage(const NavigationView());
          } else {
            if (onBoardingValue) {
              context.navigateToPage(const LoginView());
              //context.navigateToPage(const EnableNotificationView());
            } else {
              context.navigateToPage(const LoginView());
            }
          }
        }
        dataCache?.put(onBoardingKey, false);
      });
    });
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          if (mounted) {
            if (ConstantsModels.loginModel != null &&
                ConstantsModels.loginModel?.data?.authKey != null &&
                ConstantsModels.loginModel?.data?.authKey != '') {
              await splashHomeCubit.getSplashHome(context: context);
            }
            setState(() {});
          }
        },
      ),
    );
    checkedNotification = userCache?.get(checkedNotificationKey, defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.black : AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(AppIcons.appIcons, width: context.screenWidth * .5)
                .animate()
                .fade(duration: const Duration(milliseconds: 700))
                .slide(duration: const Duration(milliseconds: 800), begin: const Offset(0, 1), end: Offset.zero, curve: Curves.fastOutSlowIn)
                .scale(
                  //  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  begin: const Offset(.9, .9),
                  end: const Offset(1, 1),
                ),
          ),
          h20,
          BlocProvider.value(
            value: splashHomeCubit,
            child: BlocBuilder<SplashHomeCubit, SplashHomeState>(
              builder:
                  (context, state) =>
                      state is SplashHomeLoading ? const LoadingWidget().animate().fade(duration: const Duration(milliseconds: 700)) : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
