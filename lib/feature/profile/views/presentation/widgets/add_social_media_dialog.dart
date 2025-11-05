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
    if (_formKey.currentState?.validate() ?? false) {
      final platform = _platformController.text.trim();
      final url = _urlController.text.trim();

      if (platform.isEmpty || url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      Navigator.of(context).pop({
        'platform': platform,
        'url': url,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
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
                'Add Social Media',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                controller: _platformController,
                hintText: 'Platform Name',
                nameField: 'Platform Name',
                borderRadius: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter platform name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _urlController,
                hintText: 'URL',
                nameField: 'URL',
                borderRadius: 8,
                textInputType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter URL';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.hasAbsolutePath) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
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
                        color: isDarkMode ? AppColors.white : AppColors.black,
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

