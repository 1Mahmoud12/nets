import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/cache_image.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

import '../../../../../core/component/fields/custom_text_form_field.dart';
import '../../../../../core/utils/utils.dart';

class PersonalInformation extends StatefulWidget {
  PersonalInformation({
    super.key,
    required this.isDarkMode,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.websiteCtrl,
    this.imageUrl,
    this.onImageSelected,
  });

  final bool isDarkMode;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController websiteCtrl;
  final String? imageUrl;
  final Function(File)? onImageSelected;

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  File onImageSelected = File('');

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
            'Personal Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: widget.isDarkMode ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              final image = await Utils.captureImage();
              if (image != null) {
                setState(() {
                  onImageSelected = image;
                });
                widget.onImageSelected?.call(image);
              }
            },
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: onImageSelected.path.isNotEmpty
                        ? CacheImage(
                            fileImage: onImageSelected,
                            circle: true,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          )
                        : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                            ? CacheImage(
                                urlImage: widget.imageUrl,
                                circle: true,
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                                profileImage: true,
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      AppIcons.editImage,
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: widget.firstNameCtrl,
                  hintText: 'First Name',
                  nameField: 'First Name',
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextFormField(
                  enableLtr: true,
                  controller: widget.lastNameCtrl,
                  hintText: 'Last Name',
                  nameField: 'Last Name',
                  borderRadius: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: widget.emailCtrl,
            hintText: 'Email',
            nameField: 'Email',
            textInputType: TextInputType.emailAddress,
            borderRadius: 8,
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: widget.websiteCtrl,
            hintText: 'Website',
            nameField: 'Website',
            textInputType: TextInputType.url,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
