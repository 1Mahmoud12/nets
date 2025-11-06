import 'package:flutter/material.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/custom_drop_down_menu.dart';
import 'package:nets/core/themes/colors.dart';

class FiltersMyJourneySheet extends StatelessWidget {
  const FiltersMyJourneySheet({
    super.key,
    required this.isDarkMode,
    required this.darkModeValue,
    required this.title,
    required this.positionLabel,
    required this.positionPlaceholder,
    required this.countryLabel,
    required this.countryPlaceholder,
    required this.journeyLabel,
    required this.journeyPlaceholder,
    required this.dropDownItems,
    required this.resetText,
    required this.applyText,
    required this.onReset,
    required this.onApply,
  });

  final bool isDarkMode;
  final bool darkModeValue;
  final String title;
  final String positionLabel;
  final String positionPlaceholder;
  final String countryLabel;
  final String countryPlaceholder;
  final String journeyLabel;
  final String journeyPlaceholder;
  final List<DropDownModel> dropDownItems;
  final String resetText;
  final String applyText;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: darkModeValue ? AppColors.darkModeColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomDropDownMenu(
                    borderRadius: 8,
                    nameField: positionLabel,
                    selectedItem: DropDownModel(name: positionPlaceholder, value: 1),
                    items: dropDownItems,
                  ),
                  const SizedBox(height: 8),
                  CustomDropDownMenu(
                    borderRadius: 8,
                    nameField: countryLabel,
                    selectedItem: DropDownModel(name: countryPlaceholder, value: 1),
                    items: dropDownItems,
                  ),
                  const SizedBox(height: 8),
                  CustomDropDownMenu(
                    borderRadius: 8,
                    nameField: journeyLabel,
                    selectedItem: DropDownModel(name: journeyPlaceholder, value: 1),
                    items: dropDownItems,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextButton(
                        borderColor: AppColors.transparent,
                        borderRadius: 8,
                        colorText: AppColors.black,
                        backgroundColor: AppColors.primaryColor.withOpacity(.3),
                        onPress: () {
                          onReset();
                        },
                        childText: resetText,
                      ),
                      CustomTextButton(
                        borderColor: AppColors.transparent,
                        borderRadius: 8,
                        colorText: AppColors.white,
                        backgroundColor: AppColors.primaryColor,
                        onPress: () {
                          onApply();
                        },
                        childText: applyText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

