import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/feature/QrCode/manager/cubit/qr_cubit.dart';
import 'package:nets/feature/QrCode/widgets/qr_camera_scanner.dart';
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
  late final QrCubit _qrCubit;

  bool _isSaving = false;
  String? _scannedQrRawData;
  Map<String, String>? _scannedContactDetails;

  @override
  void initState() {
    super.initState();

    _qrCubit = QrCubit();
    _rotationController = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _qrCubit.close();
    _rotationController.dispose();
    super.dispose();
  }

  String _generateQrData() {
    // Generate comprehensive QR data with user information
    return '''
BEGIN:VCARD
VERSION:3.0
FN:${userCacheValue?.data?.user?.profile?.firstName} ${userCacheValue?.data?.user?.profile?.lastName}
EMAIL:${userCacheValue?.data?.user?.profile?.email}
TEL:${userCacheValue?.data?.user?.phone}
ORG:${userCacheValue?.data?.user?.profile?.titleWork}
TITLE:${userCacheValue?.data?.user?.profile?.titleWork}
URL:${userCacheValue?.data?.user?.profile?.website}
END:VCARD
'''.trim();
  }

  Future<void> _openQrScanner() async {
    if (_isSaving) return;

    final hasPermission = await _ensureCameraPermission();
    if (!hasPermission) {
      return;
    }

    try {
      final qrCodeData = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const QrCameraScanner()));
      if (!mounted) {
        return;
      }

      if (qrCodeData == null) {
        return;
      }
      if (qrCodeData.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to read QR code. Please try again.'), backgroundColor: Colors.orange));
        return;
      }
      final contactDetails = _extractContactDetails(qrCodeData);
      setState(() {
        _scannedQrRawData = qrCodeData;
        _scannedContactDetails = contactDetails;
      });

      await _showSaveConfirmationDialog();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to scan QR code: $error'), backgroundColor: Colors.red));
      }
    }
  }

  Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    }

    _handleCameraPermissionDenied(status);
    return false;
  }

  void _handleCameraPermissionDenied(PermissionStatus status) {
    if (!mounted) {
      return;
    }

    if (status.isPermanentlyDenied) {
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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera permission is required to scan QR codes'), backgroundColor: Colors.red));
    }
  }

  String _valueOrNA(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? 'N/A' : trimmed;
  }

  void _clearScannedData() {
    if (!mounted) {
      return;
    }
    setState(() {
      _scannedQrRawData = null;
      _scannedContactDetails = null;
    });
  }

  Future<void> _showServerError(String message) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.error_outline, color: Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text("Couldn't Save Contact", style: theme.textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The server responded with the following message:',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, color: darkModeValue ? Colors.grey[300] : Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: darkModeValue ? Colors.black54 : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.5)),
              ),
              const SizedBox(height: 12),
              Text(
                'You can close this message and try again later.',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5, color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  Widget _buildInfoText(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$label: ', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
            TextSpan(text: value, style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSummary(BuildContext context, Map<String, String> details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkModeValue ? AppColors.darkModeColor.withOpacity(0.6) : AppColors.greyG200.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: darkModeValue ? Colors.grey[700]! : AppColors.greyG200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoText(context, 'Name', _valueOrNA(details['name'])),
          _buildInfoText(context, 'Email', _valueOrNA(details['email'])),
          _buildInfoText(context, 'Phone', _valueOrNA(details['phone'])),
          _buildInfoText(context, 'Title', _valueOrNA(details['titleWork'])),
          _buildInfoText(context, 'Location', _valueOrNA(details['location'])),
        ],
      ),
    );
  }

  Future<void> _showSaveConfirmationDialog() async {
    if (!mounted || _scannedContactDetails == null) {
      return;
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final details = _scannedContactDetails!;
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.contact_page, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('Save this contact?', style: theme.textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review the details before saving to your contacts.',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, color: darkModeValue ? Colors.grey[300] : Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              _buildContactSummary(dialogContext, details),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.save_rounded, size: 18), SizedBox(width: 8), Text('Save')]),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      _saveScannedContact();
    } else {
      _clearScannedData();
    }
  }

  Map<String, String> _extractContactDetails(String rawData) {
    final normalized = rawData.trim();
    final result = <String, String>{'name': '', 'email': '', 'phone': '', 'titleWork': '', 'location': '', 'notes': ''};

    if (normalized.toUpperCase().contains('BEGIN:VCARD')) {
      final lines = normalized.split(RegExp(r'\r?\n'));
      for (final line in lines) {
        final separatorIndex = line.indexOf(':');
        if (separatorIndex == -1) {
          continue;
        }
        final key = line.substring(0, separatorIndex).toUpperCase();
        final value = line.substring(separatorIndex + 1).trim();
        result[key] = value;
      }

      result['name'] = result['FN'] ?? result['N'] ?? '';
      result['email'] = result['EMAIL'] ?? '';
      result['phone'] = result['TEL'] ?? '';
      result['titleWork'] = result['TITLE'] ?? result['ORG'] ?? '';
      result['location'] = result['ADR'] ?? result['LOCATION'] ?? '';
    } else if (normalized.toUpperCase().startsWith('MECARD:')) {
      final payload = normalized.substring(7);
      final entries = payload.split(';');
      final mecardData = <String, String>{};
      for (final entry in entries) {
        if (entry.isEmpty || !entry.contains(':')) {
          continue;
        }
        final separatorIndex = entry.indexOf(':');
        final key = entry.substring(0, separatorIndex).toUpperCase();
        final value = entry.substring(separatorIndex + 1).trim();
        mecardData[key] = value;
      }

      result['name'] = mecardData['N'] ?? '';
      result['email'] = mecardData['EMAIL'] ?? '';
      result['phone'] = mecardData['TEL'] ?? '';
      result['titleWork'] = mecardData['ORG'] ?? '';
      result['location'] = mecardData['ADR'] ?? '';
    } else {
      result['notes'] = normalized;
    }

    return result;
  }

  void _saveScannedContact() {
    final qrData = _scannedQrRawData;
    if (qrData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No QR code data to save'), backgroundColor: Colors.red));
        _clearScannedData();
      }
      return;
    }

    final details = _scannedContactDetails ?? {};

    final sanitizedPhone = _valueOrNA(details['phone']);
    final sanitizedEmail = _valueOrNA(details['email']);
    final sanitizedName = _valueOrNA(details['name']);
    final sanitizedTitle = _valueOrNA(details['titleWork']);
    final sanitizedLocation = _valueOrNA(details['location']);
    final sanitizedNotes = _valueOrNA(details['notes']);

    _qrCubit.saveQrCode(
      qrCodeData: qrData,
      phone: sanitizedPhone,
      email: sanitizedEmail,
      name: sanitizedName,
      titleWork: sanitizedTitle,
      notes: sanitizedNotes,
      location: sanitizedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _qrCubit,
      child: BlocListener<QrCubit, QrState>(
        listener: (context, state) {
          if (state is QrLoading) {
            if (mounted) {
              setState(() {
                _isSaving = true;
              });
            }
          } else if (state is QrSuccess) {
            if (mounted) {
              setState(() {
                _isSaving = false;
              });
              _clearScannedData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact saved successfully'), backgroundColor: Colors.green));
            }
          } else if (state is QrError) {
            if (mounted) {
              setState(() {
                _isSaving = false;
              });
              _clearScannedData();
              _showServerError(state.error);
            }
          } else if (state is QrInitial) {
            if (mounted) {
              setState(() {
                _isSaving = false;
              });
            }
          }
        },
        child: Scaffold(
          backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
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
                                        width: 280,
                                        height: 280,
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
                                  // height: 280,
                                  // width: 280,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                                  ),
                                  child: QrImageView(
                                    data: _generateQrData(),
                                    // size: 190.0,
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.black,
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
                                          userCacheValue?.data?.user?.profile?.firstName?.substring(0, 1) ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${userCacheValue?.data?.user?.profile?.firstName} ${userCacheValue?.data?.user?.profile?.lastName}',
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: darkModeValue ? AppColors.white : AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              userCacheValue?.data?.user?.profile?.titleWork ?? '',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              userCacheValue?.data?.user?.profile?.titleWork ?? '',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
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
                                  _buildContactRow(AppIcons.email, userCacheValue?.data?.user?.profile?.email ?? ''),
                                  const SizedBox(height: 8),
                                  _buildContactRow(AppIcons.call, userCacheValue?.data?.user?.phone ?? ''),
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
                    onPressed: _isSaving ? null : _openQrScanner,
                    icon:
                        _isSaving
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                            )
                            : const Icon(Icons.qr_code_scanner, color: AppColors.primaryColor, size: 24),
                    // padding: const EdgeInsets.symmetric(horizontal: 12),
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    tooltip: 'Scan QR Code',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String icon, String text) {
    return Row(
      children: [
        SvgPicture.asset(icon, color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: darkModeValue ? Colors.grey[300] : Colors.grey[700])),
        ),
      ],
    );
  }
}
