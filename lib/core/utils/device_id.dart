import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/notification/notification.dart';
import 'package:nets/feature/navigation/data/homeDataSource/home_data_source.dart';
import 'package:uuid/uuid.dart';

import '../network/local/cache.dart';

class DeviceUUid {
  Future<void> initializeDeviceInfo({bool isAuth = false}) async {
    log('initializeDeviceInfo');
    await _setDeviceId();
    await _setFCMToken();
    await _setDeviceType();
    await _setDeviceOs();
    await _setDeviceVersion();
    if (!isAuth) {
      HomeDataSourceImplementation().updateDeviceToken();
    }

    log('deviceId: ${Constants.deviceId}');
    log('fcmToken: ${Constants.fcmToken}');
    log('deviceType: ${Constants.deviceType}');
    log('deviceOs: ${Constants.deviceOs}');
    log('deviceVersion: ${Constants.deviceVersion}');
  }

  Future<void> _setDeviceId() async {
    String uniqueDeviceId = '';
    const uuid = Uuid();
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}';
    }

    if (uniqueDeviceId.isEmpty) {
      // Fallback to cached or generated UUID
      uniqueDeviceId = await userCache?.get('device_id') ?? '';
      if (uniqueDeviceId.isEmpty) {
        uniqueDeviceId = uuid.v4();
        await userCache?.put('device_id', uniqueDeviceId);
      }
    }

    Constants.deviceId = uniqueDeviceId;
    userCache?.put(deviceIdKey, uniqueDeviceId);
  }

  Future<void> _setFCMToken() async {
    try {
      final String? token = await enableNotification() ? await FirebaseMessaging.instance.getToken() : 'not available';
      Constants.fcmToken = token ?? 'not available';
      userCache?.put(fcmTokenKey, Constants.fcmToken);
    } catch (e) {
      log('Error getting FCM token: $e');
      Constants.fcmToken = 'not available';
    }
  }

  Future<void> _setDeviceType() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      // Check if it's an iPad
      if (iosDeviceInfo.model.toLowerCase().contains('ipad')) {
        Constants.deviceType = 'tablet';
      } else {
        Constants.deviceType = 'mobile';
      }
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      // Check screen size or use device characteristics to determine if tablet
      // This is a simplified approach - you might want to use screen dimensions
      final isTablet = androidDeviceInfo.isPhysicalDevice == false || _isTabletByModel(androidDeviceInfo.model);
      Constants.deviceType = isTablet ? 'tablet' : 'mobile';
    } else {
      Constants.deviceType = 'unknown';
    }
  }

  Future<void> _setDeviceOs() async {
    if (Platform.isIOS) {
      Constants.deviceOs = 'ios';
    } else if (Platform.isAndroid) {
      Constants.deviceOs = 'android';
    } else {
      Constants.deviceOs = 'unknown';
    }
  }

  Future<void> _setDeviceVersion() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      Constants.deviceVersion = iosDeviceInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      Constants.deviceVersion = androidDeviceInfo.version.release;
    } else {
      Constants.deviceVersion = 'unknown';
    }
  }

  bool _isTabletByModel(String model) {
    // Simple tablet detection by model name
    final tabletKeywords = ['tab', 'pad', 'tablet'];
    final modelLower = model.toLowerCase();
    return tabletKeywords.any((keyword) => modelLower.contains(keyword));
  }

  // Keep your original method for backward compatibility
  Future<String> getUniqueDeviceId() async {
    if (Constants.deviceId.isEmpty) {
      await _setDeviceId();
    }
    return Constants.deviceId;
  }
}
