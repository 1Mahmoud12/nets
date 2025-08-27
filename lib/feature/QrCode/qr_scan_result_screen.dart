import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/network/local/cache.dart';

class QrScanResultScreen extends StatelessWidget {
  final String scannedData;

  const QrScanResultScreen({super.key, required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      appBar: AppBar(
        title: Text('QR Scan Result', style: TextStyle(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold)),
        backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkModeValue ? AppColors.white : AppColors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text(
                  'QR Code Detected!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                ),
              ),
              const SizedBox(height: 30),

              // Scanned Data Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: darkModeValue ? AppColors.darkModeColor : Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.qr_code_scanner, color: AppColors.primaryColor, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Scanned Data',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: darkModeValue ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkModeValue ? Colors.grey[600]! : Colors.grey[300]!),
                      ),
                      child: SelectableText(
                        scannedData,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[300] : Colors.grey[700], fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Scan Another'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Go Home'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
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
