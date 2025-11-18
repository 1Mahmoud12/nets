import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    required this.onCancel,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkModeValue ? AppColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: darkModeValue ? AppColors.darkTextPrimary : Colors.black,
        ),
      ),
      content: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.darkTextSecondary : Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelText,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: darkModeValue ? AppColors.darkTextSecondary : Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
          child: Text(confirmText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
