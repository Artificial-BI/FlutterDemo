import 'dart:math';

import 'package:flutter/material.dart';

abstract final class DemoBreakpoints {
  static const double bookPhoneWidth = 520;
  static const double bookNarrowWidth = 700;
  static const double bookShortHeight = 780;
  static const double bookCompactNavigationHeight = 720;
  static const double bookCoverCompactWidth = 560;

  static const double pageShellCompactWidth = 430;
  static const double pageShellShortHeight = 470;
  static const double pageShellVeryShortHeight = 360;

  static const double pageCompactWidth = 460;
  static const double pageCompactHeight = 320;
}

abstract final class _BookLayoutTokens {
  static const double phoneWidthFactor = 0.97;
  static const double narrowWidthFactor = 0.96;
  static const double regularWidthFactor = 0.92;
  static const double maxBookWidth = 1000.0;

  static const double phoneHeightFactor = 0.82;
  static const double shortHeightFactor = 0.72;
  static const double narrowHeightFactor = 0.74;
  static const double regularHeightFactor = 0.76;
  static const double phoneMaxHeight = 720.0;
  static const double narrowMaxHeight = 640.0;
  static const double regularMaxHeight = 690.0;
}

class BookLayout {
  const BookLayout._({
    required this.phone,
    required this.narrow,
    required this.short,
    required this.compactNavigation,
    required this.coverCompact,
    required this.bookWidth,
    required this.bookHeight,
  });

  factory BookLayout.fromConstraints(BoxConstraints constraints) {
    final phone = constraints.maxWidth < DemoBreakpoints.bookPhoneWidth;
    final narrow = constraints.maxWidth < DemoBreakpoints.bookNarrowWidth;
    final short = constraints.maxHeight < DemoBreakpoints.bookShortHeight;

    final bookWidth = min(
      constraints.maxWidth *
          (phone
              ? _BookLayoutTokens.phoneWidthFactor
              : (narrow
                    ? _BookLayoutTokens.narrowWidthFactor
                    : _BookLayoutTokens.regularWidthFactor)),
      _BookLayoutTokens.maxBookWidth,
    );

    final bookHeight = min(
      constraints.maxHeight *
          (phone
              ? _BookLayoutTokens.phoneHeightFactor
              : (short
                    ? _BookLayoutTokens.shortHeightFactor
                    : (narrow
                          ? _BookLayoutTokens.narrowHeightFactor
                          : _BookLayoutTokens.regularHeightFactor))),
      phone
          ? _BookLayoutTokens.phoneMaxHeight
          : (narrow
                ? _BookLayoutTokens.narrowMaxHeight
                : _BookLayoutTokens.regularMaxHeight),
    );

    return BookLayout._(
      phone: phone,
      narrow: narrow,
      short: short,
      compactNavigation:
          phone ||
          constraints.maxHeight < DemoBreakpoints.bookCompactNavigationHeight,
      coverCompact: bookWidth < DemoBreakpoints.bookCoverCompactWidth,
      bookWidth: bookWidth,
      bookHeight: bookHeight,
    );
  }

  final bool phone;
  final bool narrow;
  final bool short;
  final bool compactNavigation;
  final bool coverCompact;
  final double bookWidth;
  final double bookHeight;
}

class DemoPageShellLayout {
  const DemoPageShellLayout._({
    required this.compact,
    required this.short,
    required this.veryShort,
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.sectionGap,
    required this.textGap,
    required this.iconSize,
    required this.primaryOrbSize,
    required this.secondaryOrbSize,
    required this.accentOrbSize,
    required this.pageLabelSpacing,
    required this.titleFontSize,
    required this.titleLetterSpacing,
    required this.titleHeight,
    required this.subtitleFontSize,
    required this.subtitleHeight,
    required this.hintFontSize,
  });

  factory DemoPageShellLayout.fromConstraints(BoxConstraints constraints) {
    final compact =
        constraints.maxWidth < DemoBreakpoints.pageShellCompactWidth;
    final short = constraints.maxHeight < DemoBreakpoints.pageShellShortHeight;
    final veryShort =
        constraints.maxHeight < DemoBreakpoints.pageShellVeryShortHeight;

    return DemoPageShellLayout._(
      compact: compact,
      short: short,
      veryShort: veryShort,
      horizontalPadding: compact ? 14.0 : 24.0,
      topPadding: veryShort ? 10.0 : (short ? 12.0 : (compact ? 16.0 : 22.0)),
      bottomPadding: veryShort ? 10.0 : (compact ? 12.0 : 24.0),
      sectionGap: veryShort ? 8.0 : (short ? 10.0 : 16.0),
      textGap: veryShort ? 4.0 : (short ? 6.0 : 8.0),
      iconSize: compact ? 34.0 : 42.0,
      primaryOrbSize: compact ? 220.0 : 260.0,
      secondaryOrbSize: compact ? 190.0 : 220.0,
      accentOrbSize: compact ? 120.0 : 140.0,
      pageLabelSpacing: compact ? 10.0 : 12.0,
      titleFontSize: veryShort ? 18.0 : (compact ? 20.0 : 24.0),
      titleLetterSpacing: compact ? 0.5 : 1.0,
      titleHeight: compact ? 1.05 : 1.1,
      subtitleFontSize: veryShort ? 12.5 : (compact ? 13.5 : 16.0),
      subtitleHeight: compact ? 1.2 : 1.35,
      hintFontSize: veryShort ? 11.0 : (compact ? 12.0 : 14.0),
    );
  }

  final bool compact;
  final bool short;
  final bool veryShort;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double sectionGap;
  final double textGap;
  final double iconSize;
  final double primaryOrbSize;
  final double secondaryOrbSize;
  final double accentOrbSize;
  final double pageLabelSpacing;
  final double titleFontSize;
  final double titleLetterSpacing;
  final double titleHeight;
  final double subtitleFontSize;
  final double subtitleHeight;
  final double hintFontSize;
}

class DemoPageLayout {
  const DemoPageLayout._({required this.compact});

  factory DemoPageLayout.fromConstraints(BoxConstraints constraints) {
    return DemoPageLayout._(
      compact:
          constraints.maxWidth < DemoBreakpoints.pageCompactWidth ||
          constraints.maxHeight < DemoBreakpoints.pageCompactHeight,
    );
  }

  final bool compact;
}
