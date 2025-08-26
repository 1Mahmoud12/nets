import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/themes/styles.dart';
import 'package:nets/core/utils/item_above_modal_bottom_sheet.dart';

Future<void> successModalBottomSheet(
  BuildContext context, {
  required String title,
  required String subTitle,
  required String nameButton,
  required Function onPress,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SuccessBottomSheet(title: title, subTitle: subTitle, nameButton: nameButton, onPress: onPress);
    },
  );
}

class SuccessBottomSheet extends StatefulWidget {
  final String title;
  final String subTitle;
  final String nameButton;
  final Function onPress;

  const SuccessBottomSheet({super.key, required this.title, required this.subTitle, required this.nameButton, required this.onPress});

  @override
  State<SuccessBottomSheet> createState() => _SuccessBottomSheetState();
}

class _SuccessBottomSheetState extends State<SuccessBottomSheet> {
  bool expanded = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      log('Updated $expanded');

      expanded = true;
      setState(() {});
      log('Updated $expanded');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: ItemAboveModalBottomSheet()),
                      AnimatedContainer(
                        duration: Durations.long1,
                        height: expanded ? 120 : 25,
                        width: expanded ? 120 : 25,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: expanded ? AppColors.primaryColor : AppColors.transparent, shape: BoxShape.circle),
                        child: Center(
                          child: Icon(Icons.check, color: AppColors.white, size: expanded ? 100 : 25),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title.tr(),
                        textAlign: TextAlign.center,
                        style: Styles.style18300.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.subTitle.tr(), textAlign: TextAlign.center, style: Styles.style12300),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Durations.long1,
                    width: expanded ? MediaQuery.of(context).size.width * .75 : 25,
                    child: Image.asset('assets/animation/Animation - 1728555554899.gif', fit: BoxFit.cover),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor.withAlpha((0.1 * 255).toInt())),
              left: BorderSide(color: Theme.of(context).dividerColor.withAlpha((0.1 * 255).toInt())),
              right: BorderSide(color: Theme.of(context).dividerColor.withAlpha((0.1 * 255).toInt())),
            ),
            boxShadow: [BoxShadow(color: const Color(0xff00001a).withAlpha((0.1 * 255).toInt()), blurRadius: 26, offset: const Offset(30, 0))],
            color: Colors.white,
          ),
          child: Row(
            children: [
              CustomTextButton(
                backgroundColor: AppColors.primaryColor,
                borderColor: Colors.transparent,
                childText: widget.nameButton.tr(),

                padding: const EdgeInsets.symmetric(vertical: 12),
                onPress: () {
                  Navigator.pop(context);
                  widget.onPress();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
