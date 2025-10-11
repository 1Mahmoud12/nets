import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/utils/app_icons.dart';

import '../../../../core/network/local/cache.dart';
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

  final firstNameCtrl = TextEditingController(text: 'Ahmed');
  final lastNameCtrl = TextEditingController(text: 'Hassan');
  final emailCtrl = TextEditingController(text: 'ahmed.hassan@techcorp.com');
  final websiteCtrl = TextEditingController(text: 'https://ahmedhassan.dev');

  final mobile1Ctrl = TextEditingController(text: '+1 (555) 123-4567');
  final mobile2Ctrl = TextEditingController();
  final officePhoneCtrl = TextEditingController(text: '+1 (555) 987-6543');
  final poBoxCtrl = TextEditingController(text: '12345');
  final zipCtrl = TextEditingController(text: '10001');

  final facebookCtrl = TextEditingController(
    text: 'https://facebook.com/michael.johnson',
  );
  final twitterCtrl = TextEditingController(
    text: 'https://twitter.com/mjohnson_dev',
  );
  final instagramCtrl = TextEditingController(
    text: 'https://instagram.com/michael_codes',
  );
  final linkedinCtrl = TextEditingController(
    text: 'https://linkedin.com/in/michael-johnson-dev',
  );

  final streetHomeCtrl = TextEditingController(text: '123 Innovation Drive');
  final buildingHomeCtrl = TextEditingController(text: '456');
  final officeNumberHomeCtrl = TextEditingController(text: 'Suite 789');

  final streetOfficeCtrl = TextEditingController(text: '123 Innovation Drive');
  final buildingOfficeCtrl = TextEditingController(text: '456');
  final officeNumberOfficeCtrl = TextEditingController(text: 'Suite 789');

  final otherDetailsCtrl = TextEditingController(
    text:
        'Passionate about creating innovative solutions and leading development teams. Available for consulting and speaking engagements.',
  );

  final mobiles = <TextEditingController>[];

  @override
  void initState() {
    mobiles.addAll([mobile1Ctrl]);
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Edit Profile'),
      backgroundColor:  darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
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
                        'Social Media',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _socialField(
                        icon: AppIcons.facebook,
                        controller: facebookCtrl,
                        hint: 'Facebook URL',
                      ),
                      const SizedBox(height: 12),
                      _socialField(
                        icon: AppIcons.x,
                        controller: twitterCtrl,
                        hint: 'Twitter URL',
                      ),
                      const SizedBox(height: 12),
                      _socialField(
                        icon: AppIcons.instagramSetting,
                        controller: instagramCtrl,
                        hint: 'Instagram URL',
                      ),
                      const SizedBox(height: 12),
                      _socialField(
                        icon: AppIcons.linkedin,
                        controller: linkedinCtrl,
                        hint: 'LinkedIn URL',
                      ),
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
                        'Additional Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        controller: otherDetailsCtrl,
                        hintText: 'Other Details',
                        nameField: 'Other Details',
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialField({
    String? icon,
    required TextEditingController controller,
    required String hint,
  }) {
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
