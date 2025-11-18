import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nets/core/themes/colors.dart';

class QrCameraScanner extends StatefulWidget {
  const QrCameraScanner({super.key});

  @override
  State<QrCameraScanner> createState() => _QrCameraScannerState();
}

class _QrCameraScannerState extends State<QrCameraScanner> {
  final MobileScannerController _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool _isProcessing = false;
  bool _torchEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isProcessing) {
      return;
    }

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      return;
    }

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Navigator.of(context).pop(rawValue);
  }

  Future<void> _toggleTorch() async {
    final hasTorch = _controller.torchEnabled;
    if (!hasTorch) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('torch_not_available'.tr())));
      return;
    }

    await _controller.toggleTorch();
    if (!mounted) return;

    setState(() {
      _torchEnabled = !_torchEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('scan_qr_code'.tr()),
        actions: [IconButton(onPressed: _toggleTorch, icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off))],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: MobileScanner(controller: _controller, onDetect: _handleDetection)),
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('position_qr_code_inside_frame'.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text('scanning_will_happen_automatically'.tr(), style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
