import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/network/local/cache.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
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
                        color: darkModeValue ? AppColors.white : AppColors.black,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // User Email
                    Text(
                      'john.doe@example.com',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    // Edit Profile Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Edit profile functionality
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
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
                  color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
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
                  color: darkModeValue ? AppColors.darkModeColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.security,
                      title: 'Privacy & Security',
                      subtitle: 'Manage your privacy settings',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.language, title: 'Language', subtitle: 'English (US)', onTap: () {}),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: 'Toggle dark theme',
                      onTap: () {},
                      trailing: Switch(
                        value: darkModeValue,
                        onChanged: (value) {
                          // Toggle dark mode functionality
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.help, title: 'Help & Support', subtitle: 'Get help and contact support', onTap: () {}),
                    _buildDivider(),
                    _buildSettingsItem(context, icon: Icons.info, title: 'About', subtitle: 'App version 1.0.0', onTap: () {}),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logout functionality
                  },
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
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
        ),
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
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: darkModeValue ? AppColors.white : AppColors.black, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: darkModeValue ? Colors.grey[400] : Colors.grey[600], size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: darkModeValue ? Colors.grey[700] : Colors.grey[200], indent: 60, endIndent: 20);
  }
}
