import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/reset_password_data_source.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPInitial()) {
    startTimer();
  }
  TextEditingController codeController = TextEditingController();

  Timer? timer;
  int _seconds = 120;

  ResetPasswordDataSourceInterface resetPasswordDataSourceInterface = ResetPasswordDataSourceImplementation();

  Future<void> verifyOtp({required BuildContext context}) async {
    emit(OTPLoading());
    userCacheValue = LoginModel(data: Data(phone: '01127200000', email: 'test@gmail.com', authKey: 'asdasd'));
    await userCache?.put(userCacheKey, jsonEncode(LoginModel(data: Data(phone: '01127200000', email: 'test@gmail.com', authKey: 'asdasd')).toJson()));

    context.navigateToPage(const NavigationView());

    // await resetPasswordDataSourceInterface.verifyOtp(otp: codeController.text).then((value) {
    //   value.fold(
    //     (l) {
    //       emit(OTPError(e: l.errMessage));
    //       // customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
    //     },
    //     (r) async {
    //       // if (verifyRegistrationEmail) {
    //       customShowToast(context, r.message ?? '');
    //       context.navigateToPage(const LoginView());
    //       // } else {
    //       //   context.navigateToPage(ResetPasswordView(homeView: false, tempToken: r.data?.authKey));
    //       // }
    //
    //       emit(OTPSuccess());
    //     },
    //   );
    // });
  }

  void startTimer() {
    timer?.cancel();
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    // ignore: prefer_single_quotes
    emit(OTPTimerRunning("$minutes:$seconds"));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        emit(OTPExpired());
      } else {
        _seconds--;
        final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
        final seconds = (_seconds % 60).toString().padLeft(2, '0');
        // ignore: prefer_single_quotes
        emit(OTPTimerRunning("$minutes:$seconds"));
      }
    });
  }

  void resendCode() {
    _seconds = 120;
    startTimer();
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
