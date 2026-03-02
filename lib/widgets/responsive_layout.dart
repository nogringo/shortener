import 'package:flutter/material.dart';

/// A responsive layout widget that adapts to different screen sizes.
///
/// Breakpoints:
/// - Mobile: < 840dp
/// - Desktop: >= 840dp
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? desktop;

  const ResponsiveLayout({super.key, required this.mobile, this.desktop});

  /// Check if the current screen is mobile-sized
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 840;
  }

  /// Check if the current screen is desktop-sized
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 840;
  }

  /// Get the current screen type
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 840) return ScreenType.mobile;
    return ScreenType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840 && desktop != null) {
          return desktop!;
        } else {
          return mobile;
        }
      },
    );
  }
}

enum ScreenType { mobile, desktop }

/// A widget that constrains its child to a maximum width for better readability
/// on large screens, while maintaining proper padding.
class ConstrainedContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = 800,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
