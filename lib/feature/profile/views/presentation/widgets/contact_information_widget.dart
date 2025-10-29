import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

import '../../../../../core/component/fields/custom_text_form_field.dart';

class ContactInformation extends StatefulWidget {
  ContactInformation({
    super.key,
    required this.mobiles,
    required this.isDarkMode,
    required this.poBoxCtrl,
    required this.zipCtrl,
    required this.officePhoneCtrl,
  });

  final bool isDarkMode;
  final TextEditingController zipCtrl;
  final TextEditingController poBoxCtrl;
  final TextEditingController officePhoneCtrl;
  List mobiles = [];

  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
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
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: widget.isDarkMode ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(widget.mobiles.length, (i) {
            return Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
              child: CustomTextFormField(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                controller:widget. mobiles[i],
                hintText: 'Mobile Number',
                nameField: i == 0 ? 'Mobile Numbers' : null,
                textInputType: TextInputType.phone,
                borderRadius: 8,
              ),
            );
          }),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() => widget.mobiles.add(TextEditingController()));
            },
            child: Row(
              children: [
                const Icon(Icons.add, color: AppColors.primaryColor),
                Text(
                  'Add Mobile Number',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: widget.officePhoneCtrl,
                  hintText: 'Office Phone',
                  nameField: 'Office Phone',
                  textInputType: TextInputType.phone,
                  borderRadius: 8,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: widget.poBoxCtrl,
                  hintText: 'P.O. Box',
                  nameField: 'P.O. Box',
                  textInputType: TextInputType.text,
                  borderRadius: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: widget.zipCtrl,
            hintText: 'Zip Code',
            nameField: 'Zip Code',
            textInputType: TextInputType.number,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
