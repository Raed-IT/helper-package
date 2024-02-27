import 'package:flutter/material.dart';

class HelperLoadingButtonWidget extends StatefulWidget {
  final Future<void> Function() onTap;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? fontSize;
  final double? width;
  final double? radius;
  final double? shadow;
  final bool enable;

  const HelperLoadingButtonWidget(
      {super.key,
      required this.onTap,
      required this.label,
      this.backgroundColor,
      this.enable = false,
      this.textColor,
      this.height,
      this.fontSize,
      this.width,
      this.radius,
      this.shadow});

  @override
  State<HelperLoadingButtonWidget> createState() =>
      _HelperLoadingButtonWidgetState();
}

class _HelperLoadingButtonWidgetState extends State<HelperLoadingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: widget.height ?? 20,
      width: widget.width ?? size.width,
      child: Card(
        color: widget.backgroundColor,
        child: Center(
          child: Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: widget.textColor, fontSize: widget.fontSize),
          ),
        ),
      ),
    );
  }
}
