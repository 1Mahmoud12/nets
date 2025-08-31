import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

    _rotationController = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _rotationController.dispose();
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
            content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('QR code shared successfully!')]),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to share QR code: $e'), backgroundColor: Colors.red));
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
            content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('QR code saved to gallery!')]),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save QR code: $e'), backgroundColor: Colors.red));
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
          children: [Icon(Icons.copy, color: Colors.white, size: 20), SizedBox(width: 8), Text('Contact info copied to clipboard!')],
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
      final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (photo != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo captured successfully!'), duration: Duration(seconds: 2)));
        }
      }
    } catch (e) {
      final status = await Permission.camera.request();

      if (status.isDenied) {
        // Show permission denied message
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Camera permission is required to scan QR codes'), backgroundColor: Colors.red));
        }
      } else if (status.isPermanentlyDenied) {
        // Show settings dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Camera Permission Required'),
                content: const Text('Camera permission has been permanently denied. Please enable it in settings.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
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

  void _showQrOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR Code Options',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                      ),
                      const SizedBox(height: 20),
                      _buildOptionTile(Icons.qr_code_scanner, 'Scan QR Code', 'Open camera to scan QR codes', _openQrScanner),
                      _buildOptionTile(Icons.share, 'Share QR Code', 'Share with others via messaging apps', _shareQrCode),
                      _buildOptionTile(Icons.download, 'Save to Gallery', 'Save QR code as image to your device', _saveQrCode),
                      _buildOptionTile(Icons.copy, 'Copy Contact Info', 'Copy contact details to clipboard', _copyQrData),
                      _buildOptionTile(Icons.print, 'Print QR Code', 'Print QR code for physical sharing', () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: darkModeValue ? AppColors.white : AppColors.black)),
      subtitle: Text(subtitle, style: TextStyle(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 12)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              child: Column(
                children: [
                  // QR Code Container
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryColor.withOpacity(0.1), AppColors.primaryColor.withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
                      boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
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
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // QR Code
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                              ),
                              child: QrImageView(
                                data: _generateQrData(),
                                size: 200.0,
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryColor,
                                errorStateBuilder: (cxt, err) {
                                  return const Center(child: Text('Error generating QR code', textAlign: TextAlign.center));
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
                            color: darkModeValue ? AppColors.darkModeColor : Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Text(
                                      userData['name']!.split(' ').map((e) => e[0]).join(),
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['name']!,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: darkModeValue ? AppColors.white : AppColors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          userData['position']!,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          userData['company']!,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Divider(color: darkModeValue ? Colors.grey[700] : Colors.grey[300], height: 1),
                              const SizedBox(height: 15),
                              // Contact details
                              _buildContactRow(Icons.email, userData['email']!),
                              const SizedBox(height: 8),
                              _buildContactRow(Icons.phone, userData['phone']!),
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
                icon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryColor, size: 24),
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                tooltip: 'Scan QR Code',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: darkModeValue ? Colors.grey[300] : Colors.grey[700], fontSize: 13),
          ),
        ),
      ],
    );
  }
}
