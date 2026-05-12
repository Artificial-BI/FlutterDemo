import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double sm = 12.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}
