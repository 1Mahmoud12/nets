import 'package:flutter/material.dart';
import 'package:nets/feature/profile/views/presentation/widgets/contact_information_widget.dart';

/// Model class to hold all profile form data
class ProfileDataModel {
  // Personal Information
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController websiteCtrl = TextEditingController();

  // Contact Information
  final TextEditingController zipCtrl = TextEditingController();
  final List<PhoneData> phones = [];

  // Social Media
  final TextEditingController facebookCtrl = TextEditingController();
  final TextEditingController twitterCtrl = TextEditingController();
  final TextEditingController instagramCtrl = TextEditingController();
  final TextEditingController linkedinCtrl = TextEditingController();

  // Address Information
  final TextEditingController streetOfficeCtrl = TextEditingController();
  final TextEditingController buildingOfficeCtrl = TextEditingController();
  final TextEditingController officeNumberOfficeCtrl = TextEditingController();

  // Additional Information
  final TextEditingController otherDetailsCtrl = TextEditingController();

  // Profile Image
  String? profileImageUrl;

  /// Dispose all controllers
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    zipCtrl.dispose();
    facebookCtrl.dispose();
    twitterCtrl.dispose();
    instagramCtrl.dispose();
    linkedinCtrl.dispose();
    streetOfficeCtrl.dispose();
    buildingOfficeCtrl.dispose();
    officeNumberOfficeCtrl.dispose();
    otherDetailsCtrl.dispose();

    // Dispose phone controllers
    for (final phone in phones) {
      phone.controller.dispose();
      phone.typeController.dispose();
    }
  }
}

