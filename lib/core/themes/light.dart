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
    cardTheme: CardThemeData(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)), color: AppColors.white),
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
    brightness: Brightness.dark,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkContainer,
    fontFamily: family,
    primaryColor: AppColors.primaryColor,
    dividerTheme: const DividerThemeData(color: AppColors.darkBorder),
    appBarTheme: const AppBarTheme(
      color: AppColors.darkAppBar,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.darkBackground,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarDividerColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: AppColors.darkBorder)),
      color: AppColors.darkContainer,
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
      bodyLarge: Styles.style24700.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      bodyMedium: Styles.style22700.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      bodySmall: Styles.style20700.copyWith(color: AppColors.darkTextSecondary, fontFamily: family),
      titleLarge: Styles.style16700.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      titleMedium: Styles.style15400.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      titleSmall: Styles.style12400.copyWith(color: AppColors.darkTextSecondary, fontFamily: family),
      labelLarge: Styles.style15700.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      labelMedium: Styles.style12400.copyWith(color: AppColors.darkTextSecondary, fontFamily: family),
      labelSmall: Styles.style10400.copyWith(color: AppColors.darkTextSecondary, fontFamily: family),
      displayLarge: Styles.style14400.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      displayMedium: Styles.style14400.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      displaySmall: Styles.style18500.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
      headlineLarge: Styles.style11500.copyWith(color: AppColors.darkTextPrimary, fontFamily: family),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: AppColors.darkBorder)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()),
      selectionHandleColor: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkContainer,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.darkBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.darkBorder)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
    ),
    dividerColor: AppColors.darkBorder,
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    primaryIconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
  );
}
