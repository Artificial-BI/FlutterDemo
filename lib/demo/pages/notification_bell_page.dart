import 'dart:math';

import 'package:flutter/material.dart';

import '../animation/demo_animation.dart';
import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _NotificationBellTokens {
  static const int initialBadgeCount = 2;
  static const int maxBadgeCount = 99;
  static const double compactAreaSize = 210.0;
  static const double regularAreaSize = 340.0;
  static const double compactAreaWidthFactor = 0.72;
  static const double regularAreaWidthFactor = 0.9;
  static const double compactAreaHeightFactor = 0.74;
  static const double regularAreaHeightFactor = 0.95;
  static const double bellMaxSize = 170.0;
  static const double bellAreaFactor = 0.52;
  static const double badgeMaxSize = 42.0;
  static const double badgeMinSize = 32.0;
  static const double badgeAreaFactor = 0.13;
  static const double wiggleCycles = 8.0;
  static const double wiggleAmplitude = 0.2;
  static const double badgePulseCycles = 6.0;
  static const double badgeScaleRange = 0.34;
  static const int ringCount = 2;
  static const double ringDelayStep = 0.2;
  static const double ringBaseBellFactor = 0.78;
  static const double ringGrowthAreaFactor = 0.72;
  static const double ringAlphaBase = 0.4;
  static const double ringStrokeWidth = 2.0;
  static const double bellFillAlpha = 0.85;
  static const double bellBorderAlpha = 0.48;
  static const double iconMaxSize = 72.0;
  static const double iconBellFactor = 0.42;
  static const double badgeOffsetFactor = 0.72;
  static const double badgeGlowAlpha = 0.44;
  static const double badgeGlowBlur = 18.0;
  static const double compactBadgeFontSize = 12.0;
  static const double regularBadgeFontSize = 14.0;
  static const double compactBadgeFontThreshold = 38.0;
}

class NotificationBellPage extends StatefulWidget {
  const NotificationBellPage({super.key});

  @override
  State<NotificationBellPage> createState() => _NotificationBellPageState();
}

class _NotificationBellPageState
    extends ManagedTickerState<NotificationBellPage> {
  late final AnimationController _wiggle;
  late final AnimationController _ring;
  late final Listenable _effects;

  int _badge = _NotificationBellTokens.initialBadgeCount;

  @override
  void initState() {
    super.initState();
    _wiggle = createAnimationController(
      duration: DemoDurations.notificationWiggle,
    );
    _ring = createAnimationController(duration: DemoDurations.notificationRing);
    _effects = Listenable.merge(<Listenable>[_wiggle, _ring]);
  }

  void _triggerBell() {
    setState(() {
      _badge = min(_badge + 1, _NotificationBellTokens.maxBadgeCount);
    });
    _wiggle.forward(from: 0);
    _ring.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePageShell(
      pageNumber: 7,
      title: 'Notification Bell',
      subtitle:
          'Short wiggle, ripple rings, and badge pop for satisfying feedback.',
      hint: 'Tap the bell to trigger a compact alert animation and settle.',
      icon: Icons.notifications_active,
      gradient: const [Color(0xFF182337), Color(0xFF121A2D), Color(0xFF080D16)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final areaSize = min(
            layout.compact
                ? _NotificationBellTokens.compactAreaSize
                : _NotificationBellTokens.regularAreaSize,
            min(
              constraints.maxWidth *
                  (layout.compact
                      ? _NotificationBellTokens.compactAreaWidthFactor
                      : _NotificationBellTokens.regularAreaWidthFactor),
              constraints.maxHeight *
                  (layout.compact
                      ? _NotificationBellTokens.compactAreaHeightFactor
                      : _NotificationBellTokens.regularAreaHeightFactor),
            ),
          );
          final bellSize = min(
            _NotificationBellTokens.bellMaxSize,
            areaSize * _NotificationBellTokens.bellAreaFactor,
          );
          final bellRadius = bellSize / 2;
          final badgeSize = min(
            _NotificationBellTokens.badgeMaxSize,
            max(
              _NotificationBellTokens.badgeMinSize,
              areaSize * _NotificationBellTokens.badgeAreaFactor,
            ),
          );

          return AnimatedBuilder(
            animation: _effects,
            builder: (context, _) {
              final wiggle =
                  sin(
                    _wiggle.value * pi * _NotificationBellTokens.wiggleCycles,
                  ) *
                  (1 - _wiggle.value) *
                  _NotificationBellTokens.wiggleAmplitude;
              final ring = Curves.easeOut.transform(_ring.value);
              final badgeScale =
                  1 +
                  (sin(
                        _wiggle.value *
                            pi *
                            _NotificationBellTokens.badgePulseCycles,
                      ).abs() *
                      _NotificationBellTokens.badgeScaleRange);

              return SizedBox(
                width: areaSize,
                height: areaSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(_NotificationBellTokens.ringCount, (
                      index,
                    ) {
                      final delay =
                          index * _NotificationBellTokens.ringDelayStep;
                      final local = ((ring - delay) / (1 - delay)).clamp(
                        0.0,
                        1.0,
                      );
                      final ringSize =
                          (bellSize *
                              _NotificationBellTokens.ringBaseBellFactor) +
                          (local *
                              areaSize *
                              _NotificationBellTokens.ringGrowthAreaFactor);
                      return IgnorePointer(
                        child: Container(
                          width: ringSize,
                          height: ringSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF66E7FF).withValues(
                                alpha:
                                    (_NotificationBellTokens.ringAlphaBase *
                                            (1 - local))
                                        .clamp(0.0, 1.0),
                              ),
                              width: _NotificationBellTokens.ringStrokeWidth,
                            ),
                          ),
                        ),
                      );
                    }),
                    Transform.rotate(
                      angle: wiggle,
                      child: HoverPressSurface(
                        onTap: _triggerBell,
                        width: bellSize,
                        height: bellSize,
                        borderRadius: bellRadius,
                        alignment: Alignment.center,
                        background: const Color(0xFF1A2A42).withValues(
                          alpha: _NotificationBellTokens.bellFillAlpha,
                        ),
                        border: Border.all(
                          color: const Color(0xFF66E7FF).withValues(
                            alpha: _NotificationBellTokens.bellBorderAlpha,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications,
                          size: min(
                            _NotificationBellTokens.iconMaxSize,
                            bellSize * _NotificationBellTokens.iconBellFactor,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(
                          bellRadius *
                              _NotificationBellTokens.badgeOffsetFactor,
                          -bellRadius *
                              _NotificationBellTokens.badgeOffsetFactor,
                        ),
                        child: Transform.scale(
                          scale: badgeScale,
                          child: Container(
                            width: badgeSize,
                            height: badgeSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF6B86),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B86).withValues(
                                    alpha:
                                        _NotificationBellTokens.badgeGlowAlpha,
                                  ),
                                  blurRadius:
                                      _NotificationBellTokens.badgeGlowBlur,
                                ),
                              ],
                            ),
                            child: Text(
                              '$_badge',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontSize:
                                        badgeSize <
                                            _NotificationBellTokens
                                                .compactBadgeFontThreshold
                                        ? _NotificationBellTokens
                                              .compactBadgeFontSize
                                        : _NotificationBellTokens
                                              .regularBadgeFontSize,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
