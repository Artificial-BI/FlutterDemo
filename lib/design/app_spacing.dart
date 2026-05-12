import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;

  static const EdgeInsets pageCompact = EdgeInsets.all(lg);
  static const EdgeInsets pageRegular = EdgeInsets.all(xl);
}
