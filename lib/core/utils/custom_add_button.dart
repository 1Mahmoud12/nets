import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({super.key, required this.onTap, this.title});

  final VoidCallback onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  SvgPicture.asset(AppIcons.addIc),
            const SizedBox(width: 8),
            Text((title ?? 'add').tr(), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
