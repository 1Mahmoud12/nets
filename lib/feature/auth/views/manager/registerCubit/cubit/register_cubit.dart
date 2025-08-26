import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/device_id.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/data/dataSource/register_data_source.dart';
import 'package:nets/feature/auth/views/presentation/otp_view.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit of(BuildContext context) => BlocProvider.of<RegisterCubit>(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isTermsConditions = false;

  void changeTermsConditions() {
    isTermsConditions = !isTermsConditions;
    emit(ChangeTermsConditionsState());
  }

  Future<void> register({required BuildContext context}) async {
    emit(RegisterLoading());
    await DeviceUUid().initializeDeviceInfo(isAuth: true);

    await RegisterDataSource.register(
      data: {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'device_token': Constants.fcmToken,
        'device_type': Constants.deviceType,
        'device_id': Constants.deviceId,
        'device_os': Constants.deviceOs,
        'device_version': Constants.deviceVersion,
        'agree': isTermsConditions,
      },
    ).then((value) {
      value.fold(
        (l) {
          emit(RegisterError(e: l.errMessage));
          log('register errors==> ${l.errMessage}');
          customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
        },
        (r) async {
          context.navigateToPage(OTPVerificationView(verifyRegistrationEmail: true, email: emailController.text));
          emit(RegisterSuccess());
        },
      );
    });
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
