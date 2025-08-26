import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/device_id.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/login_data_source.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit of(BuildContext context) => BlocProvider.of<LoginCubit>(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login({required BuildContext context}) async {
    emit(LoginLoading());
    Future.delayed(const Duration(seconds: 2), () {
      context.navigateToPage(const NavigationView());
    });

    await DeviceUUid().initializeDeviceInfo(isAuth: true);
    // await LoginDataSource.login(
    //   data: {
    //     'email': emailController.text,
    //     'password': passwordController.text,
    //     'device_token': Constants.fcmToken,
    //     'device_type': Constants.deviceType,
    //     'device_id': Constants.deviceId,
    //     'device_os': Constants.deviceOs,
    //     'device_version': Constants.deviceVersion,
    //   },
    // ).then((value) {
    //   value.fold(
    //     (l) {
    //       emit(LoginError(e: l.errMessage));
    //       log('register errors==> ${l.errMessage}');
    //       customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
    //     },
    //     (r) async {
    //       ConstantsModels.loginModel = r;
    //       Constants.token = r.data?.authKey ?? '';
    //       userCacheValue = r;
    //       await userCache?.put(userCacheKey, jsonEncode(r.toJson()));

    //       // Save login credentials to cache
    //       await loginCache?.put(loginEmailKey, emailController.text);
    //       await loginCache?.put(loginPasswordKey, passwordController.text);

    //       emit(LoginSuccess());
    //     },
    //   );
    // });
  }

  // Clear cached login credentials
  Future<void> clearCachedCredentials() async {
    await loginCache?.delete(loginEmailKey);
    await loginCache?.delete(loginPasswordKey);
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    emailController.dispose();
    return super.close();
  }
}
