import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/themes/colors.dart';

class CustomCheckButton extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color checkedColor;
  final Color uncheckedColor;
  final Color checkColor;
  final double size;
  final double borderRadius;
  final Duration animationDuration;
  final bool enabled;
  final EdgeInsets padding;
  final TextStyle? labelStyle;

  const CustomCheckButton({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.label,
    this.checkedColor = Colors.blue,
    this.uncheckedColor = Colors.grey,
    this.checkColor = Colors.white,
    this.size = 24.0,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.labelStyle,
  });

  @override
  State<CustomCheckButton> createState() => _CustomCheckButtonState();
}

class _CustomCheckButtonState extends State<CustomCheckButton> {
  @override
  void initState() {
    super.initState();
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(!widget.isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: widget.isChecked,
      enabled: widget.enabled,
      child: GestureDetector(
        onTap: _handleTap,
        child: Padding(
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.isChecked ? widget.checkedColor : Colors.transparent,
                  border: Border.all(color: widget.isChecked ? widget.checkedColor : widget.uncheckedColor, width: 2.0),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: widget.isChecked ? CustomPaint(painter: CheckmarkPainter(color: widget.checkColor)) : null,
              ),
              if (widget.label != null) ...[
                const SizedBox(width: 12.0),
                Flexible(
                  child: Text(
                    widget.label!,
                    style:
                        widget.labelStyle ??
                        TextStyle(
                          fontSize: 16.0,
                          color: widget.enabled ? (darkModeValue ? AppColors.darkModeText : Colors.black87) : Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final Color color;

  CheckmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Define checkmark points
    final startPoint = Offset(size.width * 0.25, size.height * 0.5);
    final middlePoint = Offset(size.width * 0.45, size.height * 0.7);
    final endPoint = Offset(size.width * 0.75, size.height * 0.3);

    // Draw complete checkmark
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(middlePoint.dx, middlePoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// Example usage widget
class CheckButtonDemo extends StatefulWidget {
  const CheckButtonDemo({super.key});

  @override
  State<CheckButtonDemo> createState() => _CheckButtonDemoState();
}

class _CheckButtonDemoState extends State<CheckButtonDemo> {
  bool _option1 = false;
  bool _option2 = true;
  bool _option3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Check Button Demo'), backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            CustomCheckButton(isChecked: _option1, onChanged: (value) => setState(() => _option1 = value), label: 'Enable notifications'),

            CustomCheckButton(
              isChecked: _option2,
              onChanged: (value) => setState(() => _option2 = value),
              label: 'Remember me',
              checkedColor: Colors.green,
            ),

            CustomCheckButton(
              isChecked: _option3,
              onChanged: (value) => setState(() => _option3 = value),
              label: 'Accept terms and conditions',
              checkedColor: Colors.purple,
              size: 28.0,
            ),

            const SizedBox(height: 32),

            const Text(
              'Custom Styles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            const CustomCheckButton(isChecked: true, label: 'Disabled checked', enabled: false),

            CustomCheckButton(
              isChecked: false,
              onChanged: (value) {},
              label: 'Custom rounded',
              checkedColor: Colors.orange,
              borderRadius: 12.0,
              size: 32.0,
            ),

            CustomCheckButton(
              isChecked: true,
              onChanged: (value) {},
              label: 'Large with custom text style',
              checkedColor: Colors.red.shade600,
              size: 36.0,
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
