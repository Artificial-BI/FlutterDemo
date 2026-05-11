import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/demo_responsive.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _BrightnessTokens {
  static const double initialBrightness = 0.66;
  static const double baseGlowSize = 120.0;
  static const double fallbackGlowSize = 180.0;
  static const double compactRailHeight = 170.0;
  static const double regularRailHeight = 300.0;
  static const double compactRailHeightFactor = 0.82;
  static const double regularRailHeightFactor = 0.86;
  static const double compactOrbBaseSize = 140.0;
  static const double regularOrbBaseSize = 250.0;
  static const double compactOrbWidthFactor = 0.48;
  static const double regularOrbWidthFactor = 0.56;
  static const double compactOrbHeightFactor = 0.72;
  static const double regularOrbHeightFactor = 0.84;
  static const double maxContentWidth = 420.0;
  static const double orbGlowAlphaBase = 0.18;
  static const double orbGlowAlphaRange = 0.5;
  static const double orbShadowAlphaBase = 0.28;
  static const double orbShadowAlphaRange = 0.4;
  static const double orbShadowBlurBase = 30.0;
  static const double orbShadowBlurRange = 90.0;
  static const double orbShadowSpread = 2.0;
  static const double compactContentGap = 16.0;
  static const double regularContentGap = 28.0;
  static const double compactRailWidth = 62.0;
  static const double regularRailWidth = 82.0;
  static const double trackBottomInset = 24.0;
  static const double compactRailHorizontalPadding = 10.0;
  static const double regularRailHorizontalPadding = 12.0;
  static const double railVerticalPadding = 12.0;
  static const double railCornerRadius = 30.0;
  static const double railFillAlpha = 0.11;
  static const double railBorderAlpha = 0.22;
  static const double compactTrackWidth = 18.0;
  static const double regularTrackWidth = 22.0;
  static const double trackCornerRadius = 20.0;
  static const double compactKnobSize = 36.0;
  static const double regularKnobSize = 44.0;
  static const double knobBorderAlpha = 0.25;
  static const double compactKnobIconSize = 16.0;
  static const double regularKnobIconSize = 18.0;
  static const Duration orbTransitionDuration = Duration(milliseconds: 280);
  static const Duration railFillDuration = Duration(milliseconds: 180);
  static const Duration knobAlignDuration = Duration(milliseconds: 160);
}

class BrightnessDimmerPage extends StatefulWidget {
  const BrightnessDimmerPage({super.key});

  @override
  State<BrightnessDimmerPage> createState() => _BrightnessDimmerPageState();
}

class _BrightnessDimmerPageState extends State<BrightnessDimmerPage> {
  double _brightness = _BrightnessTokens.initialBrightness;

  void _setBrightness(double value) {
    final brightness = value.clamp(0.0, 1.0);
    if (brightness == _brightness) {
      return;
    }
    setState(() => _brightness = brightness);
  }

  @override
  Widget build(BuildContext context) {
    final glowSize =
        lerpDouble(
          _BrightnessTokens.baseGlowSize,
          _BrightnessTokens.regularOrbBaseSize,
          _brightness,
        ) ??
        _BrightnessTokens.fallbackGlowSize;
    final safeBrightness = _brightness.clamp(0.0, 1.0);
    const dimTone = Color(0xFF102138);
    final topTone =
        Color.lerp(dimTone, const Color(0xFF355C8C), safeBrightness) ?? dimTone;

    return ShowcasePageShell(
      pageNumber: 3,
      title: 'Reactive Brightness Orb',
      subtitle: 'Vertical drag changes light intensity and scene ambience.',
      hint: 'Drag up and down the dimmer rail to sculpt the room glow.',
      icon: Icons.wb_sunny,
      gradient: [topTone, const Color(0xFF16263C), const Color(0xFF080D17)],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final railHeight = min(
            layout.compact
                ? _BrightnessTokens.compactRailHeight
                : _BrightnessTokens.regularRailHeight,
            constraints.maxHeight *
                (layout.compact
                    ? _BrightnessTokens.compactRailHeightFactor
                    : _BrightnessTokens.regularRailHeightFactor),
          );

          final orbSize = min(
            layout.compact ? _BrightnessTokens.compactOrbBaseSize : glowSize,
            min(
              constraints.maxWidth *
                  (layout.compact
                      ? _BrightnessTokens.compactOrbWidthFactor
                      : _BrightnessTokens.regularOrbWidthFactor),
              constraints.maxHeight *
                  (layout.compact
                      ? _BrightnessTokens.compactOrbHeightFactor
                      : _BrightnessTokens.regularOrbHeightFactor),
            ),
          );

          final orb = AnimatedContainer(
            duration: _BrightnessTokens.orbTransitionDuration,
            width: orbSize,
            height: orbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF3B0).withValues(
                alpha:
                    _BrightnessTokens.orbGlowAlphaBase +
                    (_brightness * _BrightnessTokens.orbGlowAlphaRange),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFE582).withValues(
                    alpha:
                        _BrightnessTokens.orbShadowAlphaBase +
                        (_brightness * _BrightnessTokens.orbShadowAlphaRange),
                  ),
                  blurRadius:
                      _BrightnessTokens.orbShadowBlurBase +
                      (_BrightnessTokens.orbShadowBlurRange * _brightness),
                  spreadRadius: _BrightnessTokens.orbShadowSpread,
                ),
              ],
            ),
          );

          return SizedBox(
            width: min(_BrightnessTokens.maxContentWidth, constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Center(child: orb)),
                SizedBox(
                  width: layout.compact
                      ? _BrightnessTokens.compactContentGap
                      : _BrightnessTokens.regularContentGap,
                ),
                _BrightnessRail(
                  compact: layout.compact,
                  brightness: _brightness,
                  height: railHeight,
                  onBrightnessChanged: _setBrightness,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BrightnessRail extends StatelessWidget {
  const _BrightnessRail({
    required this.compact,
    required this.brightness,
    required this.height,
    required this.onBrightnessChanged,
  });

  final bool compact;
  final double brightness;
  final double height;
  final ValueChanged<double> onBrightnessChanged;

  void _updateFromLocal(Offset local, Size size) {
    if (size.height <= 0) {
      return;
    }
    final brightness = (1 - (local.dy / size.height)).clamp(0.0, 1.0);
    onBrightnessChanged(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact
          ? _BrightnessTokens.compactRailWidth
          : _BrightnessTokens.regularRailWidth,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final trackHeight = max(
            0.0,
            constraints.maxHeight - _BrightnessTokens.trackBottomInset,
          );

          return GestureDetector(
            onTapDown: (details) =>
                _updateFromLocal(details.localPosition, size),
            onVerticalDragUpdate: (details) =>
                _updateFromLocal(details.localPosition, size),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact
                    ? _BrightnessTokens.compactRailHorizontalPadding
                    : _BrightnessTokens.regularRailHorizontalPadding,
                vertical: _BrightnessTokens.railVerticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  _BrightnessTokens.railCornerRadius,
                ),
                color: Colors.white.withValues(
                  alpha: _BrightnessTokens.railFillAlpha,
                ),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: _BrightnessTokens.railBorderAlpha,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: _BrightnessTokens.railFillDuration,
                      width: compact
                          ? _BrightnessTokens.compactTrackWidth
                          : _BrightnessTokens.regularTrackWidth,
                      height: trackHeight * brightness,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          _BrightnessTokens.trackCornerRadius,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFFFFC876), Color(0xFFFFFFA0)],
                        ),
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    duration: _BrightnessTokens.knobAlignDuration,
                    alignment: Alignment(0, 1 - (brightness * 2)),
                    child: Container(
                      width: compact
                          ? _BrightnessTokens.compactKnobSize
                          : _BrightnessTokens.regularKnobSize,
                      height: compact
                          ? _BrightnessTokens.compactKnobSize
                          : _BrightnessTokens.regularKnobSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF141F32),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: _BrightnessTokens.knobBorderAlpha,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.brightness_6,
                        size: compact
                            ? _BrightnessTokens.compactKnobIconSize
                            : _BrightnessTokens.regularKnobIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
