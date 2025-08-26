import 'dart:convert';
import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/network/local/hive_data_base.dart';
import 'package:nets/core/utils/bloc_observe.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';
import 'package:nets/feature/splash/view/presentation/splash_screen_view.dart';

import 'firebase_options.dart';
import 'my_app.dart';

//PusherService pusherService = PusherService();
// Widget appStartScreen = ForgotPasswordView();
Widget appStartScreen = const LoginView();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  EasyLocalization.logger.enableBuildModes = [];
  // Hive

  await Hive.initFlutter();

  // Dio
  await DioHelper.init();
  debugPaintSizeEnabled = false;

  userCache = await openHiveBox(userCacheBoxKey);
  dataCache = await openHiveBox(dataCacheBoxKey);
  loginCache = await openHiveBox(loginCacheBoxKey);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: AppColors.scaffoldBackGround, // Make status bar transparent
  //     statusBarIconBrightness: Brightness.dark, // Dark icons for light background
  //     statusBarBrightness: Brightness.light, // iOS: light status bar for dark icons
  //   ),
  // );
  onBoardingValue = dataCache?.get(onBoardingKey, defaultValue: true);
  darkModeValue = userCache?.get(darkModeKey, defaultValue: false);
  checkedNotification = userCache?.get(checkedNotificationKey, defaultValue: false);
  closeUrgentNewValue = false;
  themeModeValue = userCache?.get(themeModeKey, defaultValue: 'light');
  locationCacheValue = userCache?.get(locationCacheKey);
  final String? cacheData = await userCache?.get(userCacheKey, defaultValue: '{}');
  ConstantsModels.loginModel = cacheData != null ? LoginModel.fromJson(jsonDecode(cacheData)) : null;
  userCacheValue = cacheData != null ? LoginModel.fromJson(jsonDecode(cacheData)) : null;

  // ConstantsModels.dynamicArticleModel = DynamicArticleModel.fromJson(jsonDecode(await dataCache?.get(dynamicArticleKey, defaultValue: '{}')));
  // ConstantsModels.storiesModel = StoriesModel.fromJson(jsonDecode(await dataCache?.get(storiesModelKey, defaultValue: '{}')));
  // ConstantsModels.splashHomeModel = SplashHomeModel.fromJson(jsonDecode(await dataCache?.get(splashHomeModelKey, defaultValue: '{}')));
  // ConstantsModels.articlesForYou = LastArticleModel.fromJson(jsonDecode(await dataCache?.get(articlesForYouKey, defaultValue: '{}')));
  // ConstantsModels.lastArticleModel = LastArticleModel.fromJson(jsonDecode(await dataCache?.get(lastArticlesKey, defaultValue: '{}')));
  // ConstantsModels.getLastArticleByDepartmentIdModel = CustomLastArticleModel.fromJson(
  //   jsonDecode(await dataCache?.get(customLastArticleByDepartmentIdModel, defaultValue: '{}')),
  // );
  log('userCache===>$checkedNotification');
  //ConstantsModels.favoritesModel = FavoritesModel.fromJson(jsonDecode(await userCache!.get(favoritesKey, defaultValue: '{}')));

  Constants.token = ConstantsModels.loginModel?.data?.authKey ?? '';
  Constants.fcmToken = await userCache?.get(fcmTokenKey, defaultValue: '');
  Constants.deviceId = await userCache?.get(deviceIdKey, defaultValue: '');
  arabicLanguage = await userCache?.get(languageAppKey, defaultValue: false);

  log('arabicLanguage ==>$arabicLanguage');
  //Constants.fontFamily = arabicLanguage ? 'Tajawal' : 'Inter';
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  });
  try {
    Constants.messageGlobal = await FirebaseMessaging.instance.getInitialMessage();
    if (Constants.messageGlobal?.data != null) {
      appStartScreen = const NavigationView();
    }
    log('appStartScreen $appStartScreen');
  } catch (error) {
    log('$error');
  }
  // rootBundle.loadString('assets/services/map.json').then((string) {
  //   Constants.mapStyleString = string;
  // });
  //selectTokens();
  //Constants.jsonServerKey = await loadJsonFile();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
        path: 'assets/translation',
        startLocale: const Locale('ar', 'SA'),
        child: DevicePreview(enabled: false, builder: (context) => const MyApp()),
      ),
    );
  });
}
