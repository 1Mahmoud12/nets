import 'package:flutter/material.dart';
import '../help_item_tile.dart';

class HelpSupportSheet extends StatelessWidget {
  const HelpSupportSheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.isArabic,
    required this.title,
    required this.items,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final bool isArabic;
  final String title;
  final List<HelpItemData> items;

  @override
  Widget build(BuildContext context) {
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
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkModeValue ? Colors.black : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: darkModeValue ? Colors.black : Colors.black),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: darkModeValue ? Colors.grey[700] : Colors.grey[200],
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(height: 20),
            ...items.map(
              (item) => HelpItemTile(
                iconPath: item.iconPath,
                title: item.title,
                subtitle: item.subtitle,
                onTap: item.onTap,
                isDarkMode: darkModeValue,
                isArabic: isArabic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class HelpItemData {
  const HelpItemData({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

