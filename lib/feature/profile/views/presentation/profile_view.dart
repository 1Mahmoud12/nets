import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/custom_load_switch_widget.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/core/utils/utils.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';

import '../../../../core/utils/utils.dart';
import './edit_profile_view.dart';

import '../../../../core/component/buttons/custom_text_button.dart';
import '../../../../core/component/custom_drop_down_menu.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isDarkMode = false;
  bool switcher = false;
  String selectedLanguage = 'English (US)';
  bool notificationsEnabled = true;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = true;
  TextEditingController search = TextEditingController();

  void showFiltersMyJourney(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filters',
                              style: Theme.of(
                                context,
                              ).textTheme.displaySmall?.copyWith(
                                color:
                                    darkModeValue
                                        ? AppColors.white
                                        : AppColors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Position',
                          selectedItem: DropDownModel(
                            name: 'Select Position',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Country',

                          selectedItem: DropDownModel(
                            name: 'Select Country',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Journey',

                          selectedItem: DropDownModel(
                            name: 'Select Journey',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              borderColor: AppColors.transparent,
                              borderRadius: 8,
                              colorText: AppColors.black,
                              backgroundColor: AppColors.primaryColor
                                  .withOpacity(.3),
                              onPress: () {},
                              childText: 'Reset All',
                            ),
                            CustomTextButton(
                              borderColor: AppColors.transparent,

                              borderRadius: 8,
                              colorText: AppColors.white,
                              backgroundColor: AppColors.primaryColor,
                              onPress: () {},
                              childText: 'Apply Filters',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(height: 20),

              // Profile Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // User Name
                    Text(
                      'Ahmed Hassan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color:
                            darkModeValue ? AppColors.white : AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // User Email
                    Text(
                      'ahmed.hassan@nets.com',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color:
                            darkModeValue ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        context.navigateToPage(const EditProfileView());
                      },
                      child: Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              darkModeValue
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        darkModeValue ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, 'Contacts', '156'),
                    _buildStatItem(context, 'Groups', '12'),
                    _buildStatItem(context, 'QR Scan', '89'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Settings Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        darkModeValue ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      isSvg: true,
                      iconPath: AppIcons.notificationSetting,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      onTap: _showNotificationSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.qr_code_scanner,
                      title: 'Phone Number Sharing',
                      subtitle: 'Control phone number sharing',
                      onTap: _showPhoneNumberSharingSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.security,
                      title: 'Privacy & Security',
                      subtitle: 'Manage your privacy settings',
                      onTap: _showPrivacySettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: selectedLanguage,
                      onTap: _showLanguageSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: 'Toggle dark theme',
                      onTap: () {},
                      trailing: Switch(
                        value: switcher,
                        onChanged: (value) {
                          setState(() {
                            switcher = value;
                            saveDarkMode(context, value);
                          });
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: _showHelpSupport,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      isSvg: true,
                      iconPath: AppIcons.settings,
                      title: 'Setting',
                      subtitle: 'Control app settings',
                      onTap: () {
                        customShowToast(context, 'settings comming soon');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'App version 1.0.0',
                      onTap: _showAbout,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Logout Button
              CustomTextButton(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                onPress: _showLogoutDialog,
                backgroundColor: Colors.red[400],
                borderRadius: 8,
                borderColor: AppColors.transparent,
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.logoutSetting),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Delete Account Button
              CustomTextButton(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                onPress: _showDeleteAccountDialog,
                backgroundColor: AppColors.transparent,
                borderRadius: 8,
                borderColor: Colors.red[600],
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.deleteSetting),
                    SizedBox(width: 10),
                    Text(
                      'Delete Account',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: AppColors.red),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    IconData? icon,
    required String title,
    String? iconPath,
    required String subtitle,
    required VoidCallback onTap,
    bool isSvg = false,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            isSvg
                ? SvgPicture.asset(iconPath!)
                : Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: isDarkMode ? AppColors.white : AppColors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing:
          trailing ??
          RotatedBox(
            quarterTurns: 3,
            child: SvgPicture.asset(AppIcons.arrowDown),
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider({double indent = 60}) {
    return Divider(
      height: 1,
      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
      indent: indent,
      endIndent: 20,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
          title: Text(
            'Logout',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);

                userCacheValue?.data = null;
                userCache?.clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
          title: Text(
            'Delete Account',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your account will be deleted after 30 days. You can recover it within this period.',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);
                userCacheValue?.data = null;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification Settings',
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(
                            color: darkModeValue ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    _buildNotificationToggle(
                      'Push Notifications',
                      'Receive push notifications',
                      pushNotifications,
                      (value) => setModalState(() => pushNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'Email Notifications',
                      'Receive email notifications',
                      emailNotifications,
                      (value) =>
                          setModalState(() => emailNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'SMS Notifications',
                      'Receive SMS notifications',
                      smsNotifications,
                      (value) => setModalState(() => smsNotifications = value),
                    ),
                    const SizedBox(height: 20),

                    CustomTextButton(
                      onPress: () {
                        customShowToast(context, 'Notification settings saved');
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 8,
                      borderColor: AppColors.transparent,
                      child: Text(
                        'Save Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPhoneNumberSharingSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Phone Number Sharing',
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              color: darkModeValue ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    _buildNotificationToggle(
                      'Share Mobile Number',
                      'Automatically share your mobile number when receiving a QR code.',
                      pushNotifications,
                      (value) => setModalState(() => pushNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'Remove Share Notification',
                      'Disable the "Share phone number" notification when sending a QR code (your number will be shared automatically).',
                      emailNotifications,
                      (value) =>
                          setModalState(() => emailNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'Auto Sync',
                      'Keep your data synchronized automatically.',
                      smsNotifications,
                      (value) => setModalState(() => smsNotifications = value),
                    ),

                    // const SizedBox(height: 20),

                    // CustomTextButton(
                    //   onPress: () {
                    //     customShowToast(context, 'Phone Number Sharing saved');
                    //   },
                    //   backgroundColor: AppColors.primaryColor,
                    //   borderRadius: 8,
                    //   borderColor: AppColors.transparent,
                    //   child: Text(
                    //     'Save Settings',
                    //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //       color: AppColors.white,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: darkModeValue ? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: SizedBox(
        width: 65,
        child: CustomLoadSwitchWidget(
          label: '',
          initialValue: value,
          onChanged: ({required bool value}) {
            onChanged(value);
          },
          future: () {
            return Future.delayed(const Duration(seconds: 1), () => true);
          },
        ),
      ),
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Privacy & Security',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkModeValue ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                _buildPrivacyItem(
                  Icons.lock,
                  'Two-Factor Authentication',
                  'Add an extra layer of security',
                ),
                _buildPrivacyItem(
                  Icons.visibility,
                  'Profile Visibility',
                  'Control who can see your profile',
                ),
                _buildPrivacyItem(
                  Icons.block,
                  'Blocked Users',
                  'Manage blocked contacts',
                ),
                _buildPrivacyItem(
                  Icons.security,
                  'Data Encryption',
                  'Your data is encrypted end-to-end',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: darkModeValue ? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: RotatedBox(
        quarterTurns: 3,
        child: SvgPicture.asset(AppIcons.arrowDown),
      ),
      onTap: () {
        customShowToast(context, '$title settings would open here');
      },
    );
  }

  void _showLanguageSettings() {
    final languages = [
      'English (US)',
      'English (UK)',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Portuguese',
      'Chinese',
      'Japanese',
      'Arabic',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: darkModeValue ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              _buildDivider(indent: 5),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = language == selectedLanguage;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        language,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                color: AppColors.primaryColor,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          selectedLanguage = language;
                        });
                        Navigator.pop(context);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Language changed to $language'),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Help & Support',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkModeValue ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: darkModeValue ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                _buildHelpItem(
                  AppIcons.help,
                  'FAQ',
                  'Frequently asked questions',
                ),
                _buildHelpItem(
                  AppIcons.message,
                  'Live Chat',
                  'Chat with our support team',
                ),
                _buildHelpItem(
                  AppIcons.email,
                  'Email Support',
                  'Send us an email',
                ),
                _buildHelpItem(
                  AppIcons.call,
                  'Call Support',
                  '+1 (555) 123-4567',
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpItem(String icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(icon, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: darkModeValue ? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: RotatedBox(
        quarterTurns: 3,
        child: SvgPicture.asset(AppIcons.arrowDown),
      ),
      onTap: () {
        customShowToast(context, '$title settings would open here');
      },
    );
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkModeValue ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: darkModeValue ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(AppIcons.appLogo),
                ),
                const SizedBox(height: 12),
                Text(
                  'NETS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: darkModeValue ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'A modern networking and communication app designed to help you stay connected with your contacts and manage your social network efficiently.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Terms of Service',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color:
                              darkModeValue
                                  ? Colors.white
                                  : AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Privacy Policy',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color:
                              darkModeValue
                                  ? Colors.white
                                  : AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
