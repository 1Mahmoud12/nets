import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/feature/Contacts/contacts_view.dart';
import 'package:nets/feature/QrCode/qr_view.dart';
import 'package:nets/feature/navigation/data/homeDataSource/home_data_source.dart';
import 'package:nets/feature/navigation/view/presentation/widgets/custom_bottom_nav.dart';
import 'package:nets/feature/profile/profile_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavigationView extends StatefulWidget {
  final int customIndex;
  const NavigationView({super.key, this.customIndex = 0});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView>
    with TickerProviderStateMixin {
  int index = 0;
  late AnimationController _animationController;
  late AnimationController _notificationController;
  late Animation<double> _notificationAnimation;
  final Set<int> _loadedScreens = {};

  @override
  void initState() {
    super.initState();
    index = widget.customIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _notificationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _notificationAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _notificationController, curve: Curves.easeInOut),
    );
    HomeDataSourceImplementation().updateDeviceToken();

    _loadedScreens.add(index);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  // final selectedIcons = [PhosphorIcons.house(), PhosphorIcons.addressBook(), PhosphorIcons.user()];
  final selectedIcons = [
    AppIcons.homeSel,
    AppIcons.contactSel,
    AppIcons.journeySel,
    AppIcons.profileSel,
  ];
  final unselectedIcons = [
   AppIcons.home,
    AppIcons.contact,
    AppIcons.journey,
    AppIcons.profile,
  ];
  final names = ['Home', 'Contacts', 'My journey', 'Profile'];

  // Get current time greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
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
        return const ProfileView();
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
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Mark all read',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              darkModeValue
                                  ? AppColors.appBarDarkModeColor
                                  : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                darkModeValue
                                    ? Colors.grey[700]!
                                    : Colors.grey[200]!,
                          ),
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
                                    'New message received',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          darkModeValue
                                              ? AppColors.white
                                              : AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You have a new message from Sarah Johnson',
                                    style: TextStyle(
                                      color:
                                          darkModeValue
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '2 min ago',
                                    style: TextStyle(
                                      color:
                                          darkModeValue
                                              ? Colors.grey[500]
                                              : Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
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

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            PhosphorIcons.gear(),
                            color: AppColors.primaryColor,
                          ),
                        ),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            color:
                                darkModeValue
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            PhosphorIcons.question(),
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          'Help & Support',
                          style: TextStyle(
                            color:
                                darkModeValue
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            PhosphorIcons.signOut(),
                            color: Colors.red,
                          ),
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
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
        customShowToast(
          context,
          'swipe_again_to_exit_app'.tr(),
          showToastStatus: ShowToastStatus.warning,
        );
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
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              color:
                  darkModeValue
                      ? AppColors.appBarDarkModeColor
                      : AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Profile avatar with menu
                    GestureDetector(
                      onTap: _showProfileMenu,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryColor,
                          child: Text(
                            'AH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Logo and app name
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         AppColors.primaryColor,
                    //         AppColors.primaryColor.withOpacity(0.8),
                    //       ],
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //     ),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Icon(
                    //     PhosphorIcons.network(),
                    //     color: Colors.white,
                    //     size: 24,
                    //   ),
                    // ),
                    const SizedBox(width: 12),

                    // Greeting and user name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getGreeting(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  darkModeValue
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ahmed Hassan',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  darkModeValue
                                      ? AppColors.white
                                      : AppColors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Notifications button with animation
                    GestureDetector(
                      onTap: _showNotifications,
                      child: AnimatedBuilder(
                        animation: _notificationAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _notificationAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    darkModeValue
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Icon(
                                    PhosphorIcons.bell(),
                                    color:
                                        darkModeValue
                                            ? AppColors.white
                                            : AppColors.black,
                                    size: 24,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              darkModeValue
                                                  ? AppColors
                                                      .appBarDarkModeColor
                                                  : AppColors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: const Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
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
                (darkModeValue
                    ? AppColors.appBarDarkModeColor
                    : AppColors.white),
                (darkModeValue
                        ? AppColors.appBarDarkModeColor
                        : AppColors.white)
                    .withOpacity(0.95),
              ],
            ),
          ),
          child: IndexedStack(
            index: index,
            children: List.generate(4, (index) => _buildScreen(index)),
          ),
        ),

        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      darkModeValue
                          ? AppColors.appBarDarkModeColor
                          : AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
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
