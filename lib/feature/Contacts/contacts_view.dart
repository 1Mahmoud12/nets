import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/component/search_widget.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/utils.dart';

import '../../core/component/custom_drop_down_menu.dart';
import '../../core/utils/constant_gaping.dart';

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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Calling $phone...'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}

void sendMessage(Map<String, String> contact, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Opening chat with ${contact['name']}...'),
      backgroundColor: AppColors.primaryColor,
      duration: const Duration(seconds: 2),
    ),
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
  final TextEditingController datePick = TextEditingController();
  // Demo contacts data
  final List<Map<String, String>> allContacts = [
    {
      'name': 'Ahmed Hassan',
      'phone': '+20 123 456 7890',
      'email': 'ahmed.hassan@email.com',
      'status': 'online',
    },
    {
      'name': 'Sarah Johnson',
      'phone': '+1 234 567 8901',
      'email': 'sarah.j@email.com',
      'status': 'offline',
    },
    {
      'name': 'Mohammed Ali',
      'phone': '+966 50 123 4567',
      'email': 'm.ali@email.com',
      'status': 'online',
    },
    {
      'name': 'Fatima Zahra',
      'phone': '+971 50 987 6543',
      'email': 'fatima.z@email.com',
      'status': 'away',
    },
    {
      'name': 'David Wilson',
      'phone': '+44 20 7123 4567',
      'email': 'david.w@email.com',
      'status': 'online',
    },
    {
      'name': 'Aisha Rahman',
      'phone': '+92 300 123 4567',
      'email': 'aisha.r@email.com',
      'status': 'offline',
    },
    {
      'name': 'James Brown',
      'phone': '+1 555 123 4567',
      'email': 'james.b@email.com',
      'status': 'online',
    },
    {
      'name': 'Noor Al-Mansouri',
      'phone': '+971 55 123 4567',
      'email': 'noor.m@email.com',
      'status': 'away',
    },
   
    {
      'name': 'Omar Khalil',
      'phone': '+20 100 123 4567',
      'email': 'omar.k@email.com',
      'status': 'offline',
    },
   
    {
      'name': 'Youssef Ibrahim',
      'phone': '+20 101 234 5678',
      'email': 'youssef.i@email.com',
      'status': 'away',
    },
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
        border: Border.all(
          color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(darkModeValue ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => showContactDetails(contact, context),
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
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
                          border: Border.all(
                            color:
                                darkModeValue
                                    ? AppColors.darkModeColor
                                    : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name']!,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              darkModeValue ? AppColors.white : AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.call,

                            color:
                                darkModeValue
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              contact['phone']!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                color:
                                    darkModeValue
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.email,

                            color:
                                darkModeValue
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contact['email']!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                color:
                                    darkModeValue
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                fontSize: 12,
                              ),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 10,
                        onPressed: () => makeCall(contact['phone']!, context),
                        icon: SvgPicture.asset(
                          AppIcons.call,
                          color: AppColors.green,
                        ),
                        tooltip: 'Call',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => sendMessage(contact, context),
                        icon: SvgPicture.asset(
                          AppIcons.message,
                          color: AppColors.primaryColor,
                        ),
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
    customShowToast(context, 'Add new contact functionality would open here');
  }

  void showFiltersContact(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: darkModeValue ? AppColors.darkModeColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filters',
                              style: Theme.of(
                                context,
                              ).textTheme.displaySmall?.copyWith(
                                color:
                                    darkModeValue
                                        ? AppColors.white
                                        : AppColors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Journey',

                          selectedItem: DropDownModel(
                            name: 'Select Journey',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime date1 = await customShowDatePicker(
                              context: context,
                            );
                            final formatted = DateFormat(
                              'dd-MM-yyyy',
                              'en',
                            ).format(date1);

                            setState(() {
                              datePick.text = formatted;
                            });
                          },
                          child: CustomTextFormField(
                            enable: false,
                            enableLtr: true,
                            contentPadding: const EdgeInsets.only(left: 20),
                            borderRadius: 8,
                            controller: datePick,
                            nameField: 'Date',
                            hintText: 'Select Date',
                            suffixIcon: SvgPicture.asset(
                              AppIcons.date,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Position',
                          selectedItem: DropDownModel(
                            name: 'Select Position',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Country',

                          selectedItem: DropDownModel(
                            name: 'Select Country',
                            value: 1,
                          ),
                          items: [
                            DropDownModel(name: 'name', value: 1),
                            DropDownModel(name: 'name1', value: 2),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              borderColor: AppColors.transparent,
                              borderRadius: 8,
                              colorText: AppColors.black,
                              backgroundColor: AppColors.primaryColor
                                  .withOpacity(.3),
                              onPress: () {},
                              childText: 'Reset All',
                            ),
                            CustomTextButton(
                              borderColor: AppColors.transparent,

                              borderRadius: 8,
                              colorText: AppColors.white,
                              backgroundColor: AppColors.primaryColor,
                              onPress: () {},
                              childText: 'Apply Filters',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              // Search bar
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Flexible(child: SearchWidget()),
                    w10,
                    GestureDetector(
                      onTap: () => showFiltersContact(context),
                      child: SvgPicture.asset(AppIcons.filtterIcon),
                    ),
                  ],

                  /*  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contacts, phone, or email...',
                      hintStyle: TextStyle(
                        color:
                            darkModeValue ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            darkModeValue ? Colors.grey[400] : Colors.grey[600],
                        size: 20,
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filterContacts();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color:
                                      darkModeValue
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                  size: 18,
                                ),
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(
                      color: darkModeValue ? AppColors.white : AppColors.black,
                      fontSize: 14,
                    ),
                  ) */
                ),
              ),

              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Row(
                    children: [
                      Text(
                        'Contacts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        // onTap:()=> showFiltersContact(context),
                        child: SvgPicture.asset(AppIcons.fillter),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: _addNewContact,
                        child: SvgPicture.asset(AppIcons.addContact),
                      ),
                    ],
                  ),
                ),
              ),

              // Contacts count and filter options
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        '${filteredContacts.length} Contacts',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (filteredContacts.length != allContacts.length)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Filtered',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const Spacer(),
                      // Online contacts indicator
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${filteredContacts.where((c) => c['status'] == 'online').length} online',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  darkModeValue
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Contacts list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (filteredContacts.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color:
                                  darkModeValue
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No contacts found',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color:
                                    darkModeValue
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search terms',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color:
                                    darkModeValue
                                        ? Colors.grey[500]
                                        : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final contact = filteredContacts[index];
                    return _buildContactCard(contact);
                  },
                  childCount:
                      filteredContacts.isEmpty ? 1 : filteredContacts.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: darkModeValue ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: darkModeValue ? AppColors.white : AppColors.black,
                  fontSize: 14,
                ),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contact['name']!,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              darkModeValue ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact['status']!.toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor(contact['status']!),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 32),

                      DetailsRowWidget(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: contact['phone']!,
                      ),
                      DetailsRowWidget(
                        icon: Icons.email,
                        label: 'Email',
                        value: contact['email']!,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  () => makeCall(contact['phone']!, context),
                              icon: const Icon(Icons.call),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
