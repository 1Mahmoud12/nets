import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/utils/constant_gaping.dart';

class IsTrendingWidget extends StatelessWidget {
  const IsTrendingWidget({super.key, required this.isTrending});

  final bool isTrending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Trending',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey..withOpacity(0.6)),
        ),
        s,
        Text(
          isTrending ? 'Yes' : 'No',
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: isTrending ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}
