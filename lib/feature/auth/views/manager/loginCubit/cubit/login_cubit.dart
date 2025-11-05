import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/login_data_source.dart';
import 'package:nets/feature/auth/views/presentation/otp_view.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit of(BuildContext context) => BlocProvider.of<LoginCubit>(context);
  TextEditingController loginPhoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String countryCode = '+966';
  // CountryFlag country = countriesflage.first;
  Future<void> login({required BuildContext context, bool navigateToOtp = true}) async {
    emit(LoginLoading());

    // Combine country code with phone number
    // Remove leading '0' only for Saudi Arabia (+966): 05xxxxxxxx -> +9665xxxxxxxx
    // For other countries, keep the leading zero as is
    String phoneNumber = loginPhoneController.text;
    if (countryCode == '+966' && phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }
    final fullPhoneNumber = countryCode + phoneNumber;

    await LoginDataSource.login(data: {'phone': fullPhoneNumber}).then((value) {
      value.fold(
        (l) {
          emit(LoginError(e: l.errMessage));
          log('login errors==> ${l.errMessage}');
          customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
        },
        (r) async {
          // Navigate to OTP view with full phone number for display (only if not resending)
          if (navigateToOtp) {
            context.navigateToPage(BlocProvider.value(value: this, child: OTPVerificationView(phone: fullPhoneNumber)));
          }

          emit(LoginSuccess());
        },
      );
    });
  }

  // Resend OTP - same as login but doesn't navigate
  Future<void> resendOtp({required BuildContext context}) async {
    await login(context: context, navigateToOtp: false);
  }

  // Clear cached login credentials
  Future<void> clearCachedCredentials() async {
    await loginCache?.delete(loginEmailKey);
    await loginCache?.delete(loginPasswordKey);
  }

  @override
  Future<void> close() {
    loginPhoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    return super.close();
  }
}
