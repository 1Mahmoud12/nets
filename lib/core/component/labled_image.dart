import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/component/cache_image.dart';
import 'package:nets/core/utils/constant_gaping.dart';

class LabeledImage extends StatelessWidget {
  const LabeledImage({super.key, required this.label, this.logoImage});

  final String label;
  final String? logoImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey.withAlpha((0.6 * 255).toInt())),
        ),
        s,
        CacheImage(height: 30, width: 30, urlImage: logoImage, errorColor: Colors.grey),
      ],
    );
  }
}
