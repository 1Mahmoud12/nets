import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isDarkMode = false;
  bool switcher = false;
  String selectedLanguage = 'English (US)';
  bool notificationsEnabled = true;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor, width: 4),
                        boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // User Name
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // User Email
                    Text(
                      'john.doe@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, 'Contacts', '156'),
                    _buildStatItem(context, 'Groups', '12'),
                    _buildStatItem(context, 'QR Scans', '89'),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Settings Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      onTap: _showNotificationSettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.security,
                      title: 'Privacy & Security',
                      subtitle: 'Manage your privacy settings',
                      onTap: _showPrivacySettings,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.language, title: 'Language', subtitle: selectedLanguage, onTap: _showLanguageSettings),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: 'Toggle dark theme',
                      onTap: () {},
                      trailing: Switch(
                        value: switcher,
                        onChanged: (value) {
                          setState(() {
                            switcher = value;
                            // Here you would typically save this to SharedPreferences or your cache
                            // Cache.saveDarkMode(value);
                          });
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: _showHelpSupport,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.info, title: 'About', subtitle: 'App version 1.0.0', onTap: _showAbout),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Delete Account Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showDeleteAccountDialog,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDarkMode ? AppColors.white : AppColors.black, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.grey[400] : Colors.grey[600], size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: isDarkMode ? Colors.grey[700] : Colors.grey[200], indent: 60, endIndent: 20);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
          title: Text('Logout', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: Text('Are you sure you want to logout?', style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);

                userCacheValue?.data = null;
                userCache?.clear();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
          title: Text('Delete Account', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete your account?', style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your account will be deleted after 30 days. You can recover it within this period.',
                        style: TextStyle(color: Colors.orange[800], fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                await userCache?.put(userCacheKey, null);
                userCacheValue?.data = null;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification Settings',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildNotificationToggle(
                      'Push Notifications',
                      'Receive push notifications',
                      pushNotifications,
                      (value) => setModalState(() => pushNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'Email Notifications',
                      'Receive email notifications',
                      emailNotifications,
                      (value) => setModalState(() => emailNotifications = value),
                    ),
                    _buildNotificationToggle(
                      'SMS Notifications',
                      'Receive SMS notifications',
                      smsNotifications,
                      (value) => setModalState(() => smsNotifications = value),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification settings saved')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Settings', style: TextStyle(color: Colors.white)),
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

  Widget _buildNotificationToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primaryColor),
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy & Security',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
              const SizedBox(height: 20),
              _buildPrivacyItem(Icons.lock, 'Two-Factor Authentication', 'Add an extra layer of security'),
              _buildPrivacyItem(Icons.visibility, 'Profile Visibility', 'Control who can see your profile'),
              _buildPrivacyItem(Icons.block, 'Blocked Users', 'Manage blocked contacts'),
              _buildPrivacyItem(Icons.security, 'Data Encryption', 'Your data is encrypted end-to-end'),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrivacyItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.grey[400] : Colors.grey[600], size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title settings would open here')));
      },
    );
  }

  void _showLanguageSettings() {
    final languages = ['English (US)', 'English (UK)', 'Spanish', 'French', 'German', 'Italian', 'Portuguese', 'Chinese', 'Japanese', 'Arabic'];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = language == selectedLanguage;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        language,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
                      onTap: () {
                        setState(() {
                          selectedLanguage = language;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language changed to $language')));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Help & Support',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildHelpItem(Icons.help_outline, 'FAQ', 'Frequently asked questions'),
                _buildHelpItem(Icons.chat, 'Live Chat', 'Chat with our support team'),
                _buildHelpItem(Icons.email, 'Email Support', 'Send us an email'),
                _buildHelpItem(Icons.phone, 'Call Support', '+1 (555) 123-4567'),
                _buildHelpItem(Icons.bug_report, 'Report a Bug', 'Help us improve the app'),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.grey[400] : Colors.grey[600], size: 16),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title would open here')));
      },
    );
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.apps, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text('NETS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
              const SizedBox(height: 8),
              Text('Version 1.0.0', style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
              const SizedBox(height: 20),
              Text(
                'A modern networking and communication app designed to help you stay connected with your contacts and manage your social network efficiently.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[300] : Colors.grey[700], height: 1.5),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Terms of Service', style: TextStyle(color: AppColors.primaryColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Privacy Policy', style: TextStyle(color: AppColors.primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
