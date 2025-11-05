import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class SocialMediaWidget extends StatelessWidget {
  const SocialMediaWidget({
    super.key,
    required this.isDarkMode,
    required this.facebookCtrl,
    required this.twitterCtrl,
    required this.instagramCtrl,
    required this.linkedinCtrl,
  });

  final bool isDarkMode;
  final TextEditingController facebookCtrl;
  final TextEditingController twitterCtrl;
  final TextEditingController instagramCtrl;
  final TextEditingController linkedinCtrl;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
          ),
          const SizedBox(height: 24),
          SocialField(icon: AppIcons.facebook, controller: facebookCtrl, hint: 'facebook_url'.tr()),
          const SizedBox(height: 12),
          SocialField(icon: AppIcons.x, controller: twitterCtrl, hint: 'twitter_url'.tr()),
          const SizedBox(height: 12),
          SocialField(icon: AppIcons.instagramSetting, controller: instagramCtrl, hint: 'instagram_url'.tr()),
          const SizedBox(height: 12),
          SocialField(icon: AppIcons.linkedin, controller: linkedinCtrl, hint: 'linkedin_url'.tr()),
        ],
      ),
    );
  }
}

class SocialField extends StatelessWidget {
  const SocialField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
  });

  final String? icon;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon!, width: 18, height: 18),
        const SizedBox(width: 8),
        Expanded(
          child: CustomTextFormField(
            controller: controller,
            hintText: hint,
            borderRadius: 8,
          ),
        ),
      ],
    );
  }
}

