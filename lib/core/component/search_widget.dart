import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, this.onChange, this.onTap, this.hintText});

  final Function(String value)? onChange;
  final Function()? onTap;
  final String? hintText;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: IntrinsicHeight(
        child: CustomTextFormField(
          enable: widget.onTap == null,
          outPadding: EdgeInsets.zero,
          //  contentPadding: const EdgeInsets.symmetric(vertical: 16),
          focusedBorderColor: AppColors.primaryColor,
          enabledBorder: AppColors.cBorderButtonColor,
          fillColor: AppColors.white,
          controller: controller,
          hintText: 'search_hint'.tr(),
          labelText: (widget.hintText ?? 'search').tr(),
          labelStyle: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400, color: AppColors.cP50.withAlpha((0.5 * 255).toInt())),

          onChange: (value) {
            widget.onChange?.call(value);
          },
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: context.locale.languageCode == 'ar' ? 8 : 24, right: context.locale.languageCode == 'ar' ? 24 : 8),
                child: SvgPicture.asset(AppIcons.appLogo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
