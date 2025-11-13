import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nets/feature/profile/data/models/user_data_model.dart';
import 'package:nets/feature/profile/data/models/user_data_param.dart' as param;
import 'dart:io';
import '../manager/cubit/user_data_cubit.dart';
import '../manager/update/cubit/update_user_data_cubit.dart';
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
  late ProfileDataModel profileData;
  File? selectedImage;
  UserData? originalUserData;
  bool _isImageUpdateComplete = false;
  bool _isDataUpdateComplete = false;

  @override
  void initState() {
    super.initState();
    profileData = ProfileDataModel();
    // Initialize with at least one phone
    profileData.phones.add(PhoneData(controller: TextEditingController()));
    _loadUserData();
  }

  void _loadUserData() {
    final cachedUserData = ConstantsModels.userDataModel?.data;
    if (cachedUserData != null) {
      _initializeFields();
    } else {
      context.read<UserDataCubit>().getUserData();
    }
  }

  void _initializeFields() {
    final userData = ConstantsModels.userDataModel?.data;
    if (userData == null) return;

    originalUserData = userData;
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
      String phoneNumber = phoneData.phone ?? '';
      String countryCode = '+966'; // Default country code

      // Extract country code from phone number if it exists
      if (phoneNumber.startsWith('+966')) {
        countryCode = '+966';
        phoneNumber = phoneNumber.substring(4); // Remove +966
      } else if (phoneNumber.startsWith('+971')) {
        countryCode = '+971';
        phoneNumber = phoneNumber.substring(4); // Remove +971
      } else if (phoneNumber.startsWith('+2')) {
        countryCode = '+2';
        phoneNumber = phoneNumber.substring(2); // Remove +2
      }

      final controller = TextEditingController(text: phoneNumber);
      final String phoneType = phoneData.type ?? 'mobile';
      profileData.phones.add(PhoneData(controller: controller, type: phoneType, isPrimary: phoneData.isPrimary == true, countryCode: countryCode));
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

  String? _nullableTrim(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  param.UserDataParam _buildUserDataParam() {
    final original = originalUserData ?? ConstantsModels.userDataModel?.data;

    final firstName = _nullableTrim(profileData.firstNameCtrl.text) ?? '';
    final lastName = _nullableTrim(profileData.lastNameCtrl.text) ?? '';
    final email = _nullableTrim(profileData.emailCtrl.text);
    final website = _nullableTrim(profileData.websiteCtrl.text);
    final zipCode = _nullableTrim(profileData.zipCtrl.text);
    final streetName = _nullableTrim(profileData.streetOfficeCtrl.text);
    final buildingNumber = _nullableTrim(profileData.buildingOfficeCtrl.text);
    final streetNumber = _nullableTrim(profileData.officeNumberOfficeCtrl.text);
    final additionalInformation = _nullableTrim(profileData.otherDetailsCtrl.text);

    // Build phones list using UserDataParam.Phones
    final phones =
        profileData.phones.where((phone) => phone.controller.text.trim().isNotEmpty).map((phone) {
          // Combine country code with phone number
          String phoneNumber = phone.controller.text.trim();
          // Remove leading '0' for Saudi Arabia (+966) if present
          if (phone.countryCode == '+966' && phoneNumber.startsWith('0')) {
            phoneNumber = phoneNumber.substring(1);
          }
          final fullPhoneNumber = phone.countryCode + phoneNumber;
          return param.Phones(phone: fullPhoneNumber, type: phone.type, isPrimary: phone.isPrimary);
        }).toList();

    // Build social links list using UserDataParam.SocialLinks
    final socialLinks = <param.SocialLinks>[];

    // Add fixed platforms if they have URLs
    if (profileData.facebookCtrl.text.trim().isNotEmpty) {
      socialLinks.add(param.SocialLinks(platform: 'facebook', url: profileData.facebookCtrl.text.trim()));
    }
    if (profileData.twitterCtrl.text.trim().isNotEmpty) {
      socialLinks.add(param.SocialLinks(platform: 'twitter', url: profileData.twitterCtrl.text.trim()));
    }
    if (profileData.instagramCtrl.text.trim().isNotEmpty) {
      socialLinks.add(param.SocialLinks(platform: 'instagram', url: profileData.instagramCtrl.text.trim()));
    }
    if (profileData.linkedinCtrl.text.trim().isNotEmpty) {
      socialLinks.add(param.SocialLinks(platform: 'linkedin', url: profileData.linkedinCtrl.text.trim()));
    }

    // Add dynamic social media
    for (final social in profileData.dynamicSocialMedia) {
      if (social.controller.text.trim().isNotEmpty) {
        socialLinks.add(param.SocialLinks(platform: social.platform, url: social.controller.text.trim()));
      }
    }

    // Build UserDataParam
    return param.UserDataParam(
      firstName: firstName,
      lastName: lastName,
      email: email,
      website: website,
      zipCode: zipCode,
      streetName: streetName,
      buildingNumber: buildingNumber,
      streetNumber: streetNumber,
      additionalInformation: additionalInformation,
      titleWork: original?.profile?.titleWork,
      phones: phones.isEmpty ? null : phones,
      socialLinks: socialLinks.isEmpty ? null : socialLinks,
    );
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final updateCubit = context.read<UpdateUserDataCubit>();
    // Reset flags
    _isImageUpdateComplete = false;
    _isDataUpdateComplete = false;

    try {
      // Update image first if a new one was selected
      if (selectedImage != null) {
        await updateCubit.updateUserImage(selectedImage!);
        // Wait for image update to complete - handled in listener
      } else {
        // No image to update, mark as complete
        _isImageUpdateComplete = true;
        // Proceed with data update
        final userDataParam = _buildUserDataParam();
        await updateCubit.updateUserData(userDataParam);
      }
    } catch (e) {
      // Error handling is done in BlocListener
    }
  }

  void _checkAndNavigate() {
    // Only navigate if both updates are complete and context is still mounted
    if (_isImageUpdateComplete && _isDataUpdateComplete && mounted) {
      // Reload user data after successful update
      context.read<UserDataCubit>().getUserData();
      // Navigate back
      Navigator.pop(context);
      // Reset flags
      _isImageUpdateComplete = false;
      _isDataUpdateComplete = false;
    }
  }

  @override
  void dispose() {
    profileData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserDataCubit, UserDataState>(
          listener: (context, state) {
            if (state is UserDataSuccess) {
              _initializeFields();
            } else if (state is UserDataError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        ),
        BlocListener<UpdateUserDataCubit, UpdateUserDataState>(
          listener: (context, state) {
            if (state is UpdateUserDataImageSuccess) {
              // Image update completed successfully
              _isImageUpdateComplete = true;
              // Now update the user data
              final userDataParam = _buildUserDataParam();
              context.read<UpdateUserDataCubit>().updateUserData(userDataParam);
            } else if (state is UpdateUserDataImageError) {
              _isImageUpdateComplete = true; // Mark as complete even on error to avoid hanging
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is UpdateUserDataSuccess) {
              // Data update completed successfully
              _isDataUpdateComplete = true;
              _checkAndNavigate();
            } else if (state is UpdateUserDataError) {
              _isDataUpdateComplete = true; // Mark as complete even on error
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'edit_profile'.tr()),
        backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
        body: BlocBuilder<UserDataCubit, UserDataState>(
          builder: (context, state) {
            if (state is UserDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
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
                            onImageSelected: (image) {
                              selectedImage = image;
                            },
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

                          const SizedBox(height: 24), // Extra padding at bottom for persistent button
                        ],
                      ),
                    ),
                  ),
                  // Persistent Save Button
                  BlocBuilder<UpdateUserDataCubit, UpdateUserDataState>(
                    builder: (context, updateState) {
                      final isLoading = updateState is UpdateUserDataLoading || updateState is UpdateUserDataImageLoading;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
                          border: Border(top: BorderSide(color: Colors.grey[200]!)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
                        ),
                        child: SafeArea(top: false, child: SaveChangesButton(isLoading: isLoading, onPressed: _saveProfile)),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
