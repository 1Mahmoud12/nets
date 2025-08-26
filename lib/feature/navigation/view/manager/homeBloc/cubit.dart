import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/feature/navigation/view/manager/homeBloc/state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit of(BuildContext context) => BlocProvider.of<MainCubit>(context);

  void changeLanguage(Locale locale, BuildContext context) {
    context.setLocale(locale);
    arabicLanguage = locale.languageCode == 'ar';
    log('cubit $arabicLanguage');
    Constants.fontFamily = arabicLanguage ? 'ALMAMLAKAFONT' : 'ALMAMLAKAFONT';
    userCache?.put(languageAppKey, arabicLanguage);
    emit(ChangeInitialState());
  }

  void changeTheme(BuildContext context) {
    darkModeValue = !darkModeValue;

    userCache?.put(darkModeKey, darkModeValue);

    emit(ChangeThemeState());
  }

  void changeThemeMode(String themeMode, [BuildContext? context]) {
    themeModeValue = themeMode;
    // Update darkModeValue for backward compatibility
    if (themeMode == 'dark') {
      darkModeValue = true;
    } else if (themeMode == 'light') {
      darkModeValue = false;
    } else {
      // Auto mode - detect system theme
      if (context != null) {
        final brightness = MediaQuery.of(context).platformBrightness;
        darkModeValue = brightness == Brightness.dark;
      } else {
        // Fallback if context is not provided
        darkModeValue = false;
      }
    }

    userCache?.put(themeModeKey, themeModeValue);
    userCache?.put(darkModeKey, darkModeValue);

    emit(ChangeThemeState());
  }

  void changeState() {
    emit(HomeChangeState());
  }

  void updateAutoTheme(BuildContext context) {
    // Only update if we're currently in auto mode
    if (themeModeValue == 'auto') {
      final brightness = MediaQuery.of(context).platformBrightness;
      final newDarkModeValue = brightness == Brightness.dark;

      // Only emit state change if the value actually changed
      if (darkModeValue != newDarkModeValue) {
        darkModeValue = newDarkModeValue;
        userCache?.put(darkModeKey, darkModeValue);
        emit(ChangeThemeState());
      }
    }
  }

  //FavoriteDataSourceInterface favoriteDataSourceInterface = FavoriteDataSourceImplementation();

  // Future<bool?> isArticleBookmark({required BuildContext context, required int idArticle}) async {
  //   emit(BookMarkLoadingState());
  //   animationDialogLoading(context);
  //   final result = await storiesDataSource.articleBookmark(idArticle: idArticle);
  //   if (context.mounted) closeDialog(context);
  //
  //   return result.fold(
  //     (l) {
  //       emit(BookMarkErrorState(l.errMessage));
  //       customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
  //       return false;
  //     },
  //     (r) async {
  //       emit(BookMarkSuccessState());
  //       return r;
  //     },
  //   );
  // }
}
