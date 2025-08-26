import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nets/core/component/custom_drop_down_menu.dart';
import 'package:nets/core/component/drop_menu.dart' show CustomPopupMenu;
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';

class CountryCode {
  final int id;
  final String name;
  final String code;
  final String image;
  final int maxLength;

  CountryCode({required this.id, required this.name, required this.code, required this.image, required this.maxLength});
}

class CustomPhoneNumberField extends StatefulWidget {
  const CustomPhoneNumberField({super.key, required this.phoneController});

  final TextEditingController phoneController;

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  // Define country codes for Egypt and Jordan with phone length constraints
  final List<CountryCode> countryCodes = [
    CountryCode(
      id: 20,
      name: 'Egypt',
      code: '+20',
      image: 'assets/flags/eg.png',
      // Adjust path as needed
      maxLength: 10, // Egypt phone numbers are typically 10 digits after code
    ),
    CountryCode(
      id: 962,
      name: 'Jordan',
      code: '+962',
      image: 'assets/flags/jo.png',
      // Adjust path as needed
      maxLength: 9, // Jordan phone numbers are typically 9 digits after code
    ),
  ];

  late CountryCode selectedCountry;
  final TextEditingController _displayController = TextEditingController();
  bool _isInternalChange = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = countryCodes.first;

    // Initialize with any existing value in the phone controller
    if (widget.phoneController.text.isNotEmpty) {
      _updateDisplayFromMain();
    } else {
      // Start with the country code
      widget.phoneController.text = selectedCountry.code;
    }

    // Listen to changes in the display controller
    _displayController.addListener(_onDisplayControllerChanged);
  }

  @override
  void dispose() {
    _displayController.removeListener(_onDisplayControllerChanged);
    _displayController.dispose();
    super.dispose();
  }

  // Update the display controller based on the main controller
  void _updateDisplayFromMain() {
    final phoneText = widget.phoneController.text;

    // If the phone controller contains a country code, extract just the number part
    if (phoneText.startsWith(selectedCountry.code)) {
      _isInternalChange = true;
      _displayController.text = phoneText.substring(selectedCountry.code.length);
      _isInternalChange = false;
    } else {
      // If it doesn't start with the code, update the main controller to include it
      _isInternalChange = true;
      widget.phoneController.text = selectedCountry.code + phoneText;
      _displayController.text = phoneText;
      _isInternalChange = false;
    }
  }

  // Update the main controller when the display controller changes
  void _onDisplayControllerChanged() {
    if (_isInternalChange) return;

    _isInternalChange = true;
    widget.phoneController.text = selectedCountry.code + _displayController.text;
    _isInternalChange = false;
  }

  // Update controllers when country changes
  void _updateCountry(CountryCode newCountry) {
    setState(() {
      selectedCountry = newCountry;

      // Update with new country code
      _isInternalChange = true;
      _displayController.text = '';
      widget.phoneController.text = selectedCountry.code;
      _isInternalChange = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
      outPadding: EdgeInsets.zero,
      controller: _displayController,
      // Use display controller for the field
      hintText: 'enter_your_phone'.tr(),
      nameField: 'phone_number'.tr(),
      textInputType: TextInputType.number,

      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(selectedCountry.maxLength)],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        }
        if (value.length < selectedCountry.maxLength) {
          return 'invalid_phone_number_length'.tr();
        }
        return null;
      },
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 110, // Increased width to accommodate country code
          child: Row(
            children: [
              Expanded(
                child: CustomPopupMenu(
                  fillColor: AppColors.transparent,
                  borderColor: AppColors.transparent,
                  selectedItem: DropDownModel(
                    name: selectedCountry.name,
                    value: selectedCountry.id,
                    image: selectedCountry.image,
                    additionalText: selectedCountry.code,
                  ),
                  items: countryCodes.map((e) => DropDownModel(name: e.name, value: e.id, image: e.image, additionalText: e.code)).toList(),
                  onChanged: (DropDownModel? item) {
                    if (item != null) {
                      _updateCountry(countryCodes.firstWhere((country) => country.id == item.value));
                    }
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(height: 20, width: 1, color: AppColors.secondDividerColor),
            ],
          ),
        ),
      ),
    );
  }
}
