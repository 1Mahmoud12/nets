import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/custom_drop_down_menu.dart' show DropDownModel;
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/themes/styles.dart';
import 'package:nets/core/utils/constant_gaping.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/extensions.dart';

class CustomPopupMenu extends StatefulWidget {
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
  final void Function()? onTap;
  final String? nameField;
  final bool hasError;
  final String? errorText;
  final EdgeInsets? menuItemPadding;
  final EdgeInsetsGeometry? buttonPadding;
  final double? menuMaxHeight;
  final bool? state;
  final bool maxWidth;
  final bool addSpacer;

  const CustomPopupMenu({
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
    this.menuItemPadding,
    this.buttonPadding,
    this.menuMaxHeight,
    this.state = false,
    this.maxWidth = true,
    this.onTap,
    this.addSpacer = true,
  });

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  DropDownModel newSelected = DropDownModel(name: '', value: 0);

  @override
  void initState() {
    newSelected = widget.selectedItem!;
    log('print selected item====>${newSelected.showName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 100),
                  color: widget.fillColor ?? AppColors.white,
                  border: Border.all(width: 2, color: widget.hasError ? Colors.red : (widget.borderColor ?? AppColors.cBorderButtonColor)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PopupMenuButton<DropDownModel>(
                  color: darkModeValue ? AppColors.black : AppColors.white,
                  elevation: 4,
                  enabled: widget.onTap == null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  constraints: BoxConstraints(
                    maxHeight: widget.menuMaxHeight ?? double.infinity,
                    minWidth: context.screenWidth * .3,
                    maxWidth: widget.maxWidth ? context.screenWidth * .9 : context.screenWidth * .3,
                  ),
                  position: PopupMenuPosition.under,
                  offset: Offset(0, 16.h),
                  onSelected: (DropDownModel selectedValue) {
                    setState(() {
                      newSelected = selectedValue;
                    });
                    widget.onChanged?.call(selectedValue);
                    selectedValue.onTap?.call();
                  },
                  itemBuilder: (BuildContext context) {
                    return widget.items.map((DropDownModel item) {
                      return PopupMenuItem<DropDownModel>(
                        value: item,
                        padding: widget.menuItemPadding ?? const EdgeInsets.only(left: 10.0),
                        child: Container(
                          alignment: widget.maxWidth ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.black.withAlpha((.2 * 255).toInt()))),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),

                          width: widget.maxWidth ? context.screenWidth * .9 : context.screenWidth * .3,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.showImage)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    child: item.image!.contains('.svg')
                                        ? SvgPicture.asset(item.image!, fit: BoxFit.cover, height: 20, width: 20)
                                        : Image.asset(item.image!, height: 20, width: 20, fit: BoxFit.cover),
                                  ),
                                Text(
                                  item.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium?.copyWith(color: darkModeValue ? AppColors.darkModeText : AppColors.textColor),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  popUpAnimationStyle: const AnimationStyle(curve: Curves.linear, duration: Duration(milliseconds: 400)),
                  child: Container(
                    // width: 100,
                    padding: widget.buttonPadding ?? EdgeInsets.symmetric(horizontal: newSelected.showImage ? 20 : 20),
                    child: Row(
                      children: [
                        if (newSelected.showImage)
                          newSelected.image!.contains('.svg')
                              ? SvgPicture.asset(newSelected.image!, fit: BoxFit.cover, height: 20, width: 20)
                              : Image.asset(newSelected.image!, fit: BoxFit.cover, height: 20, width: 20),
                        if (newSelected.showName)
                          Padding(
                            padding: newSelected.showImage ? const EdgeInsets.only(left: 5, right: 5) : EdgeInsets.zero,
                            child: Text(
                              newSelected.name.tr(),
                              style:
                                  widget.textStyleSelected?.copyWith(
                                    color: darkModeValue ? AppColors.darkModeText : AppColors.textColor,
                                    fontWeight: FontWeight.w400,
                                  ) ??
                                  Styles.style14400.copyWith(
                                    color: (newSelected.name.contains('DD/') || newSelected.name.contains('select'))
                                        ? AppColors.greyG900
                                        : darkModeValue
                                        ? AppColors.darkModeText
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (widget.addSpacer) const Spacer(),
                        if (widget.showDropDownIcon)
                          RotatedBox(
                            quarterTurns: widget.directionArrowButton ?? 0,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(Icons.keyboard_arrow_down, color: darkModeValue ? AppColors.white : Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
