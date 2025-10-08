import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/themes/styles.dart';
import 'package:nets/core/utils/constant_gaping.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/extensions.dart';

class DropDownModel {
  final String name;
  final String? image;
  final String? additionalText;
  final bool showImage;
  final bool showName;
  final int value;
  final Function()? onTap;

  DropDownModel({required this.name, required this.value, this.showImage = false, this.showName = true, this.image, this.additionalText, this.onTap});
}

class CustomDropDownMenu extends StatefulWidget {
  final DropDownModel? selectedItem;
  final List<DropDownModel> items;
  final double? width;
  final Color? borderColor;
  final Color? fillColor;
  final TextStyle? textStyleSelected;
  final int? directionArrowButton;
  final double? borderRadius;
  final bool showDropDownIcon;
  final void Function(DropDownModel?)? onChanged;
  final String? nameField;
  final bool hasError;
  final String? errorText;
  final EdgeInsetsGeometry? menuItemPadding; // New property for menu item padding
  final EdgeInsetsGeometry? buttonPadding; // New property for dropdown button padding
  final double? menuMaxHeight; // Control max height of dropdown menu
  final bool? state;

  const CustomDropDownMenu({
    super.key,
    required this.selectedItem,
    required this.items,
    this.width,
    this.onChanged,
    this.directionArrowButton,
    this.borderColor,
    this.fillColor,
    this.borderRadius,
    this.showDropDownIcon = true,
    this.textStyleSelected,
    this.nameField,
    this.hasError = false,
    this.errorText,
    this.menuItemPadding, // For controlling padding of menu items
    this.buttonPadding, // For controlling padding of the dropdown button
    this.menuMaxHeight,
    this.state = false, // For controlling max height of dropdown menu
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  DropDownModel newSelected = DropDownModel(name: '', value: -1, showName: false);

  @override
  void initState() {
    newSelected = widget.selectedItem!;
    log('print selected item====>${newSelected.showName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.nameField != null)
          Text(
            widget.nameField!.tr(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.cP50),
          ),
        if (widget.nameField != null) h8,
        Stack(
          children: [
            Container(
              //width: (MediaQuery.of(context).size.width * (widget.width ?? .9)).w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 100),
                color: widget.fillColor ?? AppColors.white,
                border: Border.all(width: 2, color: widget.hasError ? Colors.red : (widget.borderColor ?? AppColors.cBorderButtonColor)),
              ),
              child: DropdownButton<DropDownModel>(
                underline: Container(),
                icon: const SizedBox(),
                padding: widget.buttonPadding ?? EdgeInsets.symmetric(horizontal: newSelected.showImage ? 20 : 24),
                iconSize: 0,
                menuMaxHeight: widget.menuMaxHeight,

                hint: Row(
                  children: [
                    if (newSelected.showImage && newSelected.image != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: newSelected.image!.contains('.svg')
                            ? SvgPicture.asset(newSelected.image!, height: 20, width: 20)
                            : Image.asset(newSelected.image!, fit: BoxFit.contain, height: 20, width: 20),
                      ),
                    if (newSelected.showName)
                      Text(
                        newSelected.name.tr(),
                        style: Styles.style14400.copyWith(color: AppColors.textColor, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (widget.showDropDownIcon)
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: FittedBox(fit: BoxFit.scaleDown, child: Icon(Icons.keyboard_arrow_down)),
                      ),
                  ],
                ),
                onChanged: (DropDownModel? newValue) {
                  newSelected = newValue!;
                  setState(() {});

                  widget.onChanged?.call(newValue);
                },
                isExpanded: true,
                borderRadius: BorderRadius.circular(15.r),
                //  autofocus: false,
                focusColor: AppColors.primaryColor,
                dropdownColor: AppColors.white,
                alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                style: widget.textStyleSelected ?? Styles.style14400,
                itemHeight: null,
                menuWidth: context.screenWidth * .9,

                // Allow items to determine their own height
                items: widget.items.map((DropDownModel item) {
                  return DropdownMenuItem<DropDownModel>(
                    value: item,
                    child: Padding(
                      padding: widget.menuItemPadding ?? const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          if (item.showImage && item.image != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: item.image!.contains('.svg')
                                  ? SvgPicture.asset(item.image!, height: 20, width: 20)
                                  : Image.asset(item.image!, fit: BoxFit.contain, height: 20, width: 20),
                            ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: Styles.style12400,
                              overflow: TextOverflow.ellipsis,
                              textAlign: context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //debugPrint(widget.selectedItem);
                    },
                  );
                }).toList(),
              ),
            ),
            if (widget.state!)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  ),
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
          ],
        ),
        if (widget.hasError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              widget.errorText!.tr(),
              style: TextStyle(color: Colors.red, fontSize: Constants.tablet ? 12 : 12.sp),
            ),
          ),
      ],
    );
  }
}
