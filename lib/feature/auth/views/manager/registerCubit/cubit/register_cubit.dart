import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

import '../../../../data/models/login_model.dart';

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
    userCacheValue = LoginModel(data: Data(phone: '01127200000', email: 'test@gmail.com', authKey: 'asdasd'));
    await userCache?.put(userCacheKey, jsonEncode(LoginModel(data: Data(phone: '01127200000', email: 'test@gmail.com', authKey: 'asdasd')).toJson()));

    Future.delayed(const Duration(seconds: 2), () {
      context.navigateToPage(const NavigationView());
    });
    // await RegisterDataSource.register(
    //   data: {
    //     'name': nameController.text,
    //     'phone': phoneController.text,
    //     'email': emailController.text,
    //     'password': passwordController.text,
    //     'password_confirmation': confirmPasswordController.text,
    //     'device_token': Constants.fcmToken,
    //     'device_type': Constants.deviceType,
    //     'device_id': Constants.deviceId,
    //     'device_os': Constants.deviceOs,
    //     'device_version': Constants.deviceVersion,
    //     'agree': isTermsConditions,
    //   },
    // ).then((value) {
    //   value.fold(
    //     (l) {
    //       emit(RegisterError(e: l.errMessage));
    //       log('register errors==> ${l.errMessage}');
    //       customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
    //     },
    //     (r) async {
    //       context.navigateToPage(OTPVerificationView(verifyRegistrationEmail: true, email: emailController.text));
    //       emit(RegisterSuccess());
    //     },
    //   );
    // });
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
