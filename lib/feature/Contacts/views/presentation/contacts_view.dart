import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/buttons/custom_text_button.dart';
import 'package:nets/core/component/cache_image.dart';
import 'package:nets/core/component/custom_check_button.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/component/search_widget.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/utils.dart';

import '../../../../core/component/custom_drop_down_menu.dart';
import '../../../../core/utils/constant_gaping.dart';
import '../../data/models/contact_model.dart';
import '../manager/cubit/contacts_cubit.dart';
import 'widgets/build_contact_card.dart';

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

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final TextEditingController datePick = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isChack = false;
  Timer? _searchDebounce;
  bool _isSearchActive = false;
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ContactsCubit>().fetchContacts();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    datePick.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final searchValue = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || searchValue == _lastSearch) return;
      _lastSearch = searchValue;
      setState(() {
        _isSearchActive = searchValue.isNotEmpty;
      });
      context.read<ContactsCubit>().fetchContacts(search: searchValue.isEmpty ? null : searchValue);
    });
  }

  void _onSearchCleared() {
    _searchDebounce?.cancel();
    if (!mounted) return;
    _lastSearch = '';
    setState(() {
      _isSearchActive = false;
    });
    _searchFocusNode.requestFocus();
    context.read<ContactsCubit>().fetchContacts();
  }

  // ignore: unused_element
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filters',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black),
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

                          selectedItem: DropDownModel(name: 'Select Journey', value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime date1 = await customShowDatePicker(context: context);
                            final formatted = DateFormat('dd-MM-yyyy', 'en').format(date1);

                            setState(() {
                              datePick.text = formatted;
                            });
                          },
                          child: CustomTextFormField(
                            enable: false,
                            contentPadding: const EdgeInsets.only(left: 20),
                            borderRadius: 8,
                            controller: datePick,
                            nameField: 'Date',
                            hintText: 'Select Date',
                            suffixIcon: SvgPicture.asset(AppIcons.date, fit: BoxFit.scaleDown),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Position',
                          selectedItem: DropDownModel(name: 'Select Position', value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Country',

                          selectedItem: DropDownModel(name: 'Select Country', value: 1),
                          items: [DropDownModel(name: 'name', value: 1), DropDownModel(name: 'name1', value: 2)],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              borderColor: AppColors.transparent,
                              borderRadius: 8,
                              colorText: AppColors.black,
                              backgroundColor: AppColors.primaryColor.withOpacity(.3),
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

  // ignore: unused_element
  void _showManualSync() {
    showModalBottomSheet(
      context: context,
      backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manual Sync',
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(color: darkModeValue ? Colors.white : Colors.black, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: darkModeValue ? Colors.white : Colors.black),
                        ),
                      ],
                    ),

                    Text(
                      'Select contacts to sync with your device',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: darkModeValue ? AppColors.white : null),
                    ),
                    const SizedBox(height: 10),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustomCheckButton(
                          isChecked: isChack,
                          borderRadius: 8,
                          checkedColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setModalState(() {
                              isChack = value;
                            });
                          },
                        ),
                        w10,
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CacheImage(
                            circle: true,
                            fit: BoxFit.fill,

                            // width: 40,
                            // height: 40,
                            urlImage: 'https://th.bing.com/th?id=ORMS.f8a57fea0b8def32ea24303ea978f5a7&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=1&p=0',
                          ),
                        ),
                        w10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Ali',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'HR Manager',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        CustomCheckButton(
                          isChecked: isChack,
                          borderRadius: 8,
                          checkedColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setModalState(() {
                              isChack = value;
                            });
                          },
                        ),
                        w10,
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CacheImage(
                            circle: true,
                            fit: BoxFit.fill,

                            // width: 40,
                            // height: 40,
                            urlImage: 'https://th.bing.com/th?id=ORMS.f8a57fea0b8def32ea24303ea978f5a7&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=1&p=0',
                          ),
                        ),
                        w10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Ali',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'HR Manager',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            borderColor: AppColors.transparent,
                            borderRadius: 8,
                            colorText: AppColors.black,
                            backgroundColor: AppColors.primaryColor.withOpacity(.1),
                            onPress: () {
                              Navigator.pop(context);
                            },
                            childText: 'Cancel',
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomTextButton(
                            borderColor: AppColors.transparent,

                            borderRadius: 8,
                            colorText: AppColors.white,
                            backgroundColor: isChack ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(.3),
                            onPress: () {},
                            childText: 'Sync Now (${isChack ? 2 : 0})',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  void _showDuplicateContact() {
    showModalBottomSheet(
      context: context,
      backgroundColor: darkModeValue ? AppColors.darkModeColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Duplicate Contact Found',
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(color: darkModeValue ? Colors.white : Colors.black, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: darkModeValue ? Colors.white : Colors.black),
                        ),
                      ],
                    ),

                    Text(
                      'We found a contact with similar information. Would you like to merge them?',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: darkModeValue ? AppColors.white : null),
                    ),
                    const SizedBox(height: 10),
                    _buildDivider(indent: 5),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CacheImage(
                            circle: true,
                            fit: BoxFit.fill,

                            // width: 40,
                            // height: 40,
                            urlImage: 'https://th.bing.com/th?id=ORMS.f8a57fea0b8def32ea24303ea978f5a7&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=1&p=0',
                          ),
                        ),
                        w10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Ali',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'HR Manager',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        CustomCheckButton(
                          isChecked: isChack,
                          borderRadius: 8,
                          checkedColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setModalState(() {
                              isChack = value;
                            });
                          },
                        ),
                        w10,
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CacheImage(
                            circle: true,
                            fit: BoxFit.fill,

                            // width: 40,
                            // height: 40,
                            urlImage: 'https://th.bing.com/th?id=ORMS.f8a57fea0b8def32ea24303ea978f5a7&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=1&p=0',
                          ),
                        ),
                        w10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Ali',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'HR Manager',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: darkModeValue ? AppColors.white : AppColors.black, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            borderColor: AppColors.transparent,
                            borderRadius: 8,
                            colorText: AppColors.black,
                            backgroundColor: AppColors.primaryColor.withOpacity(.1),
                            onPress: () {
                              Navigator.pop(context);
                            },
                            childText: 'Cancel',
                          ),
                        ),
                        w10,
                        Expanded(
                          child: CustomTextButton(
                            borderColor: AppColors.transparent,

                            borderRadius: 8,
                            colorText: AppColors.white,
                            backgroundColor: isChack ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(.3),
                            onPress: () {},
                            childText: 'Sync Now (${isChack ? 2 : 0})',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDivider({double indent = 60}) {
    return Divider(height: 1, color: darkModeValue ? Colors.grey[700] : Colors.grey[200], indent: indent, endIndent: 20);
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = context.watch<ContactsCubit>().state;
    final bool isLoading = contactsState is ContactsLoading;
    final bool isError = contactsState is ContactsError;
    final String? errorMessage = isError ? contactsState.message : null;

    List<Data> contacts = [];
    if (contactsState is ContactsSuccess) {
      contacts = contactsState.contacts.data ?? [];
    } else if (ConstantsModels.contactsModel?.data != null) {
      contacts = ConstantsModels.contactsModel!.data!;
    }

    Widget child;
    if (isLoading && contacts.isEmpty) {
      child = const Center(child: CircularProgressIndicator());
    } else if (isError && contacts.isEmpty) {
      child = _buildErrorState(context, errorMessage ?? 'Something went wrong');
    } else {
      child = _buildContent(context, contacts, isLoading: isLoading, isError: isError, errorMessage: errorMessage);
    }

    return Scaffold(
      backgroundColor: darkModeValue ? AppColors.appBarDarkModeColor : AppColors.white,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: child)),
    );
  }

  Widget _buildContent(BuildContext context, List<Data> contacts, {required bool isLoading, required bool isError, String? errorMessage}) {
    final int totalCount = contacts.length;
    final int onlineCount = contacts.where((contact) => (contact.status ?? contact.notes ?? '').toLowerCase() == 'online').length;

    return CustomScrollView(
      slivers: [
        if (isLoading) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(bottom: 12), child: LinearProgressIndicator(minHeight: 2))),
        if (isError && errorMessage != null)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: darkModeValue ? AppColors.white : Colors.red.shade700),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<ContactsCubit>().fetchContacts(search: _lastSearch.isEmpty ? null : _lastSearch),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              Flexible(
                child: SearchWidget(
                  controller: _searchController,
                  onChange: _onSearchChanged,
                  onClear: _onSearchCleared,
                  showClearButton: true,
                  focusNode: _searchFocusNode,
                ),
              ),
              // w10,
              // GestureDetector(onTap: () => showFiltersContact(context), child: SvgPicture.asset(AppIcons.filtterIcon)),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, top: 20),
            child: SizedBox.shrink(),
            // child: Row(
            //   children: [
            //     Text(
            //       'contacts'.tr(),
            //       style: Theme.of(
            //         context,
            //       ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.white : AppColors.black),
            //     ),
            //     const Spacer(),
            //     GestureDetector(onTap: () => _showManualSync(), child: SvgPicture.asset(AppIcons.fillter)),
            //     const SizedBox(width: 5),
            //     GestureDetector(onTap: _addNewContact, child: SvgPicture.asset(AppIcons.addContact)),
            //   ],
            // ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Text(
                  '$totalCount ${'contacts'.tr()}',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w400, color: darkModeValue ? AppColors.white : AppColors.black),
                ),
                const SizedBox(width: 16),
                if (_isSearchActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Filtered',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                const Spacer(),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(
                      '$onlineCount ${'online'.tr()}',
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
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (contacts.isEmpty) {
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

            final contact = contacts[index];
            return buildContactCard(contact, context);
          }, childCount: contacts.isEmpty ? 1 : contacts.length),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: darkModeValue ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 16),
          CustomTextButton(
            borderColor: AppColors.transparent,
            borderRadius: 8,
            colorText: AppColors.white,
            backgroundColor: AppColors.primaryColor,
            onPress: () => context.read<ContactsCubit>().fetchContacts(search: _lastSearch.isEmpty ? null : _lastSearch),
            childText: 'retry'.tr(),
          ),
        ],
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

void showContactDetails(Data contact, BuildContext context) {
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
                          (contact.name ?? 'N/A').split(' ').where((element) => element.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contact.name ?? 'N/A',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: darkModeValue ? AppColors.white : AppColors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (contact.status ?? contact.notes ?? 'offline').toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor((contact.status ?? contact.notes ?? 'offline').toLowerCase()),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 32),

                      DetailsRowWidget(icon: Icons.phone, label: 'Phone', value: contact.phone ?? '—'),
                      DetailsRowWidget(icon: Icons.email, label: 'Email', value: contact.email ?? '—'),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
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
                              onPressed: () {},
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
