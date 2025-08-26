import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/component/sliders/custom_radio_button.dart';

class RadioButtonModel {
  final int id;
  final String name;
  final String? subtitle;
  bool value;

  RadioButtonModel({this.subtitle, required this.id, required this.name, this.value = false});
}

class CustomRadioListButton extends StatefulWidget {
  final String? title;
  final List<RadioButtonModel> items;

  const CustomRadioListButton({super.key, this.title, required this.items});

  @override
  State<CustomRadioListButton> createState() => _CustomRadioListButtonState();
}

class _CustomRadioListButtonState extends State<CustomRadioListButton> {
  String selectedOccupation = 'Student - School';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Text(widget.title!.tr(), style: Theme.of(context).textTheme.displayMedium),
        ...widget.items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomRadioButton(
                  nameRadioButton: e.name,
                  value: e.value,
                  subTitle: e.subtitle,
                  onTap: ({required selected}) {
                    for (final e in widget.items) {
                      e.value = false;
                    }
                    e.value = true;
                    setState(() {});
                  },
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
