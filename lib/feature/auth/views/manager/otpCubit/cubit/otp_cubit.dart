import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/reset_password_data_source.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/feature/auth/views/presentation/reset_password_view.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPInitial()) {
    _startTimer();
  }
  TextEditingController codeController = TextEditingController();

  Timer? _timer;
  int _seconds = 120;

  ResetPasswordDataSourceInterface resetPasswordDataSourceInterface = ResetPasswordDataSourceImplementation();

  Future<void> verifyOtp({required BuildContext context, required bool verifyRegistrationEmail}) async {
    emit(OTPLoading());
    await resetPasswordDataSourceInterface.verifyOtp(otp: codeController.text, verifyRegistrationEmail: verifyRegistrationEmail).then((value) {
      value.fold(
        (l) {
          emit(OTPError(e: l.errMessage));
          customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
        },
        (r) async {
          if (verifyRegistrationEmail) {
            customShowToast(context, r.message ?? '');
            context.navigateToPage(const LoginView());
          } else {
            context.navigateToPage(ResetPasswordView(homeView: false, tempToken: r.data?.authKey));
          }

          emit(OTPSuccess());
        },
      );
    });
  }

  void _startTimer() {
    // ignore: prefer_single_quotes
    emit(OTPTimerRunning("02:00"));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    _startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
