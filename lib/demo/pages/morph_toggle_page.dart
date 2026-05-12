import 'dart:math';

import 'package:flutter/material.dart';

import '../responsive/demo_responsive.dart';
import '../shared/hover_press_surface.dart';
import '../shared/showcase_page_shell.dart';

abstract final class _MorphToggleTokens {
  static const double maxSwitchWidth = 300.0;
  static const double compactWidthAllowance = 8.0;
  static const double compactOffWidth = 220.0;
  static const double regularOffWidth = 224.0;
  static const double regularOnWidth = 300.0;
  static const double compactSwitchHeight = 86.0;
  static const double regularSwitchHeight = 128.0;
  static const double compactKnobSize = 62.0;
  static const double regularKnobSize = 102.0;
  static const double compactInnerPadding = 10.0;
  static const double regularInnerPadding = 12.0;
  static const double enabledCornerRadius = 64.0;
  static const double idleCornerRadius = 30.0;
  static const double trackFillAlpha = 0.24;
  static const double trackBorderAlpha = 0.72;
  static const double trackShadowAlpha = 0.35;
  static const double compactEnabledShadowBlur = 32.0;
  static const double regularEnabledShadowBlur = 42.0;
  static const double idleShadowBlur = 20.0;
  static const double enabledShadowSpread = 3.0;
  static const double idleShadowSpread = 1.0;
  static const double enabledKnobRadius = 50.0;
  static const double idleKnobRadius = 24.0;
  static const double compactIconSize = 34.0;
  static const double regularIconSize = 40.0;
  static const double compactSectionGap = 14.0;
  static const double regularSectionGap = 18.0;
  static const double activeButtonAlpha = 0.32;
  static const double idleButtonAlpha = 0.10;
  static const Duration shellMorphDuration = Duration(milliseconds: 420);
  static const Duration knobMorphDuration = Duration(milliseconds: 360);
}

class MorphTogglePage extends StatefulWidget {
  const MorphTogglePage({super.key});

  @override
  State<MorphTogglePage> createState() => _MorphTogglePageState();
}

class _MorphTogglePageState extends State<MorphTogglePage> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    const onColor = Color(0xFF8E9CFF);
    const offColor = Color(0xFF3A4B63);

    return ShowcasePageShell(
      pageNumber: 4,
      title: 'Mode Toggle Chamber',
      subtitle:
          'Flip between two cinematic ambience states with morphing form.',
      hint:
          'Click the switch for hover lift, press compression, and mode shift.',
      icon: Icons.toggle_on,
      gradient: [
        _enabled ? const Color(0xFF251E48) : const Color(0xFF162233),
        _enabled ? const Color(0xFF1B1F42) : const Color(0xFF152530),
        const Color(0xFF090C16),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = DemoPageLayout.fromConstraints(constraints);
          final maxSwitchWidth = min(
            _MorphToggleTokens.maxSwitchWidth,
            constraints.maxWidth -
                (layout.compact ? _MorphToggleTokens.compactWidthAllowance : 0),
          );
          final offWidth = layout.compact
              ? min(maxSwitchWidth, _MorphToggleTokens.compactOffWidth)
              : _MorphToggleTokens.regularOffWidth;
          final onWidth = layout.compact
              ? maxSwitchWidth
              : _MorphToggleTokens.regularOnWidth;
          final switchHeight = layout.compact
              ? _MorphToggleTokens.compactSwitchHeight
              : _MorphToggleTokens.regularSwitchHeight;
          final knobSize = layout.compact
              ? _MorphToggleTokens.compactKnobSize
              : _MorphToggleTokens.regularKnobSize;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: _MorphToggleTokens.shellMorphDuration,
                curve: Curves.easeOutBack,
                width: _enabled ? onWidth : offWidth,
                height: switchHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: layout.compact
                      ? _MorphToggleTokens.compactInnerPadding
                      : _MorphToggleTokens.regularInnerPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _enabled
                        ? _MorphToggleTokens.enabledCornerRadius
                        : _MorphToggleTokens.idleCornerRadius,
                  ),
                  color: (_enabled ? onColor : offColor).withValues(
                    alpha: _MorphToggleTokens.trackFillAlpha,
                  ),
                  border: Border.all(
                    color: (_enabled ? onColor : offColor).withValues(
                      alpha: _MorphToggleTokens.trackBorderAlpha,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_enabled ? onColor : offColor).withValues(
                        alpha: _MorphToggleTokens.trackShadowAlpha,
                      ),
                      blurRadius: _enabled
                          ? (layout.compact
                                ? _MorphToggleTokens.compactEnabledShadowBlur
                                : _MorphToggleTokens.regularEnabledShadowBlur)
                          : _MorphToggleTokens.idleShadowBlur,
                      spreadRadius: _enabled
                          ? _MorphToggleTokens.enabledShadowSpread
                          : _MorphToggleTokens.idleShadowSpread,
                    ),
                  ],
                ),
                child: AnimatedAlign(
                  duration: _MorphToggleTokens.knobMorphDuration,
                  curve: Curves.easeOutBack,
                  alignment: _enabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: _MorphToggleTokens.knobMorphDuration,
                    curve: Curves.easeOutBack,
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        _enabled
                            ? _MorphToggleTokens.enabledKnobRadius
                            : _MorphToggleTokens.idleKnobRadius,
                      ),
                      color: _enabled
                          ? const Color(0xFFCEC5FF)
                          : const Color(0xFF9AA8B8),
                    ),
                    child: Icon(
                      _enabled ? Icons.nightlight_round : Icons.light_mode,
                      color: const Color(0xFF121A2A),
                      size: layout.compact
                          ? _MorphToggleTokens.compactIconSize
                          : _MorphToggleTokens.regularIconSize,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: layout.compact
                    ? _MorphToggleTokens.compactSectionGap
                    : _MorphToggleTokens.regularSectionGap,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: HoverPressSurface(
                  onTap: () => setState(() => _enabled = !_enabled),
                  padding: EdgeInsets.symmetric(
                    horizontal: layout.compact ? 14 : 18,
                    vertical: layout.compact ? 10 : 12,
                  ),
                  borderRadius: 14,
                  background: _enabled
                      ? const Color(0xFF8E9CFF).withValues(
                          alpha: _MorphToggleTokens.activeButtonAlpha,
                        )
                      : Colors.white.withValues(
                          alpha: _MorphToggleTokens.idleButtonAlpha,
                        ),
                  child: Text(
                    _enabled
                        ? 'Switch To Day Protocol'
                        : 'Switch To Night Protocol',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
