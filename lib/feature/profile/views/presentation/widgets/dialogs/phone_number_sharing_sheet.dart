import 'package:flutter/material.dart';
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
    required this.title,
    required this.shareMobileLabel,
    required this.shareMobileDescription,
    required this.removeShareLabel,
    required this.removeShareDescription,
    required this.autoSyncLabel,
    required this.autoSyncDescription,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final bool shareMobile;
  final bool removeShareNotification;
  final bool autoSync;
  final ValueChanged<bool> onShareMobileChanged;
  final ValueChanged<bool> onRemoveShareNotificationChanged;
  final ValueChanged<bool> onAutoSyncChanged;
  final String title;
  final String shareMobileLabel;
  final String shareMobileDescription;
  final String removeShareLabel;
  final String removeShareDescription;
  final String autoSyncLabel;
  final String autoSyncDescription;

  @override
  State<PhoneNumberSharingSheet> createState() => _PhoneNumberSharingSheetState();
}

class _PhoneNumberSharingSheetState extends State<PhoneNumberSharingSheet> {
  late bool shareMobileValue;
  late bool removeShareValue;
  late bool autoSyncValue;

  @override
  void initState() {
    super.initState();
    shareMobileValue = widget.shareMobile;
    removeShareValue = widget.removeShareNotification;
    autoSyncValue = widget.autoSync;
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

