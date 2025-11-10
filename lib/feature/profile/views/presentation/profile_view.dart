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
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/core/utils/utils.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import '../../../../core/component/buttons/custom_text_button.dart';
import '../../../../core/component/custom_drop_down_menu.dart';
import '../../../../core/utils/constants.dart';
import '../manager/cubit/user_data_cubit.dart';
import '../manager/getUesrStatistics/cubit/get_user_statistics_cubit.dart';
import '../manager/notificationSettign/cubit/notification_setting_cubit.dart';
import '../manager/phoneNumberSharing/cubit/phone_number_sharing_cubit.dart';
import './edit_profile_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/profile_section_divider.dart';
import 'widgets/profile_settings_item.dart';
import 'widgets/profile_stat_item.dart';
import 'widgets/dialogs/about_sheet.dart';
import 'widgets/dialogs/delete_account_dialog.dart';
import 'widgets/dialogs/filters_my_journey_sheet.dart';
import 'widgets/dialogs/help_support_sheet.dart';
import 'widgets/dialogs/language_settings_sheet.dart';
import 'widgets/dialogs/logout_dialog.dart';
import 'widgets/dialogs/notification_settings_sheet.dart';
import 'widgets/dialogs/phone_number_sharing_sheet.dart';
import 'widgets/dialogs/privacy_settings_sheet.dart';

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
  bool sharePhoneNumberValue = true;
  bool notifyMeValue = true;
  bool allUserAutoAsyncValue = false;
  TextEditingController search = TextEditingController();

  void _syncNotificationValuesFromSources() {
    if (!mounted) return;
    final modelSettings = ConstantsModels.userDataModel?.data?.notificationSettings;
    final cachedSettings = userCacheValue?.data?.user?.notificationSettings;

    final bool newPush = modelSettings?.pushNotification ?? cachedSettings?.pushNotification ?? pushNotifications;
    final bool newEmail = modelSettings?.emailNotification ?? cachedSettings?.emailNotification ?? emailNotifications;
    final bool newSms = modelSettings?.smsNotification ?? cachedSettings?.smsNotification ?? smsNotifications;

    if (newPush != pushNotifications || newEmail != emailNotifications || newSms != smsNotifications) {
      setState(() {
        pushNotifications = newPush;
        emailNotifications = newEmail;
        smsNotifications = newSms;
      });
    }
  }

  void _syncPhoneSharingValuesFromSources() {
    if (!mounted) return;
    final model = ConstantsModels.userDataModel?.data;
    final cachedUser = userCacheValue?.data?.user;

    final bool newShare = model?.sharePhoneNumber ?? cachedUser?.sharePhoneNumber ?? sharePhoneNumberValue;
    final bool newNotify = model?.notifyMe ?? cachedUser?.notifyMe ?? notifyMeValue;
    final bool newAutoSync = model?.allUserAutoAsync ?? cachedUser?.allUserAutoAsync ?? allUserAutoAsyncValue;

    if (newShare != sharePhoneNumberValue || newNotify != notifyMeValue || newAutoSync != allUserAutoAsyncValue) {
      setState(() {
        sharePhoneNumberValue = newShare;
        notifyMeValue = newNotify;
        allUserAutoAsyncValue = newAutoSync;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetUserStatisticsCubit>().getUserStatistics();
      _syncNotificationValuesFromSources();
      _syncPhoneSharingValuesFromSources();
    });
  }

  void showFiltersMyJourney(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => FiltersMyJourneySheet(
            isDarkMode: isDarkMode,
            darkModeValue: darkModeValue,
            title: 'filters'.tr(),
            positionLabel: 'position'.tr(),
            positionPlaceholder: 'select_position'.tr(),
            countryLabel: 'country'.tr(),
            countryPlaceholder: 'select_country'.tr(),
            journeyLabel: 'journey'.tr(),
            journeyPlaceholder: 'select_journey'.tr(),
            dropDownItems: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
            resetText: 'reset_all'.tr(),
            applyText: 'apply_filters'.tr(),
            onReset: () {},
            onApply: () {},
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataCubit, UserDataState>(
      listener: (context, state) {
        if (state is UserDataSuccess) {
          _syncNotificationValuesFromSources();
          _syncPhoneSharingValuesFromSources();
        }
      },
      child: Scaffold(
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

                    // Determine which phone number to show (prefer primary phone from latest user data)
                    String? displayPhone;
                    final phones = ConstantsModels.userDataModel?.data?.phones;
                    if (phones != null && phones.isNotEmpty) {
                      final primaryPhone = phones.firstWhere((phone) => phone.isPrimary == true, orElse: () => phones.first);
                      displayPhone = primaryPhone.phone;
                    }
                    displayPhone ??= userCacheValue?.data?.user?.phone;

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
                            displayPhone ?? 'unknown'.tr(),
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
                BlocBuilder<GetUserStatisticsCubit, GetUserStatisticsState>(
                  builder: (context, statsState) {
                    final isLoading = statsState is GetUserStatisticsLoading;
                    final hasError = statsState is GetUserStatisticsError;
                    final statistics = statsState is GetUserStatisticsSuccess ? statsState.statistics.data : null;

                    final contactsCount = statistics?.numContacts?.toString() ?? (hasError ? '--' : '0');
                    final groupsCount = statistics?.numGroups?.toString() ?? (hasError ? '--' : '0');
                    final qrCount = statistics?.numScanQrCode?.toString() ?? (hasError ? '--' : '0');

                    return Skeletonizer(
                      enabled: isLoading,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ProfileStatItem(label: 'contacts'.tr(), value: contactsCount, isDarkMode: darkModeValue),
                            ProfileStatItem(label: 'groups'.tr(), value: groupsCount, isDarkMode: darkModeValue),
                            ProfileStatItem(label: 'qr_scan'.tr(), value: qrCount, isDarkMode: darkModeValue),
                          ],
                        ),
                      ),
                    );
                  },
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
                      ProfileSettingsItem(
                        isSvg: true,
                        iconPath: AppIcons.notificationSetting,
                        title: 'notifications'.tr(),
                        subtitle: 'manage_your_notifications'.tr(),
                        onTap: _showNotificationSettings,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        icon: Icons.qr_code_scanner,
                        title: 'phone_number_sharing'.tr(),
                        subtitle: 'control_phone_number_sharing'.tr(),
                        onTap: _showPhoneNumberSharingSettings,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        icon: Icons.security,
                        title: 'data_privacy'.tr(),
                        subtitle: 'manage_your_privacy_settings'.tr(),
                        onTap: _showPrivacySettings,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        icon: Icons.language,
                        title: 'language'.tr(),
                        subtitle: !arabicLanguage ? 'arabic'.tr() : 'english_us'.tr(),
                        onTap: _showLanguageSettings,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
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
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        icon: Icons.help,
                        title: 'help_support'.tr(),
                        subtitle: 'get_help_and_contact_support'.tr(),
                        onTap: _showHelpSupport,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        isSvg: true,
                        iconPath: AppIcons.settings,
                        title: 'settings'.tr(),
                        subtitle: 'control_app_settings'.tr(),
                        onTap: () {
                          customShowToast(context, 'settings_coming_soon'.tr());
                        },
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
                      ),
                      ProfileSectionDivider(isDarkMode: darkModeValue),
                      ProfileSettingsItem(
                        icon: Icons.info,
                        title: 'about'.tr(),
                        subtitle: 'app_version'.tr(),
                        onTap: _showAbout,
                        isDarkMode: darkModeValue,
                        isArabic: arabicLanguage,
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
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(
          isDarkMode: isDarkMode,
          darkModeValue: darkModeValue,
          title: 'logout_button'.tr(),
          message: 'logout_confirmation_title'.tr(),
          cancelText: 'cancel_button'.tr(),
          confirmText: 'logout_button'.tr(),
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            await userCache?.put(userCacheKey, null);
            userCacheValue?.data = null;
            userCache?.clear();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog(
          isDarkMode: isDarkMode,
          title: 'delete_account'.tr(),
          message: 'delete_account_warning'.tr(),
          warningDescription: 'account_deletion_info_30_days'.tr(),
          cancelText: 'cancel'.tr(),
          confirmText: 'delete_account'.tr(),
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            await userCache?.put(userCacheKey, null);
            userCacheValue?.data = null;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
          },
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
        return BlocProvider(
          create: (_) => NotificationSettingCubit(),
          child: NotificationSettingsSheet(
            isDarkMode: isDarkMode,
            darkModeValue: darkModeValue,
            pushNotifications: pushNotifications,
            emailNotifications: emailNotifications,
            smsNotifications: smsNotifications,
            onPushChanged: (value) => setState(() => pushNotifications = value),
            onEmailChanged: (value) => setState(() => emailNotifications = value),
            onSmsChanged: (value) => setState(() => smsNotifications = value),
            onSave: () {
              customShowToast(context, 'notification_settings_saved'.tr());
            },
            onError: (message) {
              customShowToast(context, message, showToastStatus: ShowToastStatus.error);
            },
            title: 'notification_settings'.tr(),
            pushLabel: 'push_notifications'.tr(),
            pushDescription: 'receive_push_notifications'.tr(),
            emailLabel: 'email_notifications'.tr(),
            emailDescription: 'receive_email_notifications'.tr(),
            smsLabel: 'sms_notifications'.tr(),
            smsDescription: 'receive_sms_notifications'.tr(),
            saveButtonText: 'save_settings'.tr(),
          ),
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
        return BlocProvider(
          create: (_) => PhoneNumberSharingCubit(),
          child: PhoneNumberSharingSheet(
            isDarkMode: isDarkMode,
            darkModeValue: darkModeValue,
            shareMobile: sharePhoneNumberValue,
            removeShareNotification: notifyMeValue,
            autoSync: allUserAutoAsyncValue,
            onShareMobileChanged: (value) => setState(() => sharePhoneNumberValue = value),
            onRemoveShareNotificationChanged: (value) => setState(() => notifyMeValue = value),
            onAutoSyncChanged: (value) => setState(() => allUserAutoAsyncValue = value),
            onSave: () {
              //  customShowToast(context, 'notification_settings_saved'.tr());
            },
            onError: (message) {
              //  customShowToast(context, message, showToastStatus: ShowToastStatus.error);
            },
            title: 'phone_number_sharing'.tr(),
            shareMobileLabel: 'share_mobile_number'.tr(),
            shareMobileDescription: 'auto_share_mobile_number_desc'.tr(),
            removeShareLabel: 'remove_share_notification'.tr(),
            removeShareDescription: 'disable_share_phone_number_notification_desc'.tr(),
            autoSyncLabel: 'auto_sync'.tr(),
            autoSyncDescription: 'auto_sync_desc'.tr(),
            saveButtonText: 'save_settings'.tr(),
          ),
        );
      },
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return PrivacySettingsSheet(
          isDarkMode: isDarkMode,
          darkModeValue: darkModeValue,
          isArabic: arabicLanguage,
          title: 'privacy_security'.tr(),
          items: [
            PrivacyItemData(
              icon: Icons.lock,
              title: 'two_factor_authentication'.tr(),
              subtitle: 'two_factor_authentication_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'two_factor_authentication'.tr()} settings would open here');
              },
            ),
            PrivacyItemData(
              icon: Icons.visibility,
              title: 'profile_visibility'.tr(),
              subtitle: 'profile_visibility_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'profile_visibility'.tr()} settings would open here');
              },
            ),
            PrivacyItemData(
              icon: Icons.block,
              title: 'blocked_users'.tr(),
              subtitle: 'blocked_users_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'blocked_users'.tr()} settings would open here');
              },
            ),
            PrivacyItemData(
              icon: Icons.security,
              title: 'data_encryption'.tr(),
              subtitle: 'data_encryption_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'data_encryption'.tr()} settings would open here');
              },
            ),
          ],
        );
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
        return LanguageSettingsSheet(
          isDarkMode: isDarkMode,
          darkModeValue: darkModeValue,
          languages: languages,
          selectedLanguage: selectedLanguage,
          title: 'select_language'.tr(),
          onLanguageSelected: (language) {
            if (language == 'Arabic') {
              context.setLocale(const Locale('ar', 'SA'));
              userCache?.put(languageAppKey, true);
              arabicLanguage = true;
            } else {
              context.setLocale(const Locale('en', 'US'));
              userCache?.put(languageAppKey, false);
              arabicLanguage = false;
            }
            setState(() {
              selectedLanguage = language;
            });
            Navigator.pop(context);
          },
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
        return HelpSupportSheet(
          isDarkMode: isDarkMode,
          darkModeValue: darkModeValue,
          isArabic: arabicLanguage,
          title: 'help_support'.tr(),
          items: [
            HelpItemData(
              iconPath: AppIcons.help,
              title: 'faq'.tr(),
              subtitle: 'faq_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'faq'.tr()} settings would open here');
              },
            ),
            HelpItemData(
              iconPath: AppIcons.message,
              title: 'live_chat'.tr(),
              subtitle: 'live_chat_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'live_chat'.tr()} settings would open here');
              },
            ),
            HelpItemData(
              iconPath: AppIcons.email,
              title: 'email_support'.tr(),
              subtitle: 'email_support_desc'.tr(),
              onTap: () {
                customShowToast(context, '${'email_support'.tr()} settings would open here');
              },
            ),
            HelpItemData(
              iconPath: AppIcons.call,
              title: 'call_support'.tr(),
              subtitle: '+1 (555) 123-4567',
              onTap: () {
                customShowToast(context, '${'call_support'.tr()} settings would open here');
              },
            ),
          ],
        );
      },
    );
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return AboutSheet(
          isDarkMode: isDarkMode,
          darkModeValue: darkModeValue,
          title: 'about'.tr(),
          appName: 'NETS',
          versionText: 'app_version'.tr(),
          description: 'app_description'.tr(),
          termsText: 'terms_and_conditions'.tr(),
          privacyText: 'privacy_policy'.tr(),
          onTermsTap: () {
            customShowToast(context, 'settings_coming_soon'.tr());
          },
          onPrivacyTap: () {
            customShowToast(context, 'settings_coming_soon'.tr());
          },
        );
      },
    );
  }
}
