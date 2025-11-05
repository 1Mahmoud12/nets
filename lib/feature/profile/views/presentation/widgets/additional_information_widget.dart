import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';

class AdditionalInformationWidget extends StatelessWidget {
  const AdditionalInformationWidget({
    super.key,
    required this.isDarkMode,
    required this.controller,
  });

  final bool isDarkMode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'additional_information'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
          ),
          const SizedBox(height: 24),
          CustomTextFormField(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            controller: controller,
            hintText: 'other_details'.tr(),
            nameField: 'other_details'.tr(),
            maxLines: 6,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

