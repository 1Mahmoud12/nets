// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:nets/core/themes/colors.dart';
// import 'qr_scan_result_screen.dart';

// class QrScannerScreen extends StatefulWidget {
//   const QrScannerScreen({super.key});

//   @override
//   State<QrScannerScreen> createState() => _QrScannerScreenState();
// }

// class _QrScannerScreenState extends State<QrScannerScreen> {
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // Open camera immediately when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _requestCameraPermission();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();

//     if (status.isGranted) {
//       _openCamera();
//     } else if (status.isDenied) {
//       _showPermissionDialog();
//     } else if (status.isPermanentlyDenied) {
//       _showSettingsDialog();
//     }
//   }

//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Camera Permission Required'),
//           content: const Text('This app needs camera permission to scan QR codes. Please grant permission to continue.'),
//           actions: [
//             TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _requestCameraPermission();
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSettingsDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Permission Permanently Denied'),
//           content: const Text('Camera permission has been permanently denied. Please enable it in settings to use the camera scanner.'),
//           actions: [
//             TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 openAppSettings();
//               },
//               child: const Text('Open Settings'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _openCamera() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

//       if (photo != null) {
//         // Just show a simple success message without navigation
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo captured successfully!'), duration: Duration(seconds: 2)));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening camera: $e')));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background with camera placeholder
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black, Colors.grey[900]!]),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 200,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
//                     ),
//                     child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.white.withOpacity(0.5)),
//                   ),
//                   const SizedBox(height: 30),
//                   Text('Tap the camera icon to start scanning', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
//                 ],
//               ),
//             ),
//           ),

//           // Top App Bar
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20, bottom: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24)),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       'QR Scanner',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   // Camera button in top right
//                   Container(
//                     decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
//                     child:
//                         _isLoading
//                             ? Container(
//                               padding: const EdgeInsets.all(8),
//                               child: const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
//                               ),
//                             )
//                             : IconButton(
//                               onPressed: _requestCameraPermission,
//                               icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
//                               padding: const EdgeInsets.all(8),
//                               constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
//                             ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Bottom Instructions
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(25)),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.qr_code_scanner, color: AppColors.primaryColor, size: 18),
//                         SizedBox(width: 8),
//                         Text('Tap camera icon to start scanning', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildActionButton(
//                         icon: Icons.photo_library,
//                         label: 'Gallery',
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gallery feature coming soon!')));
//                         },
//                       ),
//                       _buildActionButton(
//                         icon: Icons.history,
//                         label: 'History',
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History feature coming soon!')));
//                         },
//                       ),
//                       _buildActionButton(
//                         icon: Icons.settings,
//                         label: 'Settings',
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings feature coming soon!')));
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(25)),
//             child: Icon(icon, color: Colors.white, size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }
