import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionPopupMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String iconPath; // Path to the SVG icon
  final bool isEdit;
  final bool isDelete;

  const OptionPopupMenu({Key? key, required this.onEdit, required this.onDelete, required this.iconPath, this.isEdit = true, this.isDelete = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.white,
      icon: SvgPicture.asset(iconPath),
      onSelected: (value) {
        if (value == 0) {
          onEdit(); // Call edit function
        } else if (value == 1) {
          onDelete(); // Call delete function
        }
      },
      menuPadding: const EdgeInsets.symmetric(horizontal: 6),
      itemBuilder:
          (context) => [
            if (isEdit)
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16.sp),
                    const SizedBox(width: 8),
                    Text('edit'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            if (isDelete)
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16.sp),
                    const SizedBox(width: 8),
                    Text('delete'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
          ],
    );
  }
}
