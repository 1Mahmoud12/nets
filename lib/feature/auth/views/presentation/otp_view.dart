import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/extensions.dart';
import 'package:nets/feature/auth/views/manager/sendOtpCubit/send_otp_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/constant_gaping.dart';
import '../manager/otpCubit/cubit/otp_cubit.dart';
import '../manager/loginCubit/cubit/login_cubit.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({super.key, required this.phone});
  // final bool? verifyRegistrationEmail;
  final String phone;
  @override
  OTPVerificationViewState createState() => OTPVerificationViewState();
}

class OTPVerificationViewState extends State<OTPVerificationView> {
  OTPCubit cubit = OTPCubit();
  SendOtpCubit sendOtpCubit = SendOtpCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // sendOtpCubit.sendOtp(context: context, phone: widget.phone);
    });
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    sendOtpCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.black : AppColors.scaffoldBackGround,
      // appBar: customAppBar(context: context, title: 'Email Confirmation'.tr()),
      body: BlocProvider.value(
        value: cubit,
        child: SafeArea(
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, loginState) {
              if (loginState is LoginSuccess) {
                customShowToast(context, 'OTP has been resent successfully');
              } else if (loginState is LoginError) {
                // Error is already handled in login cubit
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<OTPCubit, OTPState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Main content area
                        Column(
                          children: [
                            SvgPicture.asset(AppIcons.appLogo),
                            Text(
                              'verification_code'.tr(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 60,
                              child: Column(
                                children: [
                                  Text(
                                    'A_verification_code_has_been_sent_to'.tr(),
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: darkModeValue ? AppColors.darkModeText : AppColors.cP50,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    widget.phone,
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: darkModeValue ? AppColors.darkModeText : AppColors.cP50,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            Directionality(
                              textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                              child: PinCodeTextField(
                                autoDisposeControllers: false,
                                length: 6,
                                appContext: context,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fieldHeight: 58.h,
                                  fieldWidth: 50.w,
                                  activeFillColor: AppColors.white,
                                  inactiveColor: AppColors.white,
                                  inactiveFillColor: darkModeValue ? AppColors.darkModeBackground : Colors.white,
                                  activeColor: AppColors.greyG100,
                                  selectedFillColor: AppColors.white.withAlpha(20),
                                  selectedColor: AppColors.primaryColor,
                                ),
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: cubit.codeController,
                                // hintCharacter: '-',
                                onCompleted: (v) async {
                                  await cubit.verifyOtp(context: context, phone: widget.phone);
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                },
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                            ),
                          ].paddingDirectional(top: 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state is OTPTimerRunning
                                  ? state.timerText
                                  : state is OTPExpired
                                  ? '00:00'
                                  : '02:00',
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.primaryColor),
                            ),
                            w5,
                            Icon(Icons.access_time, color: AppColors.greyG500, size: 18.sp),
                          ],
                        ),
                        h15,
                        // Send button at the bottom
                        CustomTextButton(
                          height: 45,
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                          borderColor: AppColors.primaryColor,
                          borderRadius: 12,
                          state: state is OTPLoading,
                          childText: 'confirm'.tr(),
                          onPress: () async {
                            if (cubit.codeController.text.isEmpty) {
                              customShowToast(context, 'enter_otp_code'.tr(), showToastStatus: ShowToastStatus.error);
                              return;
                            } else {
                              await cubit.verifyOtp(context: context, phone: widget.phone);
                            }

                            // if (widget.verifyRegistrationEmail!) {
                            // } else {
                            //  // context.navigateToPageWithReplacement(ResetPasswordView());
                            // }
                          },
                        ),
                        h15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' ${'resend_code'.tr()} ',
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium!.copyWith(color: darkModeValue ? AppColors.darkModeText : AppColors.textColor),
                            ),

                            GestureDetector(
                              onTap:
                                  state is OTPTimerRunning
                                      ? null
                                      : () async {
                                        try {
                                          // Get login cubit if available
                                          final loginCubit = context.read<LoginCubit>();

                                          // Extract phone number from full phone (remove country code)
                                          // widget.phone is like "+9665xxxxxxxx" or "+201124980094"
                                          String phoneNumber = widget.phone;

                                          // Try to find and remove country code
                                          // Common country codes: +966, +2, +971
                                          if (phoneNumber.startsWith('+966')) {
                                            loginCubit.countryCode = '+966';
                                            phoneNumber = phoneNumber.substring(4);
                                          } else if (phoneNumber.startsWith('+971')) {
                                            loginCubit.countryCode = '+971';
                                            phoneNumber = phoneNumber.substring(4);
                                          } else if (phoneNumber.startsWith('+2')) {
                                            loginCubit.countryCode = '+2';
                                            phoneNumber = phoneNumber.substring(2);
                                          }

                                          // Set the phone number in login cubit
                                          loginCubit.loginPhoneController.text = phoneNumber;

                                          // Resend OTP via login cubit (doesn't navigate)
                                          await loginCubit.resendOtp(context: context);

                                          // Clear OTP code field and reset timer
                                          cubit.codeController.clear();
                                          cubit.resendCode();
                                        } catch (e) {
                                          // Fallback to just resetting timer if login cubit not available
                                          cubit.resendCode();
                                        }
                                      },
                              child: Text(
                                ' ${'resend'.tr()} ',
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color:
                                      state is OTPTimerRunning
                                          ? AppColors.greyG500
                                          : darkModeValue
                                          ? AppColors.darkModeText
                                          : AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
