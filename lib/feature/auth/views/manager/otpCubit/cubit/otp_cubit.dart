import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/device_id.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/reset_password_data_source.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';
import 'package:nets/feature/profile/views/manager/cubit/user_data_cubit.dart';
import 'package:nets/feature/profile/views/presentation/edit_profile_view.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPInitial()) {
    startTimer();
  }
  TextEditingController codeController = TextEditingController();

  Timer? timer;
  int _seconds = 120;

  ResetPasswordDataSourceInterface resetPasswordDataSourceInterface = ResetPasswordDataSourceImplementation();

  Future<void> verifyOtp({required BuildContext context, required String phone}) async {
    emit(OTPLoading());

    await resetPasswordDataSourceInterface.verifyOtp(otp: codeController.text, phone: phone).then((value) {
      value.fold(
        (l) {
          emit(OTPError(e: l.errMessage));
          customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
        },
        (r) async {
          ConstantsModels.loginModel = r;
          Constants.token = r.data?.token ?? '';
          userCacheValue = r;
          await userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          await DeviceUUid().initializeDeviceInfo(isAuth: true);
          await context.read<UserDataCubit>().getUserData();
            if (ConstantsModels.userDataModel?.data?.phone == null ||
                ConstantsModels.userDataModel?.data?.phone == '' ||
                ConstantsModels.userDataModel?.data?.profile?.firstName == null ||
                ConstantsModels.userDataModel?.data?.profile?.lastName == null) {
            context.navigateToPageWithReplacement(const EditProfileView(isFromLogin: true));
          } else {
            context.navigateToPageWithReplacement(const NavigationView());
          }

          // // // Save login credentials to cache
          // // await loginCache?.put(loginEmailKey, emailController.text);
          // // await loginCache?.put(loginPasswordKey, passwordController.text);
          // // if (verifyRegistrationEmail) {
          //   customShowToast(context, r.message ?? '');
          // // } else {
          // //   context.navigateToPage(ResetPasswordView(homeView: false, tempToken: r.data?.authKey));
          // // }

          emit(OTPSuccess());
        },
      );
    });
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
