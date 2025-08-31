import 'dart:convert';
import 'dart:developer';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:app_links/app_links.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:nets/feature/Contacts/contacts_view.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

import 'firebase_options.dart';
import 'my_app.dart';

//PusherService pusherService = PusherService();
// Widget appStartScreen = ForgotPasswordView();
Widget appStartScreen = const LoginView();
final appLinks = AppLinks(); // AppLinks is singleton

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
  // Handle initial link when app starts from deep link
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    log('====== initial deep link =======');
    logger.d(initialLink);
    _handleDeepLink(initialLink);
  }

  // Subscribe to all events (ongoing deep links when app is running)
  appLinks.uriLinkStream.listen((uri) {
    log('====== deep link =======');
    logger.d(uri);
    _handleDeepLink(uri);
  });
  Constants.token = ConstantsModels.loginModel?.data?.authKey ?? '';
  Constants.fcmToken = await userCache?.get(fcmTokenKey, defaultValue: '');
  Constants.deviceId = await userCache?.get(deviceIdKey, defaultValue: '');
  arabicLanguage = await userCache?.get(languageAppKey, defaultValue: false);

  log('arabicLanguage ==>$arabicLanguage');
  //Constants.fontFamily = arabicLanguage ? 'Tajawal' : 'Inter';
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    //  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
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

  final AdjustConfig config = AdjustConfig('{YourAppToken}', AdjustEnvironment.sandbox);
  Adjust.initSdk(config);

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

void _handleDeepLink(Uri uri) {
  log('Handling deep link: $uri');

  // Extract the path segments from the URI
  final pathSegments = uri.host;
  final segments = uri.pathSegments;
  log('Handling pathSegments: $pathSegments');

  if (pathSegments.isNotEmpty) {
    // Handle different deep link routes
    switch (pathSegments) {
      case 'profile':
        if (segments.isNotEmpty) {
          // Navigate to the appropriate screen based on the link ID
          final linkId = segments[0];
          _navigateToLinkScreen(linkId);
        }
        break;
      default:
        log('Unknown deep link path: $pathSegments');
        // Navigate to home/main screen for unknown paths
        _navigateToMainScreen();
    }
  }
}

void _navigateToLinkScreen(String linkId) {
  // Wait for the app to be fully initialized before navigating
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (navigatorKey.currentState != null) {
      // Navigate to the main screen (NavigationView)
      // You can add additional logic here to pass the linkId to a specific screen
      //  navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const NavigationView()), (route) => false);
      showContactDetails({
        'name': 'Ahmed Hassan',
        'phone': '+20 123 456 7890',
        'email': 'ahmed.hassan@email.com',
        'status': 'online',
      }, navigatorKey.currentState!.context);
      // Optional: Show a message or navigate to a specific tab based on linkId
      log('Successfully navigated to main screen for link ID: $linkId');
    } else {
      // If navigator is not ready, set the app start screen
      appStartScreen = const NavigationView();
    }
  });
}

void _navigateToMainScreen() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const NavigationView()), (route) => false);
    } else {
      appStartScreen = const NavigationView();
    }
  });
}
