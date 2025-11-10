import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constants_models.dart';

import '../../../manager/cubit/user_data_cubit.dart';
import '../../../manager/phoneNumberSharing/cubit/phone_number_sharing_cubit.dart';
import '../notification_toggle_tile.dart';

class PhoneNumberSharingSheet extends StatefulWidget {
  const PhoneNumberSharingSheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.shareMobile,
    required this.removeShareNotification,
    required this.autoSync,
    required this.onShareMobileChanged,
    required this.onRemoveShareNotificationChanged,
    required this.onAutoSyncChanged,
    required this.onSave,
    this.onError,
    required this.title,
    required this.shareMobileLabel,
    required this.shareMobileDescription,
    required this.removeShareLabel,
    required this.removeShareDescription,
    required this.autoSyncLabel,
    required this.autoSyncDescription,
    required this.saveButtonText,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final bool shareMobile;
  final bool removeShareNotification;
  final bool autoSync;
  final ValueChanged<bool> onShareMobileChanged;
  final ValueChanged<bool> onRemoveShareNotificationChanged;
  final ValueChanged<bool> onAutoSyncChanged;
  final VoidCallback onSave;
  final ValueChanged<String>? onError;
  final String title;
  final String shareMobileLabel;
  final String shareMobileDescription;
  final String removeShareLabel;
  final String removeShareDescription;
  final String autoSyncLabel;
  final String autoSyncDescription;
  final String saveButtonText;

  @override
  State<PhoneNumberSharingSheet> createState() => _PhoneNumberSharingSheetState();
}

class _PhoneNumberSharingSheetState extends State<PhoneNumberSharingSheet> {
  late bool shareMobileValue;
  late bool removeShareValue;
  late bool autoSyncValue;

  void _setValuesFromConstants() {
    if (!mounted) return;
    final userData = ConstantsModels.userDataModel?.data;
    final bool newShareValue = userData?.sharePhoneNumber ?? widget.shareMobile;
    final bool newNotifyValue = userData?.notifyMe ?? widget.removeShareNotification;
    final bool newAutoSyncValue = userData?.allUserAutoAsync ?? widget.autoSync;
    setState(() {
      shareMobileValue = newShareValue;
      removeShareValue = newNotifyValue;
      autoSyncValue = newAutoSyncValue;
    });
  }

  void _submitUpdate() {
    final cubit = context.read<PhoneNumberSharingCubit>();
    if (cubit.state is PhoneNumberSharingLoading) return;
    cubit.updatePhoneNumberSharing(
      sharePhoneNumber: shareMobileValue,
      notifyMe: removeShareValue,
      allUserAutoAsync: autoSyncValue,
    );
  }

  @override
  void initState() {
    super.initState();
    final userData = ConstantsModels.userDataModel?.data;
    shareMobileValue = userData?.sharePhoneNumber ?? widget.shareMobile;
    removeShareValue = userData?.notifyMe ?? widget.removeShareNotification;
    autoSyncValue = userData?.allUserAutoAsync ?? widget.autoSync;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
      child: BlocConsumer<PhoneNumberSharingCubit, PhoneNumberSharingState>(
        listener: (context, state) {
          if (state is PhoneNumberSharingSuccess) {
            widget.onSave();
            Navigator.pop(context);
          } else if (state is PhoneNumberSharingError) {
            widget.onError?.call(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is PhoneNumberSharingLoading;
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
                          widget.title,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: widget.darkModeValue ? Colors.black : Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: widget.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: widget.darkModeValue ? Colors.grey[700] : Colors.grey[200],
                    indent: 5,
                    endIndent: 5,
                  ),
                  const SizedBox(height: 20),
                  NotificationToggleTile(
                    title: widget.shareMobileLabel,
                    subtitle: widget.shareMobileDescription,
                    value: shareMobileValue,
                    onChanged: (value) {
                      setState(() => shareMobileValue = value);
                      widget.onShareMobileChanged(value);
                    },
                    isDarkMode: widget.darkModeValue,
                  ),
                  NotificationToggleTile(
                    title: widget.removeShareLabel,
                    subtitle: widget.removeShareDescription,
                    value: removeShareValue,
                    onChanged: (value) {
                      setState(() => removeShareValue = value);
                      widget.onRemoveShareNotificationChanged(value);
                    },
                    isDarkMode: widget.darkModeValue,
                  ),
                  NotificationToggleTile(
                    title: widget.autoSyncLabel,
                    subtitle: widget.autoSyncDescription,
                    value: autoSyncValue,
                    onChanged: (value) {
                      setState(() => autoSyncValue = value);
                      widget.onAutoSyncChanged(value);
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

