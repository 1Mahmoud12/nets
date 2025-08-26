import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/themes/colors.dart';

import '../utils/app_icons.dart';
import '../utils/constant_gaping.dart';

/// A reusable confirmation dialog for delete operations that handles loading state

class ConfirmationDeleteDialog extends StatefulWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool initialLoadingState;
  final Stream<dynamic>? stateStream;
  final bool Function(dynamic state)? loadingStateCheck;

  const ConfirmationDeleteDialog({
    Key? key,
    this.title = 'Confirm Deletion',
    this.message = 'Are you sure you want to delete this item?',
    this.cancelText = 'Cancel',
    this.confirmText = 'Delete',
    required this.onConfirm,
    this.onCancel,
    this.initialLoadingState = false,
    this.stateStream,
    this.loadingStateCheck,
  }) : super(key: key);

  /// Static method to easily show the dialog
  static Future<bool?> show({
    required BuildContext context,
    String title = 'confirm_deletion',
    String message = 'are_you_sure_you_want_to_delete_this_item',
    String cancelText = 'no',
    String confirmText = 'yes',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
    Stream<dynamic>? stateStream,
    bool Function(dynamic state)? loadingStateCheck,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (BuildContext context) => ConfirmationDeleteDialog(
        title: title.tr(),
        message: message.tr(),
        cancelText: cancelText.tr(),
        confirmText: confirmText.tr(),
        onConfirm: onConfirm,
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        initialLoadingState: isLoading,
        stateStream: stateStream,
        loadingStateCheck: loadingStateCheck,
      ),
    );
  }

  @override
  State<ConfirmationDeleteDialog> createState() => _ConfirmationDeleteDialogState();
}

class _ConfirmationDeleteDialogState extends State<ConfirmationDeleteDialog> {
  late bool isLoading;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    isLoading = widget.initialLoadingState;

    // Listen to the state stream if provided
    if (widget.stateStream != null && widget.loadingStateCheck != null) {
      _subscription = widget.stateStream!.listen((state) {
        final newLoadingState = widget.loadingStateCheck!(state);
        if (newLoadingState != isLoading) {
          setState(() {
            isLoading = newLoadingState;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button dismissal during loading
      onWillPop: () async => !isLoading,
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h16,
            SvgPicture.asset(AppIcons.appLogo),
            h15,
            Text(widget.title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            h20,
            Text(widget.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        actions: [
          // Cancel button (disabled during loading)
          InkWell(
            onTap: isLoading ? null : (widget.onCancel ?? () => Navigator.of(context).pop(false)),
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 38, left: 38, bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.cDeleteNoColor),
              child: /* isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : */ Text(
                widget.cancelText,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.cProductCategoryColor, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          w10,

          InkWell(
            onTap: isLoading ? null : widget.onConfirm,
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 36, left: 36, bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.cProductPriceColor),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Text(
                      widget.confirmText,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
