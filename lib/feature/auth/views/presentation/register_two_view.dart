// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nets/core/component/buttons/custom_text_button.dart';
// import 'package:nets/core/component/fields/custom_text_form_field.dart';
// import 'package:nets/core/component/phone_field_widget.dart';
// import 'package:nets/core/utils/extensions.dart';
// import 'package:nets/core/utils/navigate.dart';
// import 'package:nets/feature/auth/views/manager/registerCubit/cubit/register_cubit.dart';
// import 'package:nets/feature/auth/views/presentation/login_view.dart';
// import 'package:nets/feature/auth/views/presentation/widgets/link_text.dart';

// class RegisterTwoView extends StatefulWidget {
//   final RegisterCubit registerCubit;

//   const RegisterTwoView({super.key, required this.registerCubit});

//   @override
//   State<RegisterTwoView> createState() => _RegisterTwoViewState();
// }

// class _RegisterTwoViewState extends State<RegisterTwoView> {
//   final _formKey = GlobalKey<FormState>();
//   late RegisterCubit registerCubit;

//   @override
//   void initState() {
//     registerCubit = widget.registerCubit;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(toolbarHeight: 0),
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
//                     children: [
//                       Align(
//                         alignment: AlignmentDirectional.centerStart,
//                         child: InkWell(
//                           onTap: () => Navigator.pop(context),
//                           child: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
//                         ),
//                       ),
//                    //   Center(child: SvgPicture.asset(AppIcons.logoAppIc)),
//                       Text('complete_your_account_info'.tr(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.firstNameController,
//                         hintText: ' '.tr(),
//                         nameField: 'first_name'.tr(),
//                         textInputType: TextInputType.name,
//                       ),
//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.lastNameController,
//                         hintText: ' '.tr(),
//                         nameField: 'last_name'.tr(),
//                         textInputType: TextInputType.name,
//                       ),

//                       CustomTextFormField(
//                         enable: state is! RegisterLoading,
//                         controller: registerCubit.emailController,
//                         hintText: ' '.tr(),
//                         nameField: 'nationality'.tr(),
//                         textInputType: TextInputType.emailAddress,
//                       ),
//                       PhoneFieldWidget(
//                         hintText: 'enter_your_phone'.tr(),
//                         nameField: 'phone_number'.tr(),

//                         onChange: (p0) {
//                           registerCubit.phoneController.text = p0;
//                         },
//                       ),
//                       CustomTextButton(
//                         state: state is RegisterLoading,
//                         onPress: () {
//                           if (_formKey.currentState!.validate()) {
//                             registerCubit.register(context: context);
//                           }
//                         },
//                         childText: 'create_account'.tr(),
//                       ),
//                       Center(
//                         child: LinkText(
//                           mainText: 'already_have_an_account'.tr(),
//                           linkText: 'login'.tr(),
//                           onLinkTap: () {
//                             context.navigateToPage(const LoginView());
//                           },
//                         ),
//                       ),
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
