import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/extensions.dart';
import 'package:nets/feature/auth/views/manager/sendOtpCubit/send_otp_cubit.dart';

import '../manager/otpCubit/cubit/otp_cubit.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({super.key, this.verifyRegistrationEmail = false, required this.email});
  final bool? verifyRegistrationEmail;
  final String email;
  @override
  OTPVerificationViewState createState() => OTPVerificationViewState();
}

class OTPVerificationViewState extends State<OTPVerificationView> {
  OTPCubit cubit = OTPCubit();
  SendOtpCubit sendOtpCubit = SendOtpCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendOtpCubit.sendOtp(context: context, email: widget.email);
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
      backgroundColor: darkModeValue ? AppColors.black : AppColors.white,
      appBar: customAppBar(context: context, title: 'Email Confirmation'.tr()),
      body: BlocProvider.value(
        value: cubit,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<OTPCubit, OTPState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // Main content area
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(AppImages.sendOtpImage),
                            Text(
                              'check_your_email'.tr(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 60,
                              child: Column(
                                children: [
                                  Text(
                                    'we’ve_send_the_code_to_your_email_address'.tr(),
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: darkModeValue ? AppColors.darkModeText : AppColors.cP50,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    widget.email,
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
                                length: 4,
                                appContext: context,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10.r),
                                  fieldHeight: 70.h,
                                  fieldWidth: 70.w,
                                  activeFillColor: darkModeValue ? AppColors.darkModeBackground : AppColors.white,
                                  inactiveColor: darkModeValue ? AppColors.darkModeBackground : Colors.grey.shade300,
                                  inactiveFillColor: darkModeValue ? AppColors.darkModeBackground : Colors.white,
                                  activeColor: AppColors.primaryColor,
                                  selectedFillColor: AppColors.primaryColor.withAlpha(20),
                                  selectedColor: AppColors.primaryColor,
                                ),
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: cubit.codeController,
                                hintCharacter: '-',
                                onCompleted: (v) async {
                                  await cubit.verifyOtp(context: context, verifyRegistrationEmail: widget.verifyRegistrationEmail ?? false);
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                },
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: cubit.resendCode,
                                  child: Text.rich(
                                    TextSpan(
                                      text: ' ${'resend_code'.tr()} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayMedium!.copyWith(color: darkModeValue ? AppColors.darkModeText : AppColors.cP50),
                                      children: [
                                        if (state is OTPTimerRunning)
                                          TextSpan(
                                            text: state.timerText,
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.primaryColor),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ].paddingDirectional(top: 24),
                        ),
                      ),
                    ),
                    // Send button at the bottom
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 20, top: 16),
                      child: CustomTextButton(
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        borderColor: AppColors.primaryColor,
                        borderRadius: 4,
                        state: state is OTPLoading,
                        childText: 'confirm'.tr(),
                        onPress: () async {
                          if (cubit.codeController.text.isEmpty) {
                            customShowToast(context, 'enter_otp_code'.tr(), showToastStatus: ShowToastStatus.error);
                            return;
                          } else {
                            await cubit.verifyOtp(context: context, verifyRegistrationEmail: widget.verifyRegistrationEmail ?? false);
                          }

                          // if (widget.verifyRegistrationEmail!) {
                          // } else {
                          //  // context.navigateToPageWithReplacement(ResetPasswordView());
                          // }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
