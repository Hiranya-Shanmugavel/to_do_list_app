import 'package:flutter/material.dart';

/// ResponsiveContainer Widget
///
/// Ensures the application layout is responsive across laptop/desktop screens
/// and mobile viewports.
/// On desktop browsers, it centers content and constrains max width to [maxWidth]
/// (default 768px) to avoid over-stretching, while providing full-width comfortable
/// ergonomics on mobile screens.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 768.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
