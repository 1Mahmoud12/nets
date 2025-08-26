import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/themes/styles.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margen;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Widget? suffixIcon;
  final String hint;
  final String? nameField;
  final double? width;
  final double? height;

  const CustomDropDownButton({
    Key? key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    this.fillColor = Colors.transparent,
    this.focusedBorderColor = const Color.fromARGB(255, 214, 209, 209),
    this.enabledBorderColor = const Color.fromARGB(255, 214, 209, 209),
    this.suffixIcon,
    this.nameField,
    required this.hint,
    this.margen,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      if (_selectedValue != null && !widget.items.contains(_selectedValue)) {
        setState(() {
          // Option 1: Reset to null (show hint)
          // _selectedValue = null;
          // Option 2: Try to select the first item of the new list
          if (widget.items.isNotEmpty) {
            _selectedValue = widget.items.first;
          } else {
            _selectedValue = null;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final deviceWidth = MediaQuery.of(context).size.width;
        final deviceHeight = MediaQuery.of(context).size.height;

        // Calculate responsive width and height if not specified
        final responsiveWidth = widget.width ?? deviceWidth;
        final responsiveHeight = widget.height ?? constraints.maxHeight;

        // Calculate responsive padding
        final defaultPadding = EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03, // 3% of screen width
          vertical: deviceHeight * 0.015, // 1.5% of screen height
        );

        // Calculate responsive text sizes
        final labelTextSize = deviceWidth * 0.035; // 3.5% of screen width
        final dropdownTextSize = deviceWidth * 0.04; // 4% of screen width

        return Padding(
          padding: widget.margen ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.nameField != null) ...[
                Text(widget.nameField!.tr(), style: Styles.style14500.copyWith(fontSize: labelTextSize)),
                SizedBox(height: deviceHeight * 0.01), // 1% of screen height
              ],
              Container(
                width: responsiveWidth,
                height: responsiveHeight,
                decoration: BoxDecoration(
                  color: widget.fillColor,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius! * (deviceWidth / 375), // Scale borderRadius based on screen width
                  ),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 35, offset: Offset(0, 9), spreadRadius: -4)],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedValue,
                  hint: Text(
                    widget.hint ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: dropdownTextSize),
                  ),
                  items: widget.items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: dropdownTextSize),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    widget.onChanged(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: widget.padding ?? defaultPadding,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius! * (deviceWidth / 375)),
                      borderSide: BorderSide(color: widget.enabledBorderColor!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius! * (deviceWidth / 375)),
                      borderSide: BorderSide(color: widget.focusedBorderColor!),
                    ),
                    filled: true,
                    fillColor: widget.fillColor,
                    suffixIcon: widget.suffixIcon != null ? SizedBox(height: responsiveHeight * 0.5, child: widget.suffixIcon) : null,
                  ),
                  isExpanded: true,
                  icon: const SizedBox(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
