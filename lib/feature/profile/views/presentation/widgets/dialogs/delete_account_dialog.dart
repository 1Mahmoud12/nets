import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.message,
    required this.warningDescription,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    required this.onCancel,
  });

  final bool isDarkMode;
  final String title;
  final String message;
  final String warningDescription;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDarkMode ? AppColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: isDarkMode ? AppColors.darkTextPrimary : Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: isDarkMode ? AppColors.darkTextSecondary : Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.orange.withOpacity(0.15) : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDarkMode ? Colors.orange.withOpacity(0.5) : Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: isDarkMode ? Colors.orange[400] : Colors.orange[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    warningDescription,
                    style: TextStyle(
                      color: isDarkMode ? Colors.orange[300] : Colors.orange[800],
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
          onPressed: onCancel,
          child: Text(
            cancelText,
            style: TextStyle(color: isDarkMode ? AppColors.darkTextSecondary : Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
          child: Text(confirmText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

