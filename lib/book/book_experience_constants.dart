abstract final class BookDurations {
  static const Duration coverOpen = Duration(milliseconds: 900);
  static const Duration pageTurn = Duration(milliseconds: 560);
}

abstract final class BookThresholds {
  // Treat the book as unlocked only when the cover is visually indistinguishable
  // from fully open, so drag/navigation does not activate prematurely.
  static const double unlockProgress = 0.995;
  static const double coverHiddenProgress = 0.998;
  static const double pageTurnCommitProgress = 0.35;
  static const double coverOpenSnapProgress = 0.28;
  static const double coverDragDirectionDelta = 1.2;
}

abstract final class BookMotion {
  static const double pageTurnPerspective = 0.0018;
  static const double coverPerspective = 0.0019;
  static const double incomingPageBaseScale = 0.975;
  static const double incomingPageScaleRange = 0.025;
  static const double pageTurnTranslate = 24.0;
  static const double coverHoverLift = -12.0;
  static const double coverPressedScale = 0.985;
  static const double coverHoverRotation = -0.012;

  // Keep the cover slightly short of a perfect 180-degree swing so the hinge
  // still reads visually while the cover is considered open.
  static const double coverOpenRotationFactor = 0.93;
  static const double coverDragDeltaClamp = 0.08;
}

abstract final class BookStructureTokens {
  static const double pageContentInset = 14.0;
  static const double bookRadius = 32.0;
  static const double pageRadius = 24.0;
  static const double bookHingeWidth = 22.0;
  static const double coverEdgeWidth = 10.0;
  static const double gridSpacing = 48.0;
}

abstract final class BookDecorationTokens {
  static const double sharedBorderAlpha = 0.24;
  static const double bookFrameBorderAlpha = 0.20;
  static const double pageShadowAlpha = 0.45;
  static const double bookShadowAlpha = 0.50;
  static const double coverShadowAlpha = 0.55;
  static const double coverGlowAlpha = 0.18;
  static const double coverHintFillAlpha = 0.12;
}
