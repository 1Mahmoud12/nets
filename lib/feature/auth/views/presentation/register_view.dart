// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nets/core/component/buttons/custom_text_button.dart';
// import 'package:nets/core/component/custom_app_bar.dart';
// import 'package:nets/core/component/custom_check_button.dart';
// import 'package:nets/core/component/fields/custom_text_form_field.dart';
// import 'package:nets/core/component/phone_field_widget.dart';
// import 'package:nets/core/network/local/cache.dart';
// import 'package:nets/core/themes/colors.dart';
// import 'package:nets/core/utils/constant_gaping.dart';
// import 'package:nets/core/utils/custom_show_toast.dart';
// import 'package:nets/core/utils/extensions.dart';
// import 'package:nets/core/utils/navigate.dart';
// import 'package:nets/feature/auth/views/manager/registerCubit/cubit/register_cubit.dart';
// import 'package:nets/feature/auth/views/presentation/login_view.dart';
// import 'package:nets/feature/auth/views/presentation/widgets/link_text.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final RegisterCubit registerCubit = RegisterCubit();
//   final _formKey = GlobalKey<FormState>();

//   // Email validation regex pattern
//   final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

//   // Email validator
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'email_required'.tr();
//     }
//     if (!_emailRegExp.hasMatch(value)) {
//       return 'email_invalid'.tr();
//     }
//     return null;
//   }

//   // Password validator
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'password_required'.tr();
//     }
//     if (value.length < 6) {
//       return 'password_length'.tr();
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: darkModeValue ? AppColors.black : AppColors.white,
//       appBar: customAppBar(context: context, title: 'create_account'.tr()),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: BlocProvider.value(
//               value: registerCubit,
//               child: BlocBuilder<RegisterCubit, RegisterState>(
//                 builder: (context, state) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AuthContent(
//                         subTitle: 'personalized_experience_message'.tr(),
//                         title: 'create_new_account'.tr(),
//                       ),

//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.nameController,
//                         hintText: 'Enter your name'.tr(),
//                         nameField: 'name'.tr(),
//                         enableLtr: context.locale.languageCode == 'ar',
//                         textInputType: TextInputType.emailAddress,
//                       ),

//                       PhoneFieldWidget(
//                         enableLtr: true,
//                         hintText: 'XXXXXXXXX'.tr(),
//                         nameField: 'phone_number'.tr(),
//                         enable: state is! RegisterLoading,
//                         // textDirection: ui.TextDirection.ltr,
//                         onChange: (p0) {
//                           if (state is! RegisterLoading) {
//                             registerCubit.phoneController.text = p0;
//                           }
//                         },
//                       ),
//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.passwordController,
//                         hintText: '*******'.tr(),
//                         nameField: 'password'.tr(),
//                         password: true,
//                         validator: _validatePassword,
//                       ),
//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.confirmPasswordController,
//                         hintText: '*******'.tr(),
//                         nameField: 'confirm_password'.tr(),
//                         password: true,
//                         validator: _validatePassword,
//                       ),
//                       //  h10,
//                       CustomCheckButton(
//                         isChecked: registerCubit.isTermsConditions,
//                         onChanged:
//                             state is RegisterLoading
//                                 ? null
//                                 : (value) => setState(
//                                   () => registerCubit.isTermsConditions = value,
//                                 ),
//                         label: 'accept_terms'.tr(),
//                         checkedColor: AppColors.primaryColor,

//                         size: 20,
//                       ),
//                       //  h10,
//                       CustomTextButton(
//                         state: state is RegisterLoading,
//                         onPress: () {
//                           if (_formKey.currentState!.validate()) {
//                             if (registerCubit.passwordController.text ==
//                                 registerCubit.confirmPasswordController.text) {
//                               if (registerCubit.isTermsConditions) {
//                                 registerCubit.register(context: context);
//                               } else {
//                                 customShowToast(context, 'accept_terms'.tr());
//                               }
//                             } else {
//                               customShowToast(
//                                 context,
//                                 'password_not_match'.tr(),
//                               );
//                             }
//                           }
//                         },
//                         backgroundColor: AppColors.primaryColor,
//                         colorText: Colors.white,
//                         borderColor: AppColors.primaryColor,
//                         borderRadius: 4,
//                         child: Text(
//                           'create_account'.tr(),
//                           style: Theme.of(
//                             context,
//                           ).textTheme.displayMedium?.copyWith(
//                             fontSize: 16.sp,
//                             color:
//                                 (darkModeValue
//                                     ? AppColors.darkModeText
//                                     : AppColors.white),
//                             fontWeight: FontWeight.w400,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           const Expanded(
//                             child: Divider(color: AppColors.cBorderButtonColor),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8.0,
//                             ),
//                             child: Text(
//                               'or'.tr(),
//                               style: Theme.of(
//                                 context,
//                               ).textTheme.displayMedium?.copyWith(
//                                 color:
//                                     darkModeValue
//                                         ? AppColors.darkModeText
//                                         : AppColors.black,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Divider(
//                               color:
//                                   darkModeValue
//                                       ? AppColors.darkModeText
//                                       : AppColors.cBorderButtonColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       // CustomTextButton(
//                       //   state: state is RegisterLoading,
//                       //
//                       //   borderRadius: 4,
//                       //   onPress:
//                       //       state is RegisterLoading
//                       //           ? null
//                       //           : () {
//                       //             customShowToast(context, 'coming_soon'.tr(), showToastPosition: ShowToastPosition.top);
//                       //           },
//                       //   backgroundColor: darkModeValue ? AppColors.darkModeBackground : AppColors.white,
//                       //   child: Row(
//                       //     children: [
//                       //       Image.asset(AppImages.google, width: 24, height: 24),
//                       //       const SizedBox(width: 8),
//                       //       Text(
//                       //         'sign_in_with_google'.tr(),
//                       //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       //           fontSize: 15.sp,
//                       //           color: darkModeValue ? AppColors.darkModeText : AppColors.black,
//                       //           fontWeight: FontWeight.w400,
//                       //         ),
//                       //         textAlign: TextAlign.center,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       // CustomTextButton(
//                       //   borderRadius: 4,
//                       //   onPress:
//                       //       state is RegisterLoading
//                       //           ? null
//                       //           : () {
//                       //             customShowToast(context, 'coming_soon'.tr(), showToastPosition: ShowToastPosition.top);
//                       //           },
//                       //   backgroundColor: darkModeValue ? AppColors.darkModeBackground : AppColors.white,
//                       //   child: Row(
//                       //     children: [
//                       //       Image.asset(AppImages.apple, width: 24, height: 24),
//                       //       const SizedBox(width: 8),
//                       //       Text(
//                       //         'sign_in_with_apple'.tr(),
//                       //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       //           fontSize: 15.sp,
//                       //           color: darkModeValue ? AppColors.darkModeText : AppColors.black,
//                       //           fontWeight: FontWeight.w400,
//                       //         ),
//                       //         textAlign: TextAlign.center,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       Center(
//                         child: LinkText(
//                           mainText: 'already_have_an_account'.tr(),
//                           linkText: 'sign_in_now'.tr(),
//                           onLinkTap:
//                               state is RegisterLoading
//                                   ? () {} // No-op function when loading
//                                   : () {
//                                     context.navigateToPage(const LoginView());
//                                   },
//                         ),
//                       ),
//                       h20,
//                     ].paddingDirectional(top: 24),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
