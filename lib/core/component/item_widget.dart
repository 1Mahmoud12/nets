import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants.dart';

class ItemWidget extends StatelessWidget {
  final String nameItem;
  final String nameImage;
  final VoidCallback onTap;

  const ItemWidget({super.key, required this.nameItem, required this.nameImage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              SvgPicture.asset(nameImage),
              const SizedBox(width: 16),
              Text(nameItem.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400)),
              const SizedBox(width: 10),
              const Spacer(),
              RotatedBox(
                quarterTurns: arabicLanguage ? 2 : 0,
                child: SvgPicture.asset(AppIcons.arrowBackIc, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
