import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/cache_image.dart';
import 'package:nets/core/component/custom_load_switch_widget.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/core/utils/utils.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import '../../../../core/component/buttons/custom_text_button.dart';
import '../../../../core/component/custom_drop_down_menu.dart';
import '../../../../core/utils/constants.dart';
import '../manager/cubit/user_data_cubit.dart';
import './edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isDarkMode = false;
  bool switcher = false;
  String? selectedLanguage;
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'filters'.tr(),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
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
                          nameField: 'position'.tr(),
                          selectedItem: DropDownModel(name: 'select_position'.tr(), value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'country'.tr(),

                          selectedItem: DropDownModel(name: 'select_country'.tr(), value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'journey'.tr(),

                          selectedItem: DropDownModel(name: 'select_journey'.tr(), value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              borderColor: AppColors.transparent,
                              borderRadius: 8,
                              colorText: AppColors.black,
                              backgroundColor: AppColors.primaryColor.withOpacity(.3),
                              onPress: () {},
                              childText: 'reset_all'.tr(),
                            ),
                            CustomTextButton(
                              borderColor: AppColors.transparent,

                              borderRadius: 8,
                              colorText: AppColors.white,
                              backgroundColor: AppColors.primaryColor,
                              onPress: () {},
                              childText: 'apply_filters'.tr(),
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
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.scaffoldBackGround,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(height: 20),

              // Profile Header
              BlocBuilder<UserDataCubit, UserDataState>(
                builder: (context, state) {
                  // Format image URL - if it's a relative path, prepend base URL
                  String? imageUrl = userCacheValue?.data?.user?.profile?.image;
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
                      // If it's a relative path, prepend the domain
                      imageUrl = '${EndPoints.domain}${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor, width: 4)),
                          child:
                              imageUrl != null && imageUrl.isNotEmpty
                                  ? CacheImage(urlImage: imageUrl, circle: true, width: 88, height: 88, fit: BoxFit.cover, profileImage: true)
                                  : const CircleAvatar(
                                    radius: 56,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Icon(Icons.person, size: 45, color: Colors.white),
                                  ),
                        ),

                        const SizedBox(height: 12),

                        // User Name
                        Text(
                          userCacheValue?.data?.user?.profile?.firstName ?? 'unknown'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.white : AppColors.black),
                        ),

                        const SizedBox(height: 4),

                        // User Email
                        Text(
                          userCacheValue?.data?.user?.phone ?? 'unknown'.tr(),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            context.navigateToPage(const EditProfileView());
                          },
                          child: Text(
                            'edit_profile'.tr(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Stats Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.05),
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, 'contacts'.tr(), '156'),
                    _buildStatItem(context, 'groups'.tr(), '12'),
                    _buildStatItem(context, 'qr_scan'.tr(), '89'),
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
                  border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      isSvg: true,
                      iconPath: AppIcons.notificationSetting,
                      title: 'notifications'.tr(),
                      subtitle: 'manage_your_notifications'.tr(),
                      onTap: _showNotificationSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.qr_code_scanner,
                      title: 'phone_number_sharing'.tr(),
                      subtitle: 'control_phone_number_sharing'.tr(),
                      onTap: _showPhoneNumberSharingSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.security,
                      title: 'data_privacy'.tr(),
                      subtitle: 'manage_your_privacy_settings'.tr(),
                      onTap: _showPrivacySettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.language,
                      title: 'language'.tr(),
                      subtitle: !arabicLanguage ? 'arabic'.tr() : 'english_us'.tr(),
                      onTap: _showLanguageSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode,
                      title: 'dark_mode'.tr(),
                      subtitle: 'toggle_dark_theme'.tr(),
                      onTap: () {},
                      trailing: SizedBox(
                        width: 60.w,
                        child: CustomLoadSwitchWidget(
                          label: '',
                          initialValue: darkModeValue,
                          onChanged: ({required bool value}) {
                            log(value.toString());
                            setState(() {
                              darkModeValue = !darkModeValue;
                              saveDarkMode(context, darkModeValue);
                            });
                          },
                          future: () {
                            return Future.delayed(const Duration(seconds: 1), () => true);
                          },
                        ),
                      ),
                      /*  Switch(
                        value: switcher,
                        onChanged: (value) {
                          setState(() {
                            switcher = value;
                            saveDarkMode(context, value);
                          });
                        },
                        activeColor: AppColors.primaryColor,
                      ) */
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.help,
                      title: 'help_support'.tr(),
                      subtitle: 'get_help_and_contact_support'.tr(),
                      onTap: _showHelpSupport,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      isSvg: true,
                      iconPath: AppIcons.settings,
                      title: 'settings'.tr(),
                      subtitle: 'control_app_settings'.tr(),
                      onTap: () {
                        customShowToast(context, 'settings_coming_soon'.tr());
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.info, title: 'about'.tr(), subtitle: 'app_version'.tr(), onTap: _showAbout),
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
                    const SizedBox(width: 10),
                    Text('logout'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white)),
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
                    const SizedBox(width: 10),
                    Text('delete_account'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.red)),
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
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.white : Colors.grey[600])),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: isSvg ? SvgPicture.asset(iconPath!) : Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.white : AppColors.black),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.greyG100 : AppColors.greyG300),
      ),
      trailing: trailing ?? RotatedBox(quarterTurns: arabicLanguage ? 3 : 1, child: SvgPicture.asset(AppIcons.arrowDown)),
      onTap: onTap,
    );
  }

  Widget _buildDivider({double indent = 20}) {
    return Divider(height: 1, color: darkModeValue ? Colors.grey[700] : Colors.grey[200], indent: indent, endIndent: 20);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
          title: Text(
            'logout_button'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
          ),
          content: Text(
            'logout_confirmation_title'.tr(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.greyG100 : AppColors.greyG300),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel_button'.tr(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.greyG100 : AppColors.greyG300),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);

                userCacheValue?.data = null;
                userCache?.clear();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: Text('logout_button'.tr(), style: const TextStyle(color: Colors.white)),
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
          title: Text('delete_account'.tr(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delete_account_warning'.tr(), style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
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
                        'account_deletion_info_30_days'.tr(),
                        style: TextStyle(color: Colors.orange[800], fontSize: 12, fontWeight: FontWeight.w500),
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
              child: Text('cancel'.tr(), style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);
                userCacheValue?.data = null;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: Text('delete_account'.tr(), style: const TextStyle(color: Colors.white)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                          'notification_settings'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: darkModeValue ? Colors.black : Colors.black),
                        ),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    _buildNotificationToggle(
                      'push_notifications'.tr(),
                      'receive_push_notifications'.tr(),
                      pushNotifications,
                      (value) => setModalState(() => pushNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'email_notifications'.tr(),
                      'receive_email_notifications'.tr(),
                      emailNotifications,
                      (value) => setModalState(() => emailNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'sms_notifications'.tr(),
                      'receive_sms_notifications'.tr(),
                      smsNotifications,
                      (value) => setModalState(() => smsNotifications = value),
                    ),
                    const SizedBox(height: 20),

                    CustomTextButton(
                      onPress: () {
                        customShowToast(context, 'notification_settings_saved'.tr());
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 8,
                      borderColor: AppColors.transparent,
                      child: Text('save_settings'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                            'phone_number_sharing'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    _buildNotificationToggle(
                      'share_mobile_number'.tr(),
                      'auto_share_mobile_number_desc'.tr(),
                      pushNotifications,
                      (value) => setModalState(() => pushNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'remove_share_notification'.tr(),
                      'disable_share_phone_number_notification_desc'.tr(),
                      emailNotifications,
                      (value) => setModalState(() => emailNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'auto_sync'.tr(),
                      'auto_sync_desc'.tr(),
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

  Widget _buildNotificationToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600])),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                      'privacy_security'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w600),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                _buildPrivacyItem(Icons.lock, 'two_factor_authentication'.tr(), 'two_factor_authentication_desc'.tr()),
                _buildPrivacyItem(Icons.visibility, 'profile_visibility'.tr(), 'profile_visibility_desc'.tr()),
                _buildPrivacyItem(Icons.block, 'blocked_users'.tr(), 'blocked_users_desc'.tr()),
                _buildPrivacyItem(Icons.security, 'data_encryption'.tr(), 'data_encryption_desc'.tr()),
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
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600])),
      trailing: RotatedBox(quarterTurns: arabicLanguage ? 3 : 1, child: SvgPicture.asset(AppIcons.arrowDown)),
      onTap: () {
        customShowToast(context, '$title settings would open here');
      },
    );
  }

  void _showLanguageSettings() {
    final languages = ['English'.tr(), 'Arabic'.tr(), 'Spanish', 'French', 'German', 'Italian', 'Portuguese', 'Chinese', 'Japanese'];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'select_language'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: darkModeValue ? AppColors.black : AppColors.black),
                  ),
                ],
              ),
              _buildDivider(indent: 5),
              const SizedBox(height: 20),
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
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
                      onTap: () {
                        if (language == 'Arabic') {
                          context.setLocale(const Locale('ar', 'SA'));
                          userCache?.put(languageAppKey, true);

                          arabicLanguage = true;
                        } else {
                          context.setLocale(const Locale('en', 'US'));
                          userCache?.put(languageAppKey, false);
                        }
                        // arabicLanguage = context.locale.languageCode == 'ar';

                        setState(() {
                          selectedLanguage = language;
                        });
                        Navigator.pop(context);
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'help_support'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w600),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: darkModeValue ? Colors.black : Colors.black)),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                _buildHelpItem(AppIcons.help, 'faq'.tr(), 'faq_desc'.tr()),
                _buildHelpItem(AppIcons.message, 'live_chat'.tr(), 'live_chat_desc'.tr()),
                _buildHelpItem(AppIcons.email, 'email_support'.tr(), 'email_support_desc'.tr()),
                _buildHelpItem(AppIcons.call, 'call_support'.tr(), '+1 (555) 123-4567'),

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
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: SvgPicture.asset(icon, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600])),
      trailing: RotatedBox(quarterTurns: arabicLanguage ? 3 : 1, child: SvgPicture.asset(AppIcons.arrowDown)),
      onTap: () {
        customShowToast(context, '$title settings would open here');
      },
    );
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                      'about'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w600),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: darkModeValue ? Colors.black : Colors.black)),
                  ],
                ),
                _buildDivider(indent: 5),
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)),
                  child: SvgPicture.asset(AppIcons.appLogo),
                ),
                const SizedBox(height: 12),
                Text(
                  'NETS',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'app_version'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[600] : Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Text(
                  'app_description'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], height: 1.5),
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
                        'terms_and_conditions'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? AppColors.primaryColor : AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'privacy_policy'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? AppColors.primaryColor : AppColors.primaryColor,
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
