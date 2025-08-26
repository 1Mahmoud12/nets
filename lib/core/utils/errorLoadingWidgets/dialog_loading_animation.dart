import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nets/core/themes/colors.dart';

void animationDialogLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black26,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: AppColors.transparent,
      child: const SizedBox(height: 50, width: 50, child: SpinKitChasingDots(color: AppColors.primaryColor)),
    ),
  );
}

// void closeDialog(BuildContext context) {
//   if (Navigator.canPop(context)) {
//     Navigator.of(context).pop();
//   }
// }
void closeDialog(BuildContext context) {
  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
