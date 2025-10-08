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

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({super.key});
  // final bool? verifyRegistrationEmail;
  // final String email;
  @override
  OTPVerificationViewState createState() => OTPVerificationViewState();
}

class OTPVerificationViewState extends State<OTPVerificationView> {
  OTPCubit cubit = OTPCubit();
  SendOtpCubit sendOtpCubit = SendOtpCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // sendOtpCubit.sendOtp(context: context, email: widget.email);
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
      // appBar: customAppBar(context: context, title: 'Email Confirmation'.tr()),
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
                    Column(
                      children: [
                        SvgPicture.asset(AppIcons.appLogo),
                        Text(
                          'Verification Code'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Column(
                            children: [
                              Text(
                                'A verification code has been sent to '.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium!.copyWith(
                                  color:
                                      darkModeValue
                                          ? AppColors.darkModeText
                                          : AppColors.cP50,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                              Text(
                                '123456789',
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium!.copyWith(
                                  color:
                                      darkModeValue
                                          ? AppColors.darkModeText
                                          : AppColors.cP50,
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
                          textDirection:
                              context.locale.languageCode == 'ar'
                                  ? ui.TextDirection.rtl
                                  : ui.TextDirection.ltr,
                          child: PinCodeTextField(
                            length: 4,
                            appContext: context,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10.r),
                              fieldHeight: 58.h,
                              fieldWidth: 58.w,
                              activeFillColor: AppColors.greyG200,
                              inactiveColor: AppColors.greyG200,
                              inactiveFillColor:
                                  darkModeValue
                                      ? AppColors.darkModeBackground
                                      : Colors.white,
                              activeColor: AppColors.primaryColor,
                              selectedFillColor: AppColors.primaryColor
                                  .withAlpha(20),
                              selectedColor: AppColors.primaryColor,
                            ),
                            animationDuration: const Duration(
                              milliseconds: 300,
                            ),
                            enableActiveFill: true,
                            controller: cubit.codeController,
                            // hintCharacter: '-',
                            onCompleted: (v) async {
                              // await cubit.verifyOtp(context: context, verifyRegistrationEmail: widget.verifyRegistrationEmail ?? false);
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

                    Text(
                      '2:00',
                      style: Theme.of(context).textTheme.displayMedium!
                          .copyWith(color: AppColors.primaryColor),
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
                          customShowToast(
                            context,
                            'enter_otp_code'.tr(),
                            showToastStatus: ShowToastStatus.error,
                          );
                          return;
                        } else {
                          // await cubit.verifyOtp(context: context, verifyRegistrationEmail: widget.verifyRegistrationEmail ?? false);
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
                        TextButton(
                          onPressed: cubit.resendCode,
                          child: Text.rich(
                            TextSpan(
                              text: ' ${'resend_code'.tr()} ',
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium!.copyWith(
                                color:
                                    darkModeValue
                                        ? AppColors.darkModeText
                                        : AppColors.cP50,
                              ),
                              children: const [],
                            ),
                          ),
                        ),
                      ],
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
