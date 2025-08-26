import 'package:flutter/material.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/extensions.dart';

class SliderCustom extends StatefulWidget {
  final double valueSlider;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const SliderCustom({super.key, required this.valueSlider, this.activeTrackColor, this.inactiveTrackColor});

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  @override
  Widget build(BuildContext context) {
    final double valueSlider = widget.valueSlider;
    final double activeTrackWidth = (valueSlider / 100) * context.screenWidth;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 10,
          width: context.screenWidth,
          decoration: BoxDecoration(color: AppColors.greyG800, borderRadius: BorderRadius.circular(10)),
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: activeTrackWidth, // This should be the absolute width in pixels
              decoration: BoxDecoration(color: widget.activeTrackColor ?? AppColors.cRed900, borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: widget.activeTrackColor ?? AppColors.cRed900, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  '${valueSlider.toInt()} %',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.scaffoldBackGround, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*
 Expanded(
          child: SliderTheme(
            dataSource: SliderThemeData(
              thumbShape: const RoundSliderOverlayShape(overlayRadius: 1),
              activeTrackColor: AppColors.selectedCharData,
              inactiveTrackColor: AppColors.cLightPlusNumber,
              // trackHeight: context.screenHeight * .017,

              trackShape: CustomTrackShape(),
            ),
            child: Slider(
              max: 100,
              value: valueSlider,
              thumbColor: CAppColors.transparent,
              onChanged: (value) {
                valueSlider = value;
              },
            ),
          ),
        ),
        Text(
          '$valueSlider %',
          style: Styles.style14400.copyWith(color: AppColors.textColorTextFormField),
        ),
*/
