import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';

class AddSocialMediaDialog extends StatefulWidget {
  const AddSocialMediaDialog({super.key});

  @override
  State<AddSocialMediaDialog> createState() => _AddSocialMediaDialogState();
}

class _AddSocialMediaDialogState extends State<AddSocialMediaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _platformController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _onSave() {
    final platform = _platformController.text.trim();
    final url = _urlController.text.trim();

    Navigator.of(context).pop({
      'platform': platform,
      'url': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDarkMode ? AppColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'add_social_media'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppColors.darkTextPrimary : AppColors.black,
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                controller: _platformController,
                hintText: 'platform_name'.tr(),
                nameField: 'platform_name'.tr(),
                borderRadius: 8,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _urlController,
                hintText: 'url'.tr(),
                nameField: 'url'.tr(),
                borderRadius: 8,
                textInputType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'cancel'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkTextSecondary : AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('add'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

