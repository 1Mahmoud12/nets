import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/versionAndUpdateApp/alert_dialog_for_update_app.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/Contacts/views/presentation/contacts_view.dart';
import 'package:nets/feature/QrCode/qr_view.dart';
import 'package:nets/feature/navigation/data/homeDataSource/home_data_source.dart';
import 'package:nets/feature/navigation/view/presentation/widgets/custom_bottom_nav.dart';
import 'package:nets/feature/profile/views/manager/cubit/user_data_cubit.dart';
import 'package:nets/feature/profile/views/presentation/profile_view.dart';

import '../../../my_journey/views/presentation/my_journey_view.dart';

class NavigationView extends StatefulWidget {
  final int customIndex;
  const NavigationView({super.key, this.customIndex = 0});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> with TickerProviderStateMixin {
  int index = 0;
  late AnimationController _animationController;
  late AnimationController _notificationController;
  late Animation<double> _notificationAnimation;
  final Set<int> _loadedScreens = {};

  @override
  void initState() {
    super.initState();
    index = widget.customIndex;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _notificationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);

    _notificationAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _notificationController, curve: Curves.easeInOut));
    HomeDataSourceImplementation().updateDeviceToken();

    _loadedScreens.add(index);
    checkVersion(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ConstantsModels.userDataModel?.data == null) {
        context.read<UserDataCubit>().getUserData();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  // final selectedIcons = [PhosphorIcons.house(), PhosphorIcons.addressBook(), PhosphorIcons.user()];
  final selectedIcons = [AppIcons.homeSel, AppIcons.contactSel, AppIcons.journeySel, AppIcons.profileSel];
  final unselectedIcons = [AppIcons.home, AppIcons.contact, AppIcons.journey, AppIcons.profile];
  final names = ['home', 'contacts', 'my_journey', 'profile'];

  // Get current time greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good_morning'.tr();
    } else if (hour < 17) {
      return 'good_afternoon'.tr();
    } else {
      return 'good_evening'.tr();
    }
  }

  Widget _buildScreen(int screenIndex) {
    if (!_loadedScreens.contains(screenIndex)) {
      return const SizedBox.shrink();
    }

    switch (screenIndex) {
      case 0:
        return const QrView();
      case 1:
        return const ContactsView();
      case 2:
        return const MyJourneyView();
      case 3:
        return const ProfileView();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int newIndex, BuildContext context) {
    if (newIndex != index) {
      setState(() {
        index = newIndex;
        _loadedScreens.add(newIndex);
      });
    }
  }

  void notRequireSignIn(int newIndex) {
    if (newIndex != index) {
      setState(() {
        index = newIndex;
        _loadedScreens.add(newIndex);
      });
      _animationController.forward(from: 0);
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Container(
                //   width: 40,
                //   height: 4,
                //   margin: const EdgeInsets.symmetric(vertical: 12),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[400],
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                // ),
                Row(
                  children: [
                    Text(
                      'notifications'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.white : AppColors.black),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'mark_all_read'.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(color: darkModeValue ? AppColors.white : AppColors.primaryColor.withBlue(150)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.greyG200),
                        ),
                        child: Row(
                          children: [
                            // const CircleAvatar(
                            //   radius: 20,
                            //   backgroundColor: AppColors.primaryColor,
                            //   child: Icon(PhosphorIcons.chatCircle(), color: Colors.white, size: 20),
                            // ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'new_message_received'.tr(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: darkModeValue ? AppColors.white : AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'new_message_from'.tr(args: ['Sarah Johnson']),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.cSecondaryBlack),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '2 min ago',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.cSecondaryBlack),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  final List<GlobalKey> itemKeys = List.generate(3, (_) => GlobalKey());
  int exitApp = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exitApp++;
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(color: AppColors.greyG100)),
              color: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: BlocBuilder<UserDataCubit, UserDataState>(
                  builder: (context, state) {
                    final firstName = userCacheValue?.data?.user?.profile?.firstName ?? '';
                    final initials = firstName.length >= 2 ? firstName.substring(0, 2).toUpperCase() : 'UK';
                    return Row(
                      children: [
                        // Profile avatar with menu
                        GestureDetector(
                          // onTap: _showProfileMenu,
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor, width: 2)),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                initials,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Greeting and user name
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: Theme.of(context).textTheme.displayMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userCacheValue?.data?.user?.profile?.firstName ?? 'unknown'.tr(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: darkModeValue ? AppColors.white : AppColors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                              // const Spacer(),
                              // Status indicator
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white),
                (darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white).withOpacity(0.95),
              ],
            ),
          ),
          child: IndexedStack(index: index, children: List.generate(4, (index) => _buildScreen(index))),
        ),

        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  // color:
                  //     darkModeValue
                  //         ? AppColors.appBarDarkModeColor
                  //         : AppColors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.1),
                  //     blurRadius: 10,
                  //     offset: const Offset(0, -2),
                  //   ),
                  // ],
                ),
                child: CustomBottomNavigationBar(
                  currentIndex: index,
                  onTap: (value) => _onItemTapped(value, context),
                  selectedIcons: selectedIcons,
                  unselectedIcons: unselectedIcons,
                  names: names,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
