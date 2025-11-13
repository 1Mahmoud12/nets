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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextFormField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: streetOfficeCtrl,
            hintText: 'Street Name',
            nameField: 'Street Name',
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
                  hintText: 'Building Number',
                  nameField: 'Building Number',
                  borderRadius: 8,
                  validator: (value) => null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: officeNumberOfficeCtrl,
                  hintText: 'Office Number',
                  nameField: 'Office Number',
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
