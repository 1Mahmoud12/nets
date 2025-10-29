import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constant_gaping.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/views/manager/loginCubit/cubit/login_cubit.dart';
import 'package:nets/feature/navigation/view/presentation/navigation_view.dart';

import 'otp_view.dart';
import 'widgets/phone_number_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginCubit loginCubit = LoginCubit();
  final _formKey = GlobalKey<FormState>();

  // // Email validation regex pattern
  // final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  // // Email validator
  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'name is required'.tr();
  //   }

  //   return null;
  // }

  // // Password validator
  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'password_required'.tr();
  //   }
  //   if (value.length < 6) {
  //     return 'password_length'.tr();
  //   }
  //   return null;
  // }

  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCachedCredentials();
  }

  Future<void> _loadCachedCredentials() async {
    final cachedEmail = loginCache?.get(loginEmailKey);
    final cachedPassword = loginCache?.get(loginPasswordKey);

    if (cachedEmail != null && cachedPassword != null) {
      setState(() {
        loginCubit.emailController.text = cachedEmail;
        loginCubit.passwordController.text = cachedPassword;
      });
    }
  }

  // Google sign-in is currently not used

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: darkModeValue ? AppColors.black : AppColors.white,
        // appBar: customAppBar(context: context, title: 'login'.tr()),
        appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: darkModeValue ? AppColors.black : AppColors.white),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: BlocProvider.value(
                value: loginCubit,
                child: BlocListener<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    } else if (state is LoginSuccess) {
                      setState(() {
                        isLoading = false;
                      });
                      context.navigateToPageWithReplacement(const NavigationView());

                      //   customShowToast(context, 'Success');
                    } else if (state is LoginError) {
                      setState(() {
                        isLoading = false;
                      });
                      //  customShowToast(context, state.e.errMessage, showToastStatus: ShowToastStatus.error);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthContent(subTitle: 'login_to_continue'.tr(), title: 'welcome_back'.tr()),
                      SizedBox(height: 32.h),

                      PhoneNumberField(initialCountryCode: loginCubit.countryCode, controller: loginCubit.loginPhoneController),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     CustomTextFormField(
                      //       enable: !isLoading,
                      //       controller: loginCubit.passwordController,
                      //       hintText: '*******'.tr(),
                      //       nameField: 'password'.tr(),
                      //       password: true,
                      //       validator: _validatePassword,
                      //     ),
                      //     const SizedBox(height: 10),
                      //     InkWell(
                      //       onTap:
                      //           () => context.navigateToPage(
                      //             ForgotPasswordView(),
                      //           ),
                      //       child: Text(
                      //         'forgot_password'.tr(),
                      //         style: Theme.of(context).textTheme.displayMedium
                      //             ?.copyWith(color: AppColors.primaryColor),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 24.h),
                      CustomTextButton(
                        state: isLoading,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        borderColor: AppColors.primaryColor,
                        borderRadius: 12,
                        height: 48.h,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // loginCubit.login(context: context);
                            context.navigateToPage(
                              BlocProvider.value(value: loginCubit, child: OTPVerificationView(phone: loginCubit.loginPhoneController.text)),
                            );
                          }
                        },
                        childText: 'send_otp'.tr(),
                      ),

                      // Row(
                      //   children: [
                      //     const Expanded(
                      //       child: Divider(color: AppColors.cBorderButtonColor),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 8.0,
                      //       ),
                      //       child: Text(
                      //         'or'.tr(),
                      //         style: Theme.of(
                      //           context,
                      //         ).textTheme.displayMedium?.copyWith(
                      //           color:
                      //               darkModeValue
                      //                   ? AppColors.darkModeText
                      //                   : AppColors.black,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // CustomTextButton(
                      //   borderRadius: 4,
                      //   onPress: () {
                      //     customShowToast(context, 'coming_soon'.tr(), showToastPosition: ShowToastPosition.top);
                      //   }, //isGoogleLoading ? null : _handleGoogleSignIn,
                      //   backgroundColor: darkModeValue ? AppColors.darkModeBackground : AppColors.white,
                      //   child:
                      //       isGoogleLoading
                      //           ? SizedBox(
                      //             width: 20,
                      //             height: 20,
                      //             child: CircularProgressIndicator(
                      //               strokeWidth: 2,
                      //               valueColor: AlwaysStoppedAnimation<Color>(darkModeValue ? AppColors.darkModeText : AppColors.black),
                      //             ),
                      //           )
                      //           : Row(
                      //             children: [
                      //               Image.asset(AppImages.google, width: 24, height: 24),
                      //               const SizedBox(width: 8),
                      //               Text(
                      //                 'sign_in_with_google'.tr(),
                      //                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      //                   fontSize: 15.sp,
                      //                   color: darkModeValue ? AppColors.darkModeText : AppColors.black,
                      //                   fontWeight: FontWeight.w400,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ],
                      //           ),
                      // ),
                      // if (Platform.isIOS)
                      //   CustomTextButton(
                      //     borderRadius: 4,
                      //     onPress: () async {
                      //       customShowToast(context, 'coming_soon'.tr(), showToastPosition: ShowToastPosition.top);
                      //       // await GoogleSignInService.signInWithApple().then((value) {
                      //       //   logger.i(value);
                      //       // });
                      //     },
                      //     backgroundColor: darkModeValue ? AppColors.darkModeBackground : AppColors.white,
                      //     child: Row(
                      //       children: [
                      //         Image.asset(AppImages.apple, width: 24, height: 24),
                      //         const SizedBox(width: 8),
                      //         Text(
                      //           'sign_in_with_apple'.tr(),
                      //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      //             fontSize: 15.sp,
                      //             color: darkModeValue ? AppColors.darkModeText : AppColors.black,
                      //             fontWeight: FontWeight.w400,
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   Center(
                      //     child: LinkTextColumn(
                      //       mainText: 'no_account'.tr(),
                      //       linkText: 'create_new_account'.tr(),
                      //       onLinkTap: () {
                      //         context.navigateToPage(const RegisterView());
                      //       },
                      //     ),
                      //   ),
                      //   h20,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthContent extends StatelessWidget {
  const AuthContent({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(AppIcons.appLogo, width: 56.w, height: 56.h)),
        h8,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('login'.tr(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400)),
        ),
        h8,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'enter_your_phone_number'.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.darkModeText : AppColors.textColor),
          ),
          // textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
