import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/splash/data/dataSource/splash_home_data_source.dart';

import '../../../../../core/network/local/cache.dart';

part 'splash_home_state.dart';

class SplashHomeCubit extends Cubit<SplashHomeState> {
  SplashHomeCubit() : super(SplashHomeInitial());

  static SplashHomeCubit of(BuildContext context) => BlocProvider.of<SplashHomeCubit>(context);

  SplashHomeDataSourceInterface splashHomeDataSourceInterface = SplashHomeDataSourceImplementation();
  Future<void> getSplashHome({required BuildContext context}) async {
    emit(SplashHomeLoading());
    final result = await splashHomeDataSourceInterface.getSplashHome();

    result.fold(
      (l) {
        emit(SplashHomeError(e: l.errMessage));
        // log('getSplashHome Errors==> ${l.errMessage}');
        //  customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
      },
      (r) async {
        ConstantsModels.splashHomeModel = r;
        dataCache?.put(splashHomeModelKey, jsonEncode(r.toJson()));
        emit(SplashHomeSuccess());
      },
    );
  }
}
