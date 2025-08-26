import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkAndRequestBatteryOptimization() async {
  if (!Platform.isAndroid) {
    return true; // Not applicable to iOS
  }

  final deviceInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = deviceInfo.version.sdkInt;

  // Battery optimization is mainly relevant for Android 6.0+ (SDK 23+)
  if (sdkInt < 23) {
    return true;
  }

  try {
    // Check if the app is ignoring battery optimizations
    final status = await Permission.ignoreBatteryOptimizations.status;

    if (!status.isGranted) {
      // Request to ignore battery optimizations
      // This will open the battery optimization settings screen
      await openAppSettings();

      // Alternatively, you can use a direct intent (Android only)
      // await _openBatteryOptimizationSettings();

      return false;
    }

    return true;
  } catch (e) {
    print('Battery optimization check failed: $e');
    return false;
  }
}
