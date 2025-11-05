import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/component/fields/custom_text_form_field.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../auth/views/presentation/widgets/custom_drop_down_phone.dart';
import '../../../../auth/views/presentation/widgets/phone_number_field.dart';

class PhoneFieldWithCountryCode extends StatefulWidget {
  final TextEditingController controller;
  final String? initialCountryCode;
  final Function(String countryCode)? onCountryCodeChanged;
  final String? nameField;
  final bool enabled;

  const PhoneFieldWithCountryCode({
    super.key,
    required this.controller,
    this.initialCountryCode,
    this.onCountryCodeChanged,
    this.nameField,
    this.enabled = true,
  });

  @override
  State<PhoneFieldWithCountryCode> createState() => _PhoneFieldWithCountryCodeState();
}

class _PhoneFieldWithCountryCodeState extends State<PhoneFieldWithCountryCode> {
  late String _countryCode;
  late int _selectedCountryIndex;

  void _updatePhoneHint(String countryCode) {
    setState(() {
      _countryCode = countryCode;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize with provided country code or default
    if (widget.initialCountryCode != null) {
      // Find the index of the country with the matching code
      final countryIndex = countriesflage.indexWhere(
        (country) => country.code == widget.initialCountryCode,
      );

      // If found, use that index, otherwise default to 0
      _selectedCountryIndex = countryIndex >= 0 ? countryIndex : 0;
      _countryCode = countriesflage[_selectedCountryIndex].code;
    } else {
      // Default to the first country in the list
      _selectedCountryIndex = 0;
      _countryCode = countriesflage.first.code;
    }

    // Initialize the phone hint based on the selected country code
    _updatePhoneHint(_countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      enable: widget.enabled,
      textInputType: TextInputType.phone,
      controller: widget.controller,
      borderRadius: 8,
      nameField: widget.nameField,
      hintText: 'enter_phone_number'.tr(),
      validator: (value) => null, // Disable validation as requested
      prefixIcon: SizedBox(
        width: 95,
        child: CountryCodeDropdown(
          initialCountryIndex: _selectedCountryIndex,
          onCountryChanged: (countryCode) {
            _updatePhoneHint(countryCode);
            widget.onCountryCodeChanged?.call(countryCode);
            // Clear phone controller when country code changes
            widget.controller.clear();
          },
        ),
      ),
    );
  }
}

class CountryCodeDropdown extends StatelessWidget {
  final Function(String countryCode) onCountryChanged;
  final int initialCountryIndex;

  const CountryCodeDropdown({
    super.key,
    required this.onCountryChanged,
    this.initialCountryIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropDownPhone(
      fillColor: AppColors.transparent,
      borderColor: AppColors.transparent,
      onChanged: (value) {
        final selectedCountry = countriesflage[value?.value ?? 0];
        onCountryChanged(selectedCountry.code);
      },
      selectedItem: DropDownModelPhone(
        name: countriesflage[initialCountryIndex].code,
        value: countriesflage[initialCountryIndex].id,
        image: countriesflage[initialCountryIndex].image,
        showImage: true,
      ),
      items: countriesflage
          .map(
            (e) => DropDownModelPhone(
              name: e.code,
              value: e.id,
              showImage: true,
              image: e.image,
            ),
          )
          .toList(),
    );
  }
}

