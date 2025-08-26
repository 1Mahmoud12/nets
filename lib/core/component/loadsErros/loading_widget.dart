import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.height = 40, this.width = 40, this.color = AppColors.primaryColor});
  final double? height;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: height,
        height: width,
        child: Center(
          child: FittedBox(child: CircularProgressIndicator(color: color, strokeWidth: 2)),
        ),
      ),
    );
  }
}
