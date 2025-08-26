import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/feature/navigation/view/presentation/widgets/custom_bottom_nav.dart';

class NavigationView extends StatefulWidget {
  final int customIndex;
  const NavigationView({super.key, this.customIndex = 0});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController _animationController;
  final Set<int> _loadedScreens = {};

  @override
  void initState() {
    super.initState();
    index = widget.customIndex;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _loadedScreens.add(index);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final selectedIcons = [
    AppIcons.selectedhHomeIc,
    AppIcons.selectedProgram,
    AppIcons.selectedWatch,
    AppIcons.selectedDiscover,
    AppIcons.selectedNotification,
  ];

  final unselectedIcons = [
    AppIcons.unSelectedhHomeIc,
    AppIcons.unSelectedProgram,
    AppIcons.unSelectedWatch,
    AppIcons.unSelectedDiscover,
    AppIcons.unSelectedNotification,
  ];

  final names = ['Home', 'Programs', 'Watch', 'Discover', 'alerts'];

  Widget _buildScreen(int screenIndex) {
    if (!_loadedScreens.contains(screenIndex)) {
      return const SizedBox.shrink();
    }

    switch (screenIndex) {
      case 0:
        return const SizedBox();
      case 1:
        return const SizedBox();
      case 2:
        // Create new LiveView instance only when needed and visible
        if (index == 2) {
          return const SizedBox();
        } else {
          // Dispose of LiveView when not visible
          return const SizedBox();
        }
      case 3:
        return const SizedBox();
      case 4:
        return const SizedBox();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int newIndex, BuildContext context) {
    if (newIndex == 4 && Constants.token == '') {
      //  newIndex = 0;
      // OptionDialog.show(
      //   icon: AppIcons.logout,
      //   context: context,
      //   title: 'login_required_to_access_this_feature',
      //   optionOneText: 'login',
      //   optionTwoText: 'cancel_button',
      //
      //   onTapOne: () async {
      //     if (context.mounted) context.navigateToPage(const OnboardingScreen());
      //   },
      //   onTapTwo: () {},
      // );
    } else {
      if (newIndex != index) {
        final oldIndex = index;
        setState(() {
          index = newIndex;
          _loadedScreens.add(newIndex);

          // If navigating away from LiveView, dispose it
          if (oldIndex == 2 && newIndex != 2) {
            // _liveViewInstance = null;
          }
        });
      }
    }
  }

  void notRequireSignIn(int newIndex) {
    if (newIndex != index) {
      final oldIndex = index;
      setState(() {
        index = newIndex;
        _loadedScreens.add(newIndex);

        // If navigating away from LiveView, dispose it
        if (oldIndex == 2 && newIndex != 2) {
          //  _liveViewInstance = null;
        }
      });
      _animationController.forward(from: 0);
    }
  }

  final List<GlobalKey> itemKeys = List.generate(5, (_) => GlobalKey());
  int exitApp = 0;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exitApp++;
        //Utils.showToast(title: 'swipe twice to exit', state: UtilState.success);
        customShowToast(context, 'swipe_again_to_exit_app'.tr(), showToastStatus: ShowToastStatus.warning);
        Future.delayed(const Duration(seconds: 5), () {
          exitApp = 0;
          setState(() {});
        });
        if (exitApp == 2) {
          exit(0);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(index: index, children: List.generate(5, (index) => _buildScreen(index))),
        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
              child: CustomBottomNavigationBar(
                currentIndex: index,
                onTap: (value) => _onItemTapped(value, context),
                selectedIcons: selectedIcons,
                unselectedIcons: unselectedIcons,
                names: names,
                showBadge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
