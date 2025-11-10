import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/component/fields/custom_text_form_field.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    this.onChange,
    this.onTap,
    this.hintText,
    this.controller,
    this.initialText,
    this.showClearButton = false,
    this.onClear,
    this.focusNode,
  });

  final Function(String value)? onChange;
  final Function()? onTap;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialText;
  final bool showClearButton;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final TextEditingController _controller;
  late final bool _isExternalController;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
    if ((widget.initialText ?? '').isNotEmpty && _controller.text != widget.initialText) {
      _controller.text = widget.initialText!;
    }
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant SearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isExternalController && (widget.initialText ?? '').isNotEmpty && _controller.text != widget.initialText) {
      _controller.text = widget.initialText!;
    }
  }

  void _handleControllerChanged() {
    if (mounted && widget.showClearButton) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChange?.call('');
    widget.onClear?.call();
    widget.focusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: IntrinsicHeight(
        child: CustomTextFormField(
          enableLtr: true,
          fontSizeHintText: 12,
          enable: widget.onTap == null,
          outPadding: EdgeInsets.zero,
          height: 45,
          focusedBorderColor: AppColors.primaryColor,
          enabledBorder: AppColors.greyG200,
          fillColor: AppColors.white,
          controller: _controller,
          focusNode: widget.focusNode,
          hintText: widget.hintText ?? 'Search contacts, phone, or email',
          labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.cP50.withAlpha((0.5 * 255).toInt()),
              ),
          onChange: (value) {
            widget.onChange?.call(value);
            if (widget.showClearButton && mounted) {
              setState(() {});
            }
          },
          borderRadius: 8,
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: context.locale.languageCode == 'ar' ? 8 : 8,
                  right: context.locale.languageCode == 'ar' ? 8 : 8,
                ),
                child: SvgPicture.asset(AppIcons.unselectedDiscoverDarkMode),
              ),
            ],
          ),
          suffixIcon: widget.showClearButton && _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(Icons.close, size: 18, color: AppColors.grey),
                )
              : null,
        ),
      ),
    );
  }
}
