import 'package:flutter/material.dart';

/// Model class for dynamic social media entries
class SocialMediaData {
  final TextEditingController controller;
  final String platform;
  final int? id; // API ID if it exists

  SocialMediaData({
    required this.controller,
    required this.platform,
    this.id,
  });

  /// Dispose the controller
  void dispose() {
    controller.dispose();
  }
}

