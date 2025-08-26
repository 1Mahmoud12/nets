import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/themes/styles.dart';

class Themes {
  String family;

  Themes(this.family);

  ThemeData light() => ThemeData(
    splashColor: Colors.transparent,
    // Your desired splash color
    highlightColor: Colors.transparent,

    // Your desired highlight color
    scaffoldBackgroundColor: AppColors.scaffoldBackGround,
    cardColor: Colors.white,
    fontFamily: family,
    primaryColor: AppColors.primaryColor,
    dividerTheme: DividerThemeData(color: AppColors.transparent),
    appBarTheme: const AppBarTheme(
      color: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.scaffoldBackGround,
        statusBarIconBrightness: Brightness.dark,
        // Dark icons for light background
        statusBarBrightness: Brightness.light,

        // iOS: light status bar for dark icons
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: AppColors.scaffoldBackGround,
        systemNavigationBarDividerColor: AppColors.scaffoldBackGround,
      ),
    ),
    cardTheme: CardThemeData(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.white,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
      bodyLarge: Styles.style24700.copyWith(color: AppColors.black400, fontFamily: family),
      bodyMedium: Styles.style22700.copyWith(color: AppColors.black400, fontFamily: family),
      bodySmall: Styles.style20700.copyWith(color: AppColors.black400, fontFamily: family),
      titleLarge: Styles.style16700.copyWith(color: AppColors.black400, fontFamily: family),
      titleMedium: Styles.style15400.copyWith(color: AppColors.black400, fontFamily: family),
      titleSmall: Styles.style12400.copyWith(color: AppColors.black400, fontFamily: family),
      labelLarge: Styles.style15700.copyWith(color: AppColors.black400, fontFamily: family),
      labelMedium: Styles.style12400.copyWith(color: AppColors.black400, fontFamily: family),
      labelSmall: Styles.style10400.copyWith(color: AppColors.black400, fontFamily: family),
      displayLarge: Styles.style14400.copyWith(color: AppColors.lightTextColor, fontFamily: family),
      displayMedium: Styles.style14400.copyWith(color: AppColors.black400, fontFamily: family),
      displaySmall: Styles.style18500.copyWith(color: AppColors.black400, fontFamily: family),
      headlineLarge: Styles.style11500.copyWith(color: AppColors.black400, fontFamily: family),
    ),
    dialogTheme: const DialogThemeData(backgroundColor: AppColors.scaffoldBackGround),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.transparent),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor, // Custom cursor color
      selectionColor: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()), // Custom selection color
      selectionHandleColor: AppColors.primaryColor, // Custom selection handle color
    ),
  );

  ThemeData dark() => ThemeData(
    scaffoldBackgroundColor: AppColors.black,
    fontFamily: family,
    dividerTheme: DividerThemeData(color: AppColors.transparent),
    appBarTheme: AppBarTheme(
      color: AppColors.appBarDarkModeColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    // cardTheme: CardTheme(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)), color: AppColors.white),
    textTheme: TextTheme(
      bodyLarge: Styles.style24700.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      bodyMedium: Styles.style22700.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      bodySmall: Styles.style20700.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      titleLarge: Styles.style16700.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      titleMedium: Styles.style15400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      titleSmall: Styles.style12400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      labelLarge: Styles.style15700.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      labelMedium: Styles.style12400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      labelSmall: Styles.style10400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      displayLarge: Styles.style14400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      displayMedium: Styles.style14400.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
      displaySmall: Styles.style18500.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),

      headlineLarge: Styles.style11500.copyWith(color: const Color(0xff9CA3A3), fontFamily: family),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor, // Custom cursor color
      selectionColor: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()), // Custom selection color
      selectionHandleColor: AppColors.primaryColor, // Custom selection handle color
    ),
    // dialogTheme: DialogTheme(backgroundColor: AppColors.black),
  );
}
