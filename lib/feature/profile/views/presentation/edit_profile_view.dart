import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/network/end_points.dart';

import '../../../../core/network/local/cache.dart';
import '../manager/cubit/user_data_cubit.dart';
import 'widgets/address_information_widget.dart';
import 'widgets/contact_information_widget.dart';
import 'widgets/personal_information_widget.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late UserDataCubit userDataCubit;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  final mobile1Ctrl = TextEditingController();
  final mobile2Ctrl = TextEditingController();
  final officePhoneCtrl = TextEditingController();
  final poBoxCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  final facebookCtrl = TextEditingController();
  final twitterCtrl = TextEditingController();
  final instagramCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();

  final streetHomeCtrl = TextEditingController();
  final buildingHomeCtrl = TextEditingController();
  final officeNumberHomeCtrl = TextEditingController();

  final streetOfficeCtrl = TextEditingController();
  final buildingOfficeCtrl = TextEditingController();
  final officeNumberOfficeCtrl = TextEditingController();

  final otherDetailsCtrl = TextEditingController();

  final mobiles = <TextEditingController>[];
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    userDataCubit = UserDataCubit();
    mobiles.addAll([mobile1Ctrl]);
    _loadUserData();
  }

  void _loadUserData() {
    userDataCubit.getUserData();
  }

  void _initializeFields() {
    final userData = ConstantsModels.userDataModel?.data;
    if (userData == null) return;

    final profile = userData.profile;
    if (profile != null) {
      firstNameCtrl.text = profile.firstName ?? '';
      lastNameCtrl.text = profile.lastName ?? '';
      emailCtrl.text = profile.email ?? '';
      websiteCtrl.text = profile.website ?? '';
      zipCtrl.text = profile.zipCode ?? '';
      streetOfficeCtrl.text = profile.streetName ?? '';
      buildingOfficeCtrl.text = profile.buildingNumber ?? '';
      officeNumberOfficeCtrl.text = profile.streetNumber ?? '';
      otherDetailsCtrl.text = profile.additionalInformation ?? '';

      // Set image URL - if it's a relative path, prepend base URL
      if (profile.image != null && profile.image!.isNotEmpty) {
        if (profile.image!.startsWith('http://') || profile.image!.startsWith('https://')) {
          profileImageUrl = profile.image;
        } else {
          // If it's a relative path, prepend the domain
          profileImageUrl = '${EndPoints.domain}${profile.image!.startsWith('/') ? '' : '/'}${profile.image}';
        }
      }
      setState(() {}); // Update UI to show image
    }

    // Initialize phones
    if (userData.phones != null && userData.phones!.isNotEmpty) {
      for (int i = 0; i < userData.phones!.length; i++) {
        final phone = userData.phones![i];
        if (i == 0) {
          mobile1Ctrl.text = phone.phone ?? '';
        } else if (i == 1) {
          if (mobiles.length < 2) {
            mobiles.add(mobile2Ctrl);
          }
          mobile2Ctrl.text = phone.phone ?? '';
        } else if (phone.type?.toLowerCase() == 'office') {
          officePhoneCtrl.text = phone.phone ?? '';
        }
      }
    }

    // Initialize social links
    if (userData.socialLinks != null) {
      for (final socialLink in userData.socialLinks!) {
        switch (socialLink.platform?.toLowerCase()) {
          case 'facebook':
            facebookCtrl.text = socialLink.url ?? '';
            break;
          case 'twitter':
          case 'x':
            twitterCtrl.text = socialLink.url ?? '';
            break;
          case 'instagram':
            instagramCtrl.text = socialLink.url ?? '';
            break;
          case 'linkedin':
            linkedinCtrl.text = socialLink.url ?? '';
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    mobile1Ctrl.dispose();
    mobile2Ctrl.dispose();
    officePhoneCtrl.dispose();
    poBoxCtrl.dispose();
    zipCtrl.dispose();
    facebookCtrl.dispose();
    twitterCtrl.dispose();
    instagramCtrl.dispose();
    linkedinCtrl.dispose();
    streetHomeCtrl.dispose();
    buildingHomeCtrl.dispose();
    officeNumberHomeCtrl.dispose();
    streetOfficeCtrl.dispose();
    buildingOfficeCtrl.dispose();
    officeNumberOfficeCtrl.dispose();
    otherDetailsCtrl.dispose();
    userDataCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userDataCubit,
      child: BlocListener<UserDataCubit, UserDataState>(
        listener: (context, state) {
          if (state is UserDataSuccess) {
            _initializeFields();
          } else if (state is UserDataError) {
            // Handle error - you can show a toast or snackbar here
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Scaffold(
          appBar: customAppBar(context: context, title: 'edit_profile'.tr()),
          backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
          body: BlocBuilder<UserDataCubit, UserDataState>(
            builder: (context, state) {
              if (state is UserDataLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        PersonalInformation(
                          isDarkMode: darkModeValue,
                          firstNameCtrl: firstNameCtrl,
                          lastNameCtrl: lastNameCtrl,
                          emailCtrl: emailCtrl,
                          websiteCtrl: websiteCtrl,
                          imageUrl: profileImageUrl,
                        ),

                        const SizedBox(height: 16),
                        ContactInformation(
                          mobiles: mobiles,
                          isDarkMode: darkModeValue,
                          poBoxCtrl: poBoxCtrl,
                          zipCtrl: zipCtrl,
                          officePhoneCtrl: officePhoneCtrl,
                        ),

                        // Container(
                        //   margin: const EdgeInsets.symmetric(horizontal: 16),
                        //   padding: const EdgeInsets.all(16),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(24),
                        //     border: Border.all(color: Colors.grey[200]!),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         'Contact Information',
                        //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        //           fontWeight: FontWeight.w700,
                        //           color: isDarkMode ? AppColors.white : AppColors.black,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 24),
                        //       ...List.generate(mobiles.length, (i) {
                        //         return Padding(
                        //           padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
                        //           child: CustomTextFormField(
                        //             contentPadding: EdgeInsets.symmetric(
                        //               horizontal: 10,
                        //             ),
                        //             controller: mobiles[i],
                        //             hintText: 'Mobile Number',
                        //             nameField: i == 0 ? 'Mobile Numbers' : null,
                        //             textInputType: TextInputType.phone,
                        //             borderRadius: 8,
                        //           ),
                        //         );
                        //       }),
                        //       const SizedBox(height: 10),
                        //       GestureDetector(
                        //         onTap: () {
                        //           setState(() => mobiles.add(TextEditingController()));
                        //         },
                        //         child: Row(
                        //           children: [
                        //             const Icon(
                        //               Icons.add,
                        //               color: AppColors.primaryColor,
                        //             ),
                        //             Text(
                        //               'Add Mobile Number',
                        //               style:
                        //                   Theme.of(
                        //                     context,
                        //                   ).textTheme.labelMedium?.copyWith(),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       const SizedBox(height: 14),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             child: CustomTextFormField(
                        //               contentPadding: EdgeInsets.symmetric(
                        //                 horizontal: 10,
                        //               ),
                        //               controller: officePhoneCtrl,
                        //               hintText: 'Office Phone',
                        //               nameField: 'Office Phone',
                        //               textInputType: TextInputType.phone,
                        //               borderRadius: 8,
                        //             ),
                        //           ),
                        //           const SizedBox(width: 12),
                        //           Expanded(
                        //             child: CustomTextFormField(
                        //               contentPadding: EdgeInsets.symmetric(
                        //                 horizontal: 10,
                        //               ),
                        //               controller: poBoxCtrl,
                        //               hintText: 'P.O. Box',
                        //               nameField: 'P.O. Box',
                        //               textInputType: TextInputType.text,
                        //               borderRadius: 8,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(height: 12),
                        //       CustomTextFormField(
                        //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        //         controller: zipCtrl,
                        //         hintText: 'Zip Code',
                        //         nameField: 'Zip Code',
                        //         textInputType: TextInputType.number,
                        //         borderRadius: 8,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'social_media'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: darkModeValue ? AppColors.white : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _socialField(icon: AppIcons.facebook, controller: facebookCtrl, hint: 'facebook_url'.tr()),
                              const SizedBox(height: 12),
                              _socialField(icon: AppIcons.x, controller: twitterCtrl, hint: 'twitter_url'.tr()),
                              const SizedBox(height: 12),
                              _socialField(icon: AppIcons.instagramSetting, controller: instagramCtrl, hint: 'instagram_url'.tr()),
                              const SizedBox(height: 12),
                              _socialField(icon: AppIcons.linkedin, controller: linkedinCtrl, hint: 'linkedin_url'.tr()),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        AddressInformation(
                          isDarkMode: darkModeValue,
                          streetOfficeCtrl: streetOfficeCtrl,
                          buildingOfficeCtrl: buildingOfficeCtrl,
                          officeNumberOfficeCtrl: officeNumberOfficeCtrl,
                        ),

                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'additional_information'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: darkModeValue ? AppColors.white : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 24),
                              CustomTextFormField(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                controller: otherDetailsCtrl,
                                hintText: 'other_details'.tr(),
                                nameField: 'other_details'.tr(),
                                maxLines: 6,
                                borderRadius: 8,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('save_changes'.tr()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _socialField({String? icon, required TextEditingController controller, required String hint}) {
    return Row(
      children: [
        SvgPicture.asset(icon!, width: 18, height: 18),
        const SizedBox(width: 8),
        Expanded(child: CustomTextFormField(controller: controller, hintText: hint, borderRadius: 8)),
      ],
    );
  }
}
