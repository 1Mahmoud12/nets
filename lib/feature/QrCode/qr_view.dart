import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/component/buttons/custom_text_button.dart';

class QrView extends StatefulWidget {
  const QrView({super.key});

  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  bool _isSharing = false;
  bool _isSaving = false;
  bool _isYes = false;
  final TextEditingController _notesController = TextEditingController();

  // User data - in real app, this would come from user profile/cache
  final Map<String, String> userData = {
    'name': 'Ahmed Hassan',
    'email': 'ahmed.hassan@nets.com',
    'phone': '+20 123 456 7890',
    'company': 'Nets Technologies',
    'position': 'Senior Developer',
    'profileUrl': 'https://nets.com/profile/ahmed-hassan',
  };

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _generateQrData() {
    // Generate comprehensive QR data with user information
    return '''
BEGIN:VCARD
VERSION:3.0
FN:${userData['name']}
EMAIL:${userData['email']}
TEL:${userData['phone']}
ORG:${userData['company']}
TITLE:${userData['position']}
URL:${userData['profileUrl']}
END:VCARD
'''.trim();
  }

  void _shareQrCode() async {
    setState(() => _isSharing = true);

    try {
      // Simulate sharing delay
      await Future.delayed(const Duration(seconds: 1));

      // In real app, implement actual sharing functionality
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('QR code shared successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _saveQrCode() async {
    setState(() => _isSaving = true);

    try {
      // Simulate saving delay
      await Future.delayed(const Duration(seconds: 1));

      // In real app, implement actual save to gallery functionality
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('QR code saved to gallery!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _copyQrData() {
    Clipboard.setData(ClipboardData(text: _generateQrData()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.copy, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Contact info copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openQrScanner() async {
    // Request camera permission first
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        // Show success message
        if (mounted) {
          _showScanQRCode();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Photo captured successfully!'),
          //     duration: Duration(seconds: 2),
          //   ),
          // );
        }
      }
    } catch (e) {
      final status = await Permission.camera.request();

      if (status.isDenied) {
        // Show permission denied message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required to scan QR codes'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        // Show settings dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Camera Permission Required'),
                content: const Text(
                  'Camera permission has been permanently denied. Please enable it in settings.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  void _showScanQRCode() {
    showModalBottomSheet(
      context: context,
      backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'scan_qr_code'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              color:
                                  darkModeValue ? Colors.black : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: darkModeValue ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isYes = !_isYes;
                        });
                        Navigator.pop(context);
                        _showSaveContact();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              darkModeValue
                                  ? _isYes
                                      ? AppColors.primaryColor
                                      : AppColors.transparent
                                  : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Yes: Share_all_info_including_phone_number'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color:
                                darkModeValue
                                    ? Colors.white
                                    : _isYes
                                    ? AppColors.black
                                    : AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isYes = !_isYes;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              darkModeValue
                                  ? !_isYes
                                      ? AppColors.darkModeColor
                                      : Colors.white
                                  : Colors.white,
                          border: Border.all(
                            color:
                                darkModeValue
                                    ? Colors.white
                                    : !_isYes
                                    ? AppColors.greyG200
                                    : AppColors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'No: Share_all_info_except_phone_number'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color:
                                darkModeValue
                                    ? Colors.white
                                    : !_isYes
                                    ? Colors.black
                                    : AppColors.transparent,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    CustomTextButton(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.greyG200,
                      borderRadius: 8,
                      borderColor: AppColors.transparent,
                      child: Text(
                        'cancel'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDivider({double indent = 20}) {
    return Divider(
      height: 1,
      color: darkModeValue ? Colors.grey[700] : Colors.grey[200],
      indent: indent,
      endIndent: 20,
    );
  }

 
  void _showSaveContact() {
    showModalBottomSheet(
      context: context,
      backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'save_Contact'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              color:
                                  darkModeValue ? Colors.black : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: darkModeValue ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      nameField: 'notes'.tr(),
                      controller: _notesController,
                      hintText: 'add_notes_about_this_contact'.tr(),
                      maxLines: 3,
                    ),

                 
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            onPress: () {},
                            backgroundColor: Colors.white,
                            borderRadius: 10,
                            borderColor: AppColors.greyG200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mic,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'voice_note'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextButton(
                            onPress: () {},
                            backgroundColor: Colors.white,
                            borderRadius: 10,
                            borderColor: AppColors.greyG200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'location'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextButton(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 12,
                      borderColor: AppColors.transparent,
                      child: Text(
                        'save_Contact'.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextButton(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.greyG200,
                      borderRadius: 12,
                      borderColor: AppColors.transparent,
                      child: Text(
                        'cancel'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 70),
              child: Column(
                children: [
                  // QR Code Container
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          // AppColors.primaryColor.withOpacity(0.2),
                          // AppColors.primaryColor.withOpacity(0.5),
                          Color(0xff6D83B5),
                          Color(0xffB5C6EE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // QR Code with animated border
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Animated rotating border
                            AnimatedBuilder(
                              animation: _rotationAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationAnimation.value * 2 * 3.14159,
                                  child: Container(
                                    width: 280,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // QR Code
                            Container(
                              // height: 280,
                              // width: 280,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: QrImageView(
                                data: _generateQrData(),
                                // size: 190.0,
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.black,
                                errorStateBuilder: (cxt, err) {
                                  return const Center(
                                    child: Text(
                                      'Error generating QR code',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Enhanced User info card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                darkModeValue
                                    ? AppColors.darkModeColor
                                    : Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                                  darkModeValue
                                      ? Colors.grey[700]!
                                      : Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Text(
                                      userData['name']!
                                          .split(' ')
                                          .map((e) => e[0])
                                          .join(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['name']!,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color:
                                                darkModeValue
                                                    ? AppColors.white
                                                    : AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          userData['position']!,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          userData['company']!,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall?.copyWith(
                                            color:
                                                darkModeValue
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Divider(
                                color:
                                    darkModeValue
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                height: 1,
                              ),
                              const SizedBox(height: 15),
                              // Contact details
                              _buildContactRow(
                                AppIcons.email,
                                userData['email']!,
                              ),
                              const SizedBox(height: 8),
                              _buildContactRow(
                                AppIcons.call,
                                userData['phone']!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Top Header with Camera Icon
            Positioned(
              top: 0,
              // left: 0,
              right: 0,
              child: IconButton(
                onPressed: _openQrScanner,
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                // padding: const EdgeInsets.symmetric(horizontal: 12),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                tooltip: 'Scan QR Code',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String icon, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,

          color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: darkModeValue ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
