import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'online':
      return Colors.green;
    case 'away':
      return Colors.orange;
    case 'offline':
    default:
      return Colors.grey;
  }
}

void makeCall(String phone, BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Calling $phone...'), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));
}

void sendMessage(Map<String, String> contact, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Opening chat with ${contact['name']}...'), backgroundColor: AppColors.primaryColor, duration: const Duration(seconds: 2)),
  );
}

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredContacts = [];

  // Demo contacts data
  final List<Map<String, String>> allContacts = [
    {'name': 'Ahmed Hassan', 'phone': '+20 123 456 7890', 'email': 'ahmed.hassan@email.com', 'status': 'online'},
    {'name': 'Sarah Johnson', 'phone': '+1 234 567 8901', 'email': 'sarah.j@email.com', 'status': 'offline'},
    {'name': 'Mohammed Ali', 'phone': '+966 50 123 4567', 'email': 'm.ali@email.com', 'status': 'online'},
    {'name': 'Fatima Zahra', 'phone': '+971 50 987 6543', 'email': 'fatima.z@email.com', 'status': 'away'},
    {'name': 'David Wilson', 'phone': '+44 20 7123 4567', 'email': 'david.w@email.com', 'status': 'online'},
    {'name': 'Aisha Rahman', 'phone': '+92 300 123 4567', 'email': 'aisha.r@email.com', 'status': 'offline'},
    {'name': 'James Brown', 'phone': '+1 555 123 4567', 'email': 'james.b@email.com', 'status': 'online'},
    {'name': 'Noor Al-Mansouri', 'phone': '+971 55 123 4567', 'email': 'noor.m@email.com', 'status': 'away'},
    {'name': 'Emily Davis', 'phone': '+1 415 123 4567', 'email': 'emily.d@email.com', 'status': 'online'},
    {'name': 'Omar Khalil', 'phone': '+20 100 123 4567', 'email': 'omar.k@email.com', 'status': 'offline'},
    {'name': 'Lisa Anderson', 'phone': '+1 310 555 0123', 'email': 'lisa.a@email.com', 'status': 'online'},
    {'name': 'Youssef Ibrahim', 'phone': '+20 101 234 5678', 'email': 'youssef.i@email.com', 'status': 'away'},
  ];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(allContacts);
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts =
          allContacts.where((contact) {
            return contact['name']!.toLowerCase().contains(query) ||
                contact['phone']!.contains(query) ||
                contact['email']!.toLowerCase().contains(query);
          }).toList();
    });
  }

  Widget _buildContactCard(Map<String, String> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: darkModeValue ? AppColors.darkModeColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(darkModeValue ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => showContactDetails(contact, context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with status indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryColor,
                      child: Text(
                        contact['name']!.split(' ').map((e) => e[0]).join(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: getStatusColor(contact['status']!),
                          shape: BoxShape.circle,
                          border: Border.all(color: darkModeValue ? AppColors.darkModeColor : Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: darkModeValue ? AppColors.white : AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 14, color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contact['phone']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.email, size: 14, color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contact['email']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        onPressed: () => makeCall(contact['phone']!, context),
                        icon: const Icon(Icons.call, color: Colors.green, size: 20),
                        tooltip: 'Call',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        onPressed: () => sendMessage(contact, context),
                        icon: const Icon(Icons.message, color: AppColors.primaryColor, size: 20),
                        tooltip: 'Message',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewContact() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add new contact functionality would open here'), duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Contacts',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        onPressed: _addNewContact,
                        icon: const Icon(Icons.person_add, color: AppColors.primaryColor),
                        tooltip: 'Add Contact',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: darkModeValue ? AppColors.darkModeColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: darkModeValue ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contacts, phone, or email...',
                      hintStyle: TextStyle(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: darkModeValue ? Colors.grey[400] : Colors.grey[600], size: 20),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filterContacts();
                                },
                                icon: Icon(Icons.clear, color: darkModeValue ? Colors.grey[400] : Colors.grey[600], size: 18),
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: darkModeValue ? AppColors.white : AppColors.black, fontSize: 14),
                  ),
                ),
              ),
            ),

            // Contacts count and filter options
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      '${filteredContacts.length} Contacts',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: darkModeValue ? AppColors.white : AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (filteredContacts.length != allContacts.length)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Filtered', style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    const Spacer(),
                    // Online contacts indicator
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(
                          '${filteredContacts.where((c) => c['status'] == 'online').length} online',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Contacts list
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (filteredContacts.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 64, color: darkModeValue ? Colors.grey[600] : Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No contacts found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search terms',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: darkModeValue ? Colors.grey[500] : Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                final contact = filteredContacts[index];
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: index == filteredContacts.length - 1 ? 20 : 0),
                  child: _buildContactCard(contact),
                );
              }, childCount: filteredContacts.isEmpty ? 1 : filteredContacts.length),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({super.key, required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: darkModeValue ? Colors.grey[400] : Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: darkModeValue ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showContactDetails(Map<String, String> contact, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(
                          contact['name']!.split(' ').map((e) => e[0]).join(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contact['name']!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact['status']!.toUpperCase(),
                        style: TextStyle(color: getStatusColor(contact['status']!), fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(height: 32),

                      DetailsRowWidget(icon: Icons.phone, label: 'Phone', value: contact['phone']!),
                      DetailsRowWidget(icon: Icons.email, label: 'Email', value: contact['email']!),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => makeCall(contact['phone']!, context),
                              icon: const Icon(Icons.call),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => sendMessage(contact, context),
                              icon: const Icon(Icons.message),
                              label: const Text('Message'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}
