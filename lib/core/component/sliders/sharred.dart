// import 'package:flutter/material.dart';
//
// class CustomTrackShape extends RoundedRectSliderTrackShape {
//   @override
//   Rect getPreferredRect({
//     required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final trackHeight = sliderTheme.trackHeight;
//     final trackLeft = offset.dx;
//     final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
//     final trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop * .2, trackWidth, trackHeight * 1.2);
//   }
// }

import 'package:flutter/material.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 0,
    Offset? secondaryOffset,
  }) {
    assert(sliderTheme.trackHeight != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);

    final trackHeight = sliderTheme.trackHeight!;
    final activeTrackHeight = trackHeight; // Active track height
    final inactiveTrackHeight = trackHeight * 1.5; // Inactive track is thicker

    final trackRect = getPreferredRect(parentBox: parentBox, offset: offset, sliderTheme: sliderTheme, isEnabled: isEnabled, isDiscrete: isDiscrete);

    final activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top + (inactiveTrackHeight - activeTrackHeight) / 200,
      thumbCenter.dx,
      trackRect.bottom - (inactiveTrackHeight - activeTrackHeight) / 200,
    );

    final inactiveTrackRect = Rect.fromLTRB(thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);

    final activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;

    // Draw the thicker inactive track
    context.canvas.drawRect(inactiveTrackRect, inactivePaint);

    // Draw the thinner active track
    context.canvas.drawRect(activeTrackRect, activePaint);
  }
}
