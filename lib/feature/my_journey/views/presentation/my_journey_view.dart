import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;

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

  void _fetchJourneys() {
    context.read<MyJourneyCubit>().fetchJourneys(
      search: search.text.trim().isEmpty ? null : search.text.trim(),
      startDate: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
      endDate: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null,
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _fetchJourneys();
  }

  void _onSearchCleared() {
    if (search.text.isEmpty) return;
    setState(() {
      search.clear();
    });
    FocusScope.of(context).unfocus();
    _fetchJourneys();
  }

  String _dateRangeLabel() {
    final startText = _startDate != null ? DateFormat('dd MMM yyyy').format(_startDate!) : null;
    final endText = _endDate != null ? DateFormat('dd MMM yyyy').format(_endDate!) : null;
    if (startText != null && endText != null) {
      return '$startText  →  $endText';
    } else if (startText != null) {
      return 'From $startText onwards';
    } else if (endText != null) {
      return 'Until $endText';
    }
    return '';
  }

  Future<DateTime?> _showStyledDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String helpText,
  }) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.headlineSmall?.copyWith(fontSize: 18, color: Colors.white);
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.black);
    final weekDayStyle = theme.textTheme.labelSmall?.copyWith(fontSize: 12, color: AppColors.primaryColor);

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(primary: AppColors.primaryColor, onPrimary: Colors.white, onSurface: AppColors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor)),
            datePickerTheme: theme.datePickerTheme.copyWith(
              headerBackgroundColor: AppColors.primaryColor,
              headerForegroundColor: Colors.white,
              headerHeadlineStyle: headerStyle,
              dayStyle: bodyStyle,
              weekdayStyle: weekDayStyle,
              yearStyle: bodyStyle,
            ),
            textTheme: theme.textTheme.apply(bodyColor: AppColors.black, displayColor: AppColors.black),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Future<void> _openDateFilter() async {
    final now = DateTime.now();
    final DateTime initialStart = _startDate ?? now.subtract(const Duration(days: 30));
    final pickedStart = await _showStyledDatePicker(
      initialDate: initialStart,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: 'Select start date',
    );

    if (pickedStart == null) return;

    final pickedEnd = await _showStyledDatePicker(
      initialDate: (_endDate != null && !_endDate!.isBefore(pickedStart)) ? _endDate! : pickedStart,
      firstDate: pickedStart,
      lastDate: DateTime(now.year + 5),
      helpText: 'Select end date',
    );

    if (pickedEnd == null) return;

    setState(() {
      _startDate = pickedStart;
      _endDate = pickedEnd;
    });

    _fetchJourneys();
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
                              ? IconButton(onPressed: _onSearchCleared, icon: const Icon(Icons.close, size: 18, color: Colors.grey))
                              : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: _openDateFilter, child: SvgPicture.asset(AppIcons.filtterIcon)),
                ],
              ),
              const SizedBox(height: 16),
              if (_startDate != null || _endDate != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: AppColors.primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _dateRangeLabel(),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                          });
                          _fetchJourneys();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
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
