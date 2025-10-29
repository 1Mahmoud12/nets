import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  // static String fontFamily = 'ALMAMLAKAFONT';
  static String fontFamily = 'Montserrat';
  static String appName = 'TAU';
  static LatLng locationCache = const LatLng(30.033333, 31.233334);
  static int distance = 100; // Km
  static bool hasStore = false;
  static String notificationChannelKey = 'channel_id1';
  static String fcmToken = 'test';
  static String deviceId = 'test';
  static String deviceType = 'test'; // mobile or tablet
  static String deviceOs = 'test'; // ios or android
  static String deviceVersion = 'test'; // version android or ios
  static String currency = 'currency'.tr();
  static bool tablet = false;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Map jsonServerKey = {};

  static RemoteMessage? messageGlobal;
  static String passwordApi = 'dot@jo';
  static String currentLanguage = 'en';
  static String unKnownValue = 'Un Known Value'.tr();
  static String token = '';
  static String? mapStyleString;
  static bool noInternet = false;
  static String versionApp = '';
  static String packageName = 'com.codgoo.nets';
  static String appleId = '6737690297';

  static String urlGoogleMapPlace = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static String urlGoogleMapLocation = 'https://maps.googleapis.com/maps/api/place/details/json';
  static String kGoogleMap = 'AIzaSyAgfXPnIUsG1t0RFfsefqcq7eJdPE1WdA8';
}

enum StatusRequest { completed, pending, canceled }

bool arabicLanguage = true;

class IconAndText {
  final String icon;
  final String text;

  IconAndText({required this.icon, required this.text});
}

List<DayAndMonth> weekDay = [
  DayAndMonth(day: 'السبت'.tr(), dayInMonth: '30'),
  DayAndMonth(day: 'الاحد'.tr(), dayInMonth: '01'),
  DayAndMonth(day: 'الاثنين'.tr(), dayInMonth: '02'),
  DayAndMonth(day: 'الثلاثاء'.tr(), dayInMonth: '03'),
  DayAndMonth(day: 'الاربعاء'.tr(), dayInMonth: '04'),
  DayAndMonth(day: 'الخميس'.tr(), dayInMonth: '05'),
  DayAndMonth(day: 'الجمعه'.tr(), dayInMonth: '06'),
];

class DayAndMonth {
  final String day;
  final String dayInMonth;

  DayAndMonth({required this.day, required this.dayInMonth});
}

class Country {
  final int id;
  final String name;
  final String code;
  final String image;

  Country({required this.id, required this.name, required this.code, required this.image});
}

class PricingModel {
  final int id;
  final String name;

  PricingModel({required this.id, required this.name});
}
