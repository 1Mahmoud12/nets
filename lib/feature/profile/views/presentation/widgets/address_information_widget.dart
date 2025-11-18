import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

import '../../../../../core/component/fields/custom_text_form_field.dart';

class AddressInformation extends StatelessWidget {
  const AddressInformation({
    super.key,
    required this.isDarkMode,
    required this.streetOfficeCtrl,
    required this.buildingOfficeCtrl,
    required this.officeNumberOfficeCtrl,
  });

  final bool isDarkMode;
  final TextEditingController streetOfficeCtrl;
  final TextEditingController buildingOfficeCtrl;
  final TextEditingController officeNumberOfficeCtrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkContainer : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDarkMode ? AppColors.darkBorder : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'address_information'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextFormField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: streetOfficeCtrl,
            hintText: 'street_name'.tr(),
            nameField: 'street_name'.tr(),
            borderRadius: 8,
            validator: (value) => null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: buildingOfficeCtrl,
                  hintText: 'building_number'.tr(),
                  nameField: 'building_number'.tr(),
                  borderRadius: 8,
                  validator: (value) => null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: officeNumberOfficeCtrl,
                  hintText: 'office_number'.tr(),
                  nameField: 'office_number'.tr(),
                  borderRadius: 8,
                  validator: (value) => null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
