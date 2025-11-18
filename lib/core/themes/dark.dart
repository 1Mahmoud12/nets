import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/themes/styles.dart';

class DarkTheme {
  String family;

  DarkTheme(this.family);

  ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkContainer,
    fontFamily: family,
    primaryColor: AppColors.primaryColor,
    dividerTheme: DividerThemeData(color: AppColors.darkBorder),
    appBarTheme: AppBarTheme(
      color: AppColors.darkAppBar,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      systemOverlayStyle: const SystemUiOverlayStyle(
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
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      color: AppColors.darkContainer,
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
      bodyLarge: Styles.style24700.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      bodyMedium: Styles.style22700.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      bodySmall: Styles.style20700.copyWith(
        color: AppColors.darkTextSecondary,
        fontFamily: family,
      ),
      titleLarge: Styles.style16700.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      titleMedium: Styles.style15400.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      titleSmall: Styles.style12400.copyWith(
        color: AppColors.darkTextSecondary,
        fontFamily: family,
      ),
      labelLarge: Styles.style15700.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      labelMedium: Styles.style12400.copyWith(
        color: AppColors.darkTextSecondary,
        fontFamily: family,
      ),
      labelSmall: Styles.style10400.copyWith(
        color: AppColors.darkTextSecondary,
        fontFamily: family,
      ),
      displayLarge: Styles.style14400.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      displayMedium: Styles.style14400.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      displaySmall: Styles.style18500.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
      headlineLarge: Styles.style11500.copyWith(
        color: AppColors.darkTextPrimary,
        fontFamily: family,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()),
      selectionHandleColor: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      hintStyle: TextStyle(color: AppColors.darkTextSecondary),
      labelStyle: TextStyle(color: AppColors.darkTextSecondary),
    ),
    dividerColor: AppColors.darkBorder,
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    primaryIconTheme: IconThemeData(color: AppColors.darkTextPrimary),
  );
}
