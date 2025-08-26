import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class SwitchButtonModel {
  final String title;
  final int id;

  SwitchButtonModel({required this.title, required this.id});
}

class CustomSwitchButton extends StatefulWidget {
  final List<SwitchButtonModel> items;
  final Function(int) onChange;
  final int initialIndex;
  final bool expandValue;

  const CustomSwitchButton({super.key, required this.items, required this.onChange, required this.initialIndex, this.expandValue = true});

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  int _selectedIndex = 1;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.cP50.withAlpha((0.2 * 255).toInt())),
        borderRadius: BorderRadius.circular(99),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in widget.items)
            Expanded(
              flex: widget.expandValue ? 1 : 0,
              child: InkWell(
                onTap: () {
                  _selectedIndex = item.id;
                  widget.onChange(item.id);
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: Durations.short4,
                  padding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: item.title.length > 6 ? 16 : 28, // Smaller padding for longer text
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == item.id ? AppColors.cP50 : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: AlignmentDirectional.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      item.title.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: _selectedIndex == item.id ? AppColors.white : AppColors.cP50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
