import 'package:flutter/material.dart';

class NotificationToggleTile extends StatelessWidget {
  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDarkMode,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: isDarkMode ? Colors.black : Colors.black, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
      ),
      trailing: SizedBox(
        width: 65,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

