import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'E-Ticketing Helpdesk';
  static const String appVersion = '1.0.0';

  static const double maxContentWidth = 980.0;
  static const double sectionGap = 20.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  static const List<List<Color>> dashboardGradients = [
    [Color(0xFF7C3AED), Color(0xFF9F67F5)],
    [Color(0xFF2563EB), Color(0xFF60A5FA)],
    [Color(0xFF059669), Color(0xFF34D399)],
    [Color(0xFFD97706), Color(0xFFFBBF24)],
  ];
}
