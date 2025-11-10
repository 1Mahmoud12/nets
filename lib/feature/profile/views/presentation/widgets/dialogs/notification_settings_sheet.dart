import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constants_models.dart';
import '../../../manager/cubit/user_data_cubit.dart';
import '../../../manager/notificationSettign/cubit/notification_setting_cubit.dart';
import '../notification_toggle_tile.dart';

class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onSmsChanged,
    required this.onSave,
    this.onError,
    required this.title,
    required this.pushLabel,
    required this.pushDescription,
    required this.emailLabel,
    required this.emailDescription,
    required this.smsLabel,
    required this.smsDescription,
    required this.saveButtonText,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onSmsChanged;
  final VoidCallback onSave;
  final ValueChanged<String>? onError;
  final String title;
  final String pushLabel;
  final String pushDescription;
  final String emailLabel;
  final String emailDescription;
  final String smsLabel;
  final String smsDescription;
  final String saveButtonText;

  @override
  State<NotificationSettingsSheet> createState() => _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  late bool pushValue;
  late bool emailValue;
  late bool smsValue;

  void _setValuesFromConstants() {
    if (!mounted) return;
    final notificationSettings = ConstantsModels.userDataModel?.data?.notificationSettings;
    final bool newPushValue = notificationSettings?.pushNotification ?? widget.pushNotifications;
    final bool newEmailValue = notificationSettings?.emailNotification ?? widget.emailNotifications;
    final bool newSmsValue = notificationSettings?.smsNotification ?? widget.smsNotifications;
    setState(() {
      pushValue = newPushValue;
      emailValue = newEmailValue;
      smsValue = newSmsValue;
    });
  }

  void _submitUpdate() {
    final cubit = context.read<NotificationSettingCubit>();
    if (cubit.state is NotificationSettingLoading) return;
    cubit.updateNotificationSettings(pushNotification: pushValue, emailNotification: emailValue, smsNotification: smsValue);
  }

  @override
  void initState() {
    super.initState();
    final notificationSettings = ConstantsModels.userDataModel?.data?.notificationSettings;
    pushValue = notificationSettings?.pushNotification ?? widget.pushNotifications;
    emailValue = notificationSettings?.emailNotification ?? widget.emailNotifications;
    smsValue = notificationSettings?.smsNotification ?? widget.smsNotifications;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDataCubit>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataCubit, UserDataState>(
      listener: (context, state) {
        if (state is UserDataSuccess) {
          _setValuesFromConstants();
        }
      },
      child: BlocConsumer<NotificationSettingCubit, NotificationSettingState>(
        listener: (context, state) {
          if (state is NotificationSettingSuccess) {
            widget.onSave();
            Navigator.pop(context);
          } else if (state is NotificationSettingError) {
            widget.onError?.call(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is NotificationSettingLoading;
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
                        widget.title,
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(color: widget.darkModeValue ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: widget.darkModeValue ? Colors.black : Colors.black),
                      ),
                    ],
                  ),
                  Divider(height: 1, color: widget.darkModeValue ? Colors.grey[700] : Colors.grey[200], indent: 5, endIndent: 5),
                  const SizedBox(height: 20),
                  NotificationToggleTile(
                    title: widget.pushLabel,
                    subtitle: widget.pushDescription,
                    value: pushValue,
                    onChanged: (value) {
                      setState(() => pushValue = value);
                      widget.onPushChanged(value);
                    },
                    isDarkMode: widget.darkModeValue,
                  ),
                  NotificationToggleTile(
                    title: widget.emailLabel,
                    subtitle: widget.emailDescription,
                    value: emailValue,
                    onChanged: (value) {
                      setState(() => emailValue = value);
                      widget.onEmailChanged(value);
                    },
                    isDarkMode: widget.darkModeValue,
                  ),
                  NotificationToggleTile(
                    title: widget.smsLabel,
                    subtitle: widget.smsDescription,
                    value: smsValue,
                    onChanged: (value) {
                      setState(() => smsValue = value);
                      widget.onSmsChanged(value);
                    },
                    isDarkMode: widget.darkModeValue,
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton(
                    onPress: isLoading ? null : _submitUpdate,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 8,
                    borderColor: AppColors.transparent,
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)),
                            )
                            : Text(widget.saveButtonText, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
