import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/constant_gaping.dart';
import 'package:nets/feature/my_journey/data/models/journy_model.dart';

import '../../../../core/component/buttons/custom_text_button.dart';
import '../../../../core/component/custom_drop_down_menu.dart';
import '../../../../core/network/local/cache.dart';
import '../manager/cubit/my_journey_cubit.dart';

class MyJourneyView extends StatefulWidget {
  const MyJourneyView({super.key});

  @override
  State<MyJourneyView> createState() => _MyJourneyViewState();
}

class _MyJourneyViewState extends State<MyJourneyView> {
  TextEditingController search = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyJourneyCubit>().fetchJourneys();
    });
  }

  @override
  void dispose() {
    search.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<MyJourneyCubit>().fetchJourneys(search: value.trim().isEmpty ? null : value.trim());
  }

  void _onSearchCleared() {
    context.read<MyJourneyCubit>().fetchJourneys();
    _searchFocusNode.requestFocus();
  }

  void showFiltersMyJourney(BuildContext context) {
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
                        const SizedBox(height: 8),
                        CustomDropDownMenu(
                          borderRadius: 8,
                          nameField: 'Journey',

                          selectedItem: DropDownModel(name: 'Select Journey', value: 1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBackGround,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      fillColor: AppColors.white,
                      borderRadius: 8,
                      controller: search,
                      hintText: 'search',
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusNode: _searchFocusNode,
                      onChange: _onSearchChanged,
                      suffixIcon:
                          search.text.isNotEmpty
                              ? IconButton(
                                onPressed: () {
                                  search.clear();
                                  _onSearchCleared();
                                },
                                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sort by', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
                        w5,
                        SvgPicture.asset(AppIcons.arrowDown),
                      ],
                    ),
                  ),
                  w5,
                  GestureDetector(onTap: () => showFiltersMyJourney(context), child: SvgPicture.asset(AppIcons.filtterIcon)),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<MyJourneyCubit, MyJourneyState>(
                listener: (context, state) {
                  if (state is MyJourneyError) {
                    customShowToast(context, state.message, showToastStatus: ShowToastStatus.error);
                  }
                },
                builder: (context, state) {
                  final bool isLoading = state is MyJourneyLoading;
                  final bool hasError = state is MyJourneyError;
                  final journeys = state is MyJourneySuccess ? state.journeys.data ?? [] : ConstantsModels.journeyModel?.data ?? [];

                  if (isLoading && journeys.isEmpty) {
                    return const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator());
                  }

                  if ((journeys.isEmpty && !isLoading) || hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          SvgPicture.asset(AppIcons.emptyJourney),
                          const SizedBox(height: 16),
                          Text(
                            hasError ? 'Failed to load journeys' : 'No Journey Yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (isLoading) const LinearProgressIndicator(minHeight: 2),
                      ...journeys.map((journey) => MyJourneyCard(journey)).toList(),
                    ],
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class MyJourneyCard extends StatelessWidget {
  final JourneyData myJourney;
  const MyJourneyCard(this.myJourney, {super.key});

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(myJourney.journeyDate);
    final List<String> participants = (myJourney.persons ?? []).map((person) => person.name ?? '').where((name) => name.isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateText, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 6),
                Text(myJourney.address ?? '', style: Theme.of(context).textTheme.displayMedium?.copyWith()),
                const SizedBox(height: 4),
                Text(myJourney.description ?? myJourney.address ?? '', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                if (participants.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children:
                        participants
                            .map(
                              (name) => Chip(
                                label: Text(name, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white)),
                                padding: EdgeInsets.zero,
                                backgroundColor: AppColors.primaryColor,
                              ),
                            )
                            .toList(),
                  )
                else
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.person),
                      const SizedBox(width: 4),
                      Text('No participants', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.maps),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '—';
    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      return date;
    }
  }
}
