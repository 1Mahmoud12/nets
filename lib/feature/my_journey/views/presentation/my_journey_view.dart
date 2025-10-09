import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

import '../../../../core/component/buttons/custom_text_button.dart';
import '../../../../core/component/custom_drop_down_menu.dart';
import '../../../../core/network/local/cache.dart';
import '../../../../core/utils/constant_gaping.dart';

class MyJourneyView extends StatefulWidget {
  const MyJourneyView({super.key});

  @override
  State<MyJourneyView> createState() => _MyJourneyViewState();
}

class _MyJourneyViewState extends State<MyJourneyView> {
  TextEditingController search = TextEditingController();

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
                      enableLtr: true,
                      borderRadius: 8,
                      controller: search,
                      hintText: 'search',
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sort by',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: Colors.black87),
                        ),
                        w5,
                        SvgPicture.asset(AppIcons.arrowDown),
                      ],
                    ),
                  ),
                  w5,
                  GestureDetector(
                    onTap: () => showFiltersMyJourney(context),
                    child: SvgPicture.asset(AppIcons.filtterIcon),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2024-05-20',
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "23, Basheer Taleb Al-Rifa'i Street, Jordan",
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.displayMedium?.copyWith(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "23, Basheer Taleb Al-Rifa'i Street, Jordan",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SvgPicture.asset(AppIcons.person),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(AppIcons.person),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(AppIcons.maps),
                      ],
                    ),
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
