import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

import '../../../../../core/component/fields/custom_text_form_field.dart';

class PhoneData {
  final TextEditingController controller;
  final TextEditingController typeController;
  bool isPrimary;

  PhoneData({
    required this.controller,
    TextEditingController? typeController,
    String type = 'mobile',
    this.isPrimary = false,
  }) : typeController = typeController ?? TextEditingController(text: type);

  String get type => typeController.text;
  set type(String value) {
    typeController.text = value;
  }
}

class ContactInformation extends StatefulWidget {
  const ContactInformation({
    super.key,
    required this.phones,
    required this.isDarkMode,
    required this.zipCtrl,
    this.onPhoneChanged,
    this.onAddPhone,
  });

  final bool isDarkMode;
  final TextEditingController zipCtrl;
  final List<PhoneData> phones;
  final Function(int index, String type, bool isPrimary)? onPhoneChanged;
  final VoidCallback? onAddPhone;

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
          ...List.generate(widget.phones.length, (i) {
            final phone = widget.phones[i];
            return Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: phone.controller,
                    hintText: 'Phone Number',
                    nameField: i == 0 ? 'Phone Numbers' : null,
                    textInputType: TextInputType.phone,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Phone Type Text Field
                      Expanded(
                        child: CustomTextFormField(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          controller: phone.typeController,
                          hintText: 'Type (e.g., mobile, office)',
                          nameField: null,
                          textInputType: TextInputType.text,
                          borderRadius: 8,
                          onChange: (value) {
                            widget.onPhoneChanged?.call(i, value, phone.isPrimary);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Primary Checkbox (Required - at least one must be selected)
                      Row(
                        children: [
                          Checkbox(
                            value: phone.isPrimary,
                            onChanged: (value) {
                              if (value == true) {
                                // Uncheck all other phones
                                for (var p in widget.phones) {
                                  p.isPrimary = false;
                                }
                                phone.isPrimary = true;
                              } else {
                                // Prevent unchecking if it's the only primary phone
                                final primaryCount = widget.phones.where((p) => p.isPrimary).length;
                                if (primaryCount <= 1) {
                                  // Keep it checked - at least one must be primary
                                  return;
                                }
                                phone.isPrimary = false;
                              }
                              widget.onPhoneChanged?.call(i, phone.type, phone.isPrimary);
                              setState(() {});
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                          const Text('Primary *'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: widget.onAddPhone ?? () {},
            child: Row(
              children: [
                const Icon(Icons.add, color: AppColors.primaryColor),
                Text(
                  'Add Phone Number',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
