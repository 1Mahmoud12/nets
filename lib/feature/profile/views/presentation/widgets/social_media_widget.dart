import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'add_social_media_dialog.dart';
import 'social_media_data.dart';

class SocialMediaWidget extends StatefulWidget {
  const SocialMediaWidget({
    super.key,
    required this.isDarkMode,
    required this.facebookCtrl,
    required this.twitterCtrl,
    required this.instagramCtrl,
    required this.linkedinCtrl,
    required this.dynamicSocialMedia,
    required this.onSocialMediaChanged,
  });

  final bool isDarkMode;
  final TextEditingController facebookCtrl;
  final TextEditingController twitterCtrl;
  final TextEditingController instagramCtrl;
  final TextEditingController linkedinCtrl;
  final List<SocialMediaData> dynamicSocialMedia;
  final Function(List<SocialMediaData>) onSocialMediaChanged;

  @override
  State<SocialMediaWidget> createState() => _SocialMediaWidgetState();
}

class _SocialMediaWidgetState extends State<SocialMediaWidget> {
  Future<void> _showAddSocialMediaDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddSocialMediaDialog(),
    );

    if (result != null && result.containsKey('platform') && result.containsKey('url')) {
      final newSocial = SocialMediaData(
        controller: TextEditingController(text: result['url'] ?? ''),
        platform: result['platform'] ?? '',
      );
      setState(() {
        widget.dynamicSocialMedia.add(newSocial);
      });
      widget.onSocialMediaChanged(widget.dynamicSocialMedia);
    }
  }

  void _removeSocialMedia(int index) {
    setState(() {
      widget.dynamicSocialMedia[index].dispose();
      widget.dynamicSocialMedia.removeAt(index);
    });
    widget.onSocialMediaChanged(widget.dynamicSocialMedia);
  }

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
                  color: widget.isDarkMode ? AppColors.white : AppColors.black,
                ),
          ),
          const SizedBox(height: 24),
          // Fixed social media platforms
          SocialField(
            icon: AppIcons.facebook,
            controller: widget.facebookCtrl,
            hint: 'facebook_url'.tr(),
            onDelete: () {
              setState(() {
                widget.facebookCtrl.clear();
              });
            },
          ),
          const SizedBox(height: 12),
          SocialField(
            icon: AppIcons.x,
            controller: widget.twitterCtrl,
            hint: 'twitter_url'.tr(),
            onDelete: () {
              setState(() {
                widget.twitterCtrl.clear();
              });
            },
          ),
          const SizedBox(height: 12),
          SocialField(
            icon: AppIcons.instagramSetting,
            controller: widget.instagramCtrl,
            hint: 'instagram_url'.tr(),
            onDelete: () {
              setState(() {
                widget.instagramCtrl.clear();
              });
            },
          ),
          const SizedBox(height: 12),
          SocialField(
            icon: AppIcons.linkedin,
            controller: widget.linkedinCtrl,
            hint: 'linkedin_url'.tr(),
            onDelete: () {
              setState(() {
                widget.linkedinCtrl.clear();
              });
            },
          ),
          
          // Dynamic social media entries
          if (widget.dynamicSocialMedia.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...List.generate(widget.dynamicSocialMedia.length, (index) {
              final social = widget.dynamicSocialMedia[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: social.controller,
                        hintText: '${social.platform} URL',
                        borderRadius: 8,
                        validator: (value) => null, // Disable validation
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.primaryColor),
                      onPressed: () => _removeSocialMedia(index),
                      tooltip: 'Remove',
                    ),
                  ],
                ),
              );
            }),
          ],
          
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showAddSocialMediaDialog,
            child: Row(
              children: [
                const Icon(Icons.add, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Add Social Media',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialField extends StatefulWidget {
  const SocialField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
    this.onDelete,
  });

  final String? icon;
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onDelete;

  @override
  State<SocialField> createState() => _SocialFieldState();
}

class _SocialFieldState extends State<SocialField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.controller.text.isNotEmpty;

    return Row(
      children: [
        SvgPicture.asset(widget.icon!, width: 18, height: 18),
        const SizedBox(width: 8),
        Expanded(
          child: CustomTextFormField(
            controller: widget.controller,
            hintText: widget.hint,
            borderRadius: 8,
            validator: (value) => null, // Disable validation
          ),
        ),
        if (hasContent && widget.onDelete != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primaryColor, size: 20),
            onPressed: widget.onDelete,
            tooltip: 'Clear',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }
}

