import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/light.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/notification/notification.dart';
import 'package:nets/feature/Contacts/views/manager/cubit/contacts_cubit.dart';
import 'package:nets/feature/my_journey/views/manager/cubit/my_journey_cubit.dart';
import 'package:nets/feature/navigation/view/manager/homeBloc/cubit.dart';
import 'package:nets/feature/navigation/view/manager/homeBloc/state.dart';
import 'package:nets/feature/profile/views/manager/cubit/user_data_cubit.dart';
import 'package:nets/feature/profile/views/manager/getUesrStatistics/cubit/get_user_statistics_cubit.dart';
import 'package:nets/feature/profile/views/manager/update/cubit/update_user_data_cubit.dart';
import 'package:nets/main.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _getThemeMode() {
    switch (themeModeValue) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'auto':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  @override
  void initState() {
    if (checkedNotification) {
      initNotification();
      selectTokens();
    }
    super.initState();
  }

  Future<void> initNotification() async {
    await Future.delayed(Duration.zero, () async {
      //setup notification callback here
      await NotificationUtility.setUpNotificationService(context);
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationUtility.onDismissActionReceivedMethod,
    );

    notificationTerminatedBackground();
  }

  void notificationTerminatedBackground() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('Global Message ${Constants.messageGlobal?.data}');
      if (Constants.messageGlobal?.data != null) {
        debugPrint('Global Message Enter${Constants.messageGlobal?.data}');

        Future.delayed(const Duration(milliseconds: 1000), () async {
          NotificationUtility.onTapNotificationScreenNavigateCallback(Constants.messageGlobal!.data['type'] ?? '', Constants.messageGlobal!.data);
          Constants.messageGlobal = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    arabicLanguage = context.locale.languageCode == 'en';
    // if (false) {
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // }
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (_, child) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => MainCubit()),
              BlocProvider(create: (context) => UserDataCubit()),
              BlocProvider(create: (context) => GetUserStatisticsCubit()),
              BlocProvider(create: (context) => ContactsCubit()),
              BlocProvider(create: (context) => MyJourneyCubit()),
              BlocProvider(create: (context) => UpdateUserDataCubit()),
            ],
            child: BlocBuilder<MainCubit, MainState>(
              builder: (context, state) {
                //    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                return Platform.isIOS ? buildMaterialApp(context) : buildMaterialApp(context);
              },
            ),
          ),
    );
  }

  MaterialApp buildMaterialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      //locale: DevicePreview.locale(context),
      //builder: DevicePreview.appBuilder,
      navigatorKey: navigatorKey,
      theme: Themes(Constants.fontFamily).light(),
      darkTheme: Themes(Constants.fontFamily).dark(),
      themeMode: _getThemeMode(),
      builder: (context, child) => child!,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInCubic,
      // themeAnimationStyle: AnimationStyle(),
      home: appStartScreen,
    );
  }
}
