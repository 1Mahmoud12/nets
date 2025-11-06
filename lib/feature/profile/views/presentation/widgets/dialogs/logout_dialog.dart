import 'package:flutter/material.dart';

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
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: darkModeValue ? Colors.white : Colors.black),
      ),
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: darkModeValue ? Colors.grey[100] : Colors.grey[300]),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelText,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: darkModeValue ? Colors.grey[100] : Colors.grey[300]),
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

