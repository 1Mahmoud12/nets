import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nets/feature/profile/data/models/user_data_model.dart';

import '../manager/cubit/user_data_cubit.dart';
import 'widgets/address_information_widget.dart';
import 'widgets/contact_information_widget.dart';
import 'widgets/personal_information_widget.dart';
import 'widgets/social_media_widget.dart';
import 'widgets/social_media_data.dart';
import 'widgets/additional_information_widget.dart';
import 'widgets/save_changes_button.dart';
import 'widgets/profile_data_model.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late UserDataCubit userDataCubit;
  late ProfileDataModel profileData;

  @override
  void initState() {
    super.initState();
    userDataCubit = UserDataCubit();
    profileData = ProfileDataModel();
    // Initialize with at least one phone
    profileData.phones.add(PhoneData(controller: TextEditingController()));
    _loadUserData();
  }

  void _loadUserData() {
    userDataCubit.getUserData();
  }

  void _initializeFields() {
    final userData = ConstantsModels.userDataModel?.data;
    if (userData == null) return;

    _initializeProfileData(userData);
    _initializePhones(userData);
    _initializeSocialLinks(userData);
    setState(() {}); // Update UI
  }

  void _initializeProfileData(UserData userData) {
    final profile = userData.profile;
    if (profile == null) return;

    profileData.firstNameCtrl.text = profile.firstName ?? '';
    profileData.lastNameCtrl.text = profile.lastName ?? '';
    profileData.emailCtrl.text = profile.email ?? '';
    profileData.websiteCtrl.text = profile.website ?? '';
    profileData.zipCtrl.text = profile.zipCode ?? '';
    profileData.streetOfficeCtrl.text = profile.streetName ?? '';
    profileData.buildingOfficeCtrl.text = profile.buildingNumber ?? '';
    profileData.officeNumberOfficeCtrl.text = profile.streetNumber ?? '';
    profileData.otherDetailsCtrl.text = profile.additionalInformation ?? '';

    // Set image URL - if it's a relative path, prepend base URL
    if (profile.image != null && profile.image!.isNotEmpty) {
      if (profile.image!.startsWith('http://') || profile.image!.startsWith('https://')) {
        profileData.profileImageUrl = profile.image;
      } else {
        // If it's a relative path, prepend the domain
        profileData.profileImageUrl = '${EndPoints.domain}${profile.image!.startsWith('/') ? '' : '/'}${profile.image}';
      }
    }
  }

  void _initializePhones(dynamic userData) {
    if (userData.phones == null || userData.phones!.isEmpty) {
      // Ensure at least one phone exists
      if (profileData.phones.isEmpty) {
        profileData.phones.add(PhoneData(controller: TextEditingController(), isPrimary: true));
      }
      return;
    }

    // Sort phones: primary first, then others
    final sortedPhones = List.from(userData.phones!);
    sortedPhones.sort((a, b) {
      if (a.isPrimary == true && b.isPrimary != true) return -1;
      if (a.isPrimary != true && b.isPrimary == true) return 1;
      return 0;
    });

    // Clear existing phones and add new ones
    for (final phone in profileData.phones) {
      phone.controller.dispose();
      phone.typeController.dispose();
    }
    profileData.phones.clear();

    // Initialize phones from API data
    for (final phoneData in sortedPhones) {
      final controller = TextEditingController(text: phoneData.phone ?? '');
      final String phoneType = phoneData.type ?? 'mobile';
      profileData.phones.add(PhoneData(controller: controller, type: phoneType, isPrimary: phoneData.isPrimary == true));
    }

    // Ensure at least one phone is primary
    final hasPrimary = profileData.phones.any((p) => p.isPrimary);
    if (!hasPrimary && profileData.phones.isNotEmpty) {
      profileData.phones[0].isPrimary = true;
    }
  }

  void _initializeSocialLinks(UserData userData) {
    if (userData.socialLinks == null) return;

    // List of fixed platforms
    const fixedPlatforms = ['facebook', 'twitter', 'x', 'instagram', 'linkedin'];

    for (final socialLink in userData.socialLinks!) {
      final platform = socialLink.platform?.toLowerCase() ?? '';

      switch (platform) {
        case 'facebook':
          profileData.facebookCtrl.text = socialLink.url ?? '';
          break;
        case 'twitter':
        case 'x':
          profileData.twitterCtrl.text = socialLink.url ?? '';
          break;
        case 'instagram':
          profileData.instagramCtrl.text = socialLink.url ?? '';
          break;
        case 'linkedin':
          profileData.linkedinCtrl.text = socialLink.url ?? '';
          break;
        default:
          // Add to dynamic social media if it's not a fixed platform
          if (!fixedPlatforms.contains(platform) && platform.isNotEmpty) {
            profileData.dynamicSocialMedia.add(
              SocialMediaData(controller: TextEditingController(text: socialLink.url ?? ''), platform: socialLink.platform ?? '', id: socialLink.id),
            );
          }
          break;
      }
    }
  }

  @override
  void dispose() {
    profileData.dispose();
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
                          firstNameCtrl: profileData.firstNameCtrl,
                          lastNameCtrl: profileData.lastNameCtrl,
                          emailCtrl: profileData.emailCtrl,
                          websiteCtrl: profileData.websiteCtrl,
                          imageUrl: profileData.profileImageUrl,
                        ),

                        const SizedBox(height: 16),
                        ContactInformation(
                          phones: profileData.phones,
                          isDarkMode: darkModeValue,
                          zipCtrl: profileData.zipCtrl,
                          onPhoneChanged: (index, type, isPrimary) {
                            setState(() {
                              profileData.phones[index].type = type;
                              profileData.phones[index].isPrimary = isPrimary;
                            });
                          },
                          onAddPhone: () {
                            setState(() {
                              final hasPrimary = profileData.phones.any((p) => p.isPrimary);
                              profileData.phones.add(PhoneData(controller: TextEditingController(), isPrimary: !hasPrimary));
                            });
                          },
                        ),

                        const SizedBox(height: 16),
                        SocialMediaWidget(
                          isDarkMode: darkModeValue,
                          facebookCtrl: profileData.facebookCtrl,
                          twitterCtrl: profileData.twitterCtrl,
                          instagramCtrl: profileData.instagramCtrl,
                          linkedinCtrl: profileData.linkedinCtrl,
                          dynamicSocialMedia: profileData.dynamicSocialMedia,
                          onSocialMediaChanged: (updatedList) {
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 16),
                        AddressInformation(
                          isDarkMode: darkModeValue,
                          streetOfficeCtrl: profileData.streetOfficeCtrl,
                          buildingOfficeCtrl: profileData.buildingOfficeCtrl,
                          officeNumberOfficeCtrl: profileData.officeNumberOfficeCtrl,
                        ),

                        const SizedBox(height: 16),
                        AdditionalInformationWidget(isDarkMode: darkModeValue, controller: profileData.otherDetailsCtrl),

                        const SizedBox(height: 24),
                        SaveChangesButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.pop(context);
                            }
                          },
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
}
