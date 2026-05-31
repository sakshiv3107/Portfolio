import 'package:flutter/material.dart';

class Responsive {
  static const double kMobile = 480;
  static const double kTablet = 768;
  static const double kDesktop = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < kTablet;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= kTablet &&
      MediaQuery.of(context).size.width < kDesktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= kDesktop;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double horizontalPadding(BuildContext context) {
    final w = screenWidth(context);
    if (w < kMobile) return 16;
    if (w < kTablet) return 24;
    if (w < kDesktop) return 40;
    return 48;
  }

  static int projectGridColumns(BuildContext context) =>
      isMobile(context) ? 1 : 2;
}
