import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class LanguageSettingsSheet extends StatelessWidget {
  const LanguageSettingsSheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.languages,
    required this.selectedLanguage,
    required this.title,
    required this.onLanguageSelected,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final List<String> languages;
  final String? selectedLanguage;
  final String title;
  final ValueChanged<String> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: darkModeValue ? Colors.black : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: darkModeValue ? AppColors.black : AppColors.black),
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
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = language == selectedLanguage;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    language,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkModeValue ? Colors.black : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
                  onTap: () {
                    onLanguageSelected(language);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

