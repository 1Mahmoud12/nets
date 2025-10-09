// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:nets/core/utils/app_icons.dart';

// import '../themes/colors.dart';
// import 'search_widget.dart';

// class SearchFilterBar extends StatelessWidget {
//   final TextEditingController? searchController;
//   final VoidCallback onFilterTap;
//   final Function(String)? onSearchChanged;
//   final String hintText;

//   const SearchFilterBar({
//     super.key,
//     this.searchController,
//     required this.onFilterTap,
//     this.onSearchChanged,
//     this.hintText = 'Search',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const SearchWidget(),
//         SvgPicture.asset(AppIcons.call, color: AppColors.green),
//       ],
//     );
//   }
// }
