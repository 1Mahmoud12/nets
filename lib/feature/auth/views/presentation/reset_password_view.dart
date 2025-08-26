import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_images.dart';
import 'package:nets/core/utils/extensions.dart';

import '../manager/resetPasswordCubit/cubit/reset_password_cubit.dart';

class ResetPasswordView extends StatefulWidget {
  final bool homeView;
  final String? tempToken;

  const ResetPasswordView({super.key, required this.homeView, this.tempToken});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  ResetPasswordCubit cubit = ResetPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.black : AppColors.white,

      // persistentFooterButtons: [
      //   InkWell(
      //     onTap: () {
      //       context.navigateToPage(LoginView());
      //     },
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 20.0),
      //       child: Center(
      //         child: Text.rich(
      //           TextSpan(
      //             text: 'Remmember Password? '.tr(),
      //             style: Theme.of(context).textTheme.displayMedium!.copyWith(color: darkModeValue ? AppColors.darkModeText : AppColors.cP50),
      //             children: [TextSpan(text: 'login'.tr(), style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.primaryColor))],
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //       ),
      //     ),
      //   ),
      // ],
      appBar: customAppBar(context: context, title: 'reset_password'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocProvider.value(
              value: cubit,
              child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Image.asset(AppImages.sendOtpImage),

                      Text(
                        'change_password'.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryColor, fontSize: 20.sp),
                      ),
                      Text(
                        'change_password_instruction.'.tr(),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: darkModeValue ? AppColors.darkModeText : AppColors.cP50,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomTextFormField(
                        enable: state is! ResetPasswordLoading,
                        controller: cubit.newPasswordController,
                        hintText: '*******'.tr(),
                        nameField: 'new_password'.tr(),
                        password: true,
                        validator: cubit.validatePassword,
                      ),
                      CustomTextFormField(
                        enable: state is! ResetPasswordLoading,
                        controller: cubit.confirmPasswordController,
                        hintText: '*******'.tr(),
                        nameField: 'confirm_password'.tr(),
                        password: true,
                        validator: cubit.validateConfirmPassword,
                      ),
                      const SizedBox(height: 0),
                      CustomTextButton(
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        borderColor: AppColors.primaryColor,
                        borderRadius: 4,
                        state: state is ResetPasswordLoading,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.resetPassword(context: context, homeView: widget.homeView, tempToken: widget.tempToken).then((value) {});
                          }
                        },
                        childText: 'change'.tr(),
                      ),
                    ].paddingDirectional(top: 24),
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
