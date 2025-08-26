import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/reset_password_data_source.dart';
import 'package:nets/feature/auth/views/presentation/otp_view.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  ResetPasswordDataSourceInterface resetPasswordDataSource = ResetPasswordDataSourceImplementation();
  final emailController = TextEditingController();

  Future<void> forgetPassword({required BuildContext context}) async {
    emit(ForgotPasswordLoading());

    context.navigateToPage(OTPVerificationView(email: emailController.text));
    emit(VerifyOtpSuccess());
  }

  // Future<void> verifyOtp({required BuildContext context}) async {
  //   emit(VerifyOtpLoading());
  //
  //   await resetPasswordDataSource.otp(email: emailController.text).then((value) {
  //     value.fold(
  //       (l) {
  //         emit(VerifyOtpError(l.errMessage));
  //         log('register errors==> ${l.errMessage}');
  //         customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
  //       },
  //       (r) async {
  //         context.navigateToPage(ResetPasswordView());
  //
  //         emit(VerifyOtpSuccess());
  //       },
  //     );
  //   });
  // }
}
